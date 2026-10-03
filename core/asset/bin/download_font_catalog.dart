#!/usr/bin/env -S fvm dart run

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:http/http.dart' as http;
import 'package:skia/skia.dart' as skia;

enum CatalogMode {
  builtin,
  server,
}

/// Downloads the font catalog, and puts the result either into a local SQLite database, or into a local directory.
Future<void> main(List<String> args) async {
  final packageRoot = Platform.script.resolve('../');
  final root = packageRoot.resolve('../../');
  final fontFileCacheRoot = packageRoot.resolve('build/cache/');

  final env = dotenv.DotEnv()..load([root.resolve('.env').toFilePath()]);
  final googleFontsKey = env['GOOGLE_FONTS_API_KEY'] ?? (throw ArgumentError('GOOGLE_FONTS_API_KEY not set in .env'));

  final CatalogMode mode = switch (args.firstOrNull) {
    '--builtin' => .builtin,
    '--server' => .server,
    _ => throw ArgumentError('Unknown catalog mode: ${args.firstOrNull}'),
  };

  final outRoot = Directory.fromUri(packageRoot.resolve('build/out/${mode.name}'));
  print('Selected catalog mode: $mode (output into ${outRoot.path})');

  final fontFamiliesFile = packageRoot.resolve('config/').resolve(switch (mode) {
    .builtin => 'builtin_font_families.json',
    .server => 'server_font_families.json',
  });

  final families = (jsonDecode(await File.fromUri(fontFamiliesFile).readAsString()) as List).cast<String>();
  final client = http.Client();

  final fontLicences = <Hash, AssetLicense>{};
  final fontAssets = <Hash, FontAsset>{};
  final fontFiles = <Hash, Uint8List>{};

  try {
    for (final family in families) {
      final variantUrls = await _loadFontVariants(client, googleFontsKey, family);
      final license = await _loadFontLicense(client, family);

      final files = <Hash, FontFile>{};

      var size = 0;
      var faceCount = 0;

      fontLicences[license.hash] = .new(
        hash: license.hash,
        descriptor: family,
        kind: license.id,
        body: utf8.decode(license.bytes),
      );

      for (final url in variantUrls) {
        final urlHash = Hash.compute(utf8.encode(url));
        final cachedFile = File.fromUri(fontFileCacheRoot.resolve(urlHash.shortHash));
        final Uint8List bytes;

        if (await cachedFile.exists()) {
          bytes = await cachedFile.readAsBytes();
        } else {
          bytes = await client.readBytes(Uri.parse(url).replace(scheme: 'https'));
          await Directory.fromUri(fontFileCacheRoot).create(recursive: true);
          await cachedFile.writeAsBytes(bytes);
        }

        final hash = Hash.compute(bytes);
        if (fontFiles[hash] != null) {
          print('${hash.shortHash}: cached');
          continue;
        }

        final faces = _parseFontFaces(bytes);
        if (faces.isEmpty) {
          print('${hash.shortHash}: not a font: $url');
          continue;
        }

        files[hash] = .new(
          hash: hash,
          size: bytes.length,
          faces: faces,
        );

        fontFiles[hash] = bytes;
        size += bytes.length;
        faceCount += faces.length;
      }

      if (files.isEmpty) throw StateError('no valid font files found for $family');

      final bestThumbnailFace = _bestThumbnailFace(files);
      final thumbnail = _createThumbnail(fontFiles[bestThumbnailFace.$1]!, bestThumbnailFace.$2);

      final asset = FontAsset(
        hash: .combine(family, files.values.map((f) => f.hash)),
        family: family,
        files: files.values.toList(),
        licenseHash: license.hash,
        thumbnail: thumbnail,
        size: size,
      );

      final kb = (size / 1000).round();

      fontAssets[asset.hash] = asset;
      print(
        '${asset.hash.shortHash}: $family loaded ${files.length} files, total size: ${kb}KB, total faces: $faceCount',
      );
    }
  } finally {
    client.close();
  }

  final fontCatalog = FontCatalog(assets: fontAssets);
  final licenseBundle = LicenseBundle(licenses: fontLicences);
  if (outRoot.existsSync()) await outRoot.delete(recursive: true);
  await outRoot.create(recursive: true);

  // Output: catalog and license bundle as two .pb files, fonts as /fonts/{hash}.pb
  final fontCatalogFile = File.fromUri(outRoot.uri.resolve('font_catalog.pb'));
  final licenseBundleFile = File.fromUri(outRoot.uri.resolve('license_bundle.pb'));
  final fontsDir = Directory.fromUri(outRoot.uri.resolve('fonts'));
  await fontsDir.create(recursive: true);

  await fontCatalogFile.writeAsBytes(fontCatalog.encode().writeToBuffer());
  await licenseBundleFile.writeAsBytes(licenseBundle.encode().writeToBuffer());

  for (final entry in fontFiles.entries) {
    final hash = entry.key;
    final bytes = entry.value;
    final fontFile = File.fromUri(fontsDir.uri.resolve('$hash'));
    await fontFile.writeAsBytes(bytes);
  }

  // Calculate the total size
  var outSize = 0;
  for (final f in outRoot.listSync(recursive: true).whereType<File>()) {
    outSize += f.lengthSync();
  }

  final outSizeKb = (outSize / 1000).round();
  print('Completed: ${outRoot.path} (${outSizeKb}KB)');
}

// ---------------------------------------------------------------------------------------------------------------------
// Google Fonts
// ---------------------------------------------------------------------------------------------------------------------

Future<List<String>> _loadFontVariants(http.Client client, String key, String family) async {
  final uri = Uri.https('www.googleapis.com', '/webfonts/v1/webfonts', {'key': key, 'family': family});
  final result = await client.read(uri);
  final items = (jsonDecode(result)['items'] as List).cast<Map<String, dynamic>>();
  final item = items.where((i) => i['family'] == family).firstOrNull ?? (throw StateError('unknown family: $family'));
  return (item['files'] as Map).values.cast<String>().toList();
}

Future<({String id, Hash hash, Uint8List bytes})> _loadFontLicense(http.Client client, String family) async {
  const layouts = [
    ('ofl', 'OFL.txt', 'OFL-1.1'),
    ('apache', 'LICENSE.txt', 'Apache-2.0'),
    ('ufl', 'UFL.txt', 'UFL-1.0'),
  ];

  final slug = family.toLowerCase().replaceAll(' ', '');
  for (final (dir, file, id) in layouts) {
    final r = await client.get(Uri.https('raw.githubusercontent.com', '/google/fonts/main/$dir/$slug/$file'));
    if (r.statusCode == 200) return (id: id, hash: Hash.compute(r.bodyBytes), bytes: r.bodyBytes);
  }

  throw StateError('no license found for $family');
}

// ---------------------------------------------------------------------------------------------------------------------
// Font parsing
// ---------------------------------------------------------------------------------------------------------------------

List<FontFace> _parseFontFaces(Uint8List bytes) {
  final fontFile = skia.FontFile.create(bytes);
  if (fontFile == null) return [];

  return fontFile.faces
      .map((f) => FontFace(index: f.index, weight: f.weight, width: f.width, slant: f.slant, family: f.family))
      .toList();
}

(Hash, FontFace) _bestThumbnailFace(Map<Hash, FontFile> files) {
  int distance(FontFace f) {
    final slantFactor = f.slant == .upright ? 0 : 10000;
    final weightFactor = (f.weight - 400).abs() * 10;
    final widthFactor = (f.width - 5).abs();
    return slantFactor + weightFactor + widthFactor;
  }

  final tupled = <(Hash, FontFace)>[];
  for (final e in files.entries) {
    for (final f in e.value.faces) tupled.add((e.key, f));
  }

  return tupled.reduce((a, b) => distance(a.$2) <= distance(b.$2) ? a : b);
}

FontFamilyThumbnail _createThumbnail(Uint8List bytes, FontFace face) {
  final provider = skia.FontProvider();
  provider.add(bytes);

  final style = skia.TextStyle(
    fontFamilies: [face.family],
    fontSize: 32.0,
    fontStyle: .new(
      weight: face.weight,
      width: face.width,
      slant: face.slant,
    ),
  );

  final paragraphBuilder = skia.ParagraphBuilder(.new(), provider);

  var text = face.family.trim();
  if (text.length > 20) text = text.substring(0, 20);

  paragraphBuilder.pushStyle(style);
  paragraphBuilder.addText(text);

  final paragraph = paragraphBuilder.build();
  paragraph.layout(.infinity);

  final path = paragraph.getPath();
  return FontFamilyThumbnail(
    width: paragraph.maxIntrinsicWidth,
    height: paragraph.height,
    path: path,
  );
}
