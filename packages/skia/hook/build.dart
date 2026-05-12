// ignore_for_file: avoid_print

import 'dart:io';
import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

import 'package:skia/src/config.dart' as config;

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    final root = input.packageRoot;

    final packages = Map.fromEntries(
      config.packages.map((p) => MapEntry(p, root.resolve('../$p/'))),
    );

    final code = input.config.code;
    final os = code.targetOS;
    final arch = code.targetArchitecture;

    final platformDir = switch ((os, arch)) {
      (.macOS, _) => 'macos-${arch.name}',
      (.iOS, _) when (code.iOS.targetSdk == .iPhoneOS) => 'iphoneos-${arch.name}',
      (.iOS, _) when (code.iOS.targetSdk == .iPhoneSimulator) => 'iphonesimulator-${arch.name}',
      _ => throw Exception('Unsupported platform: $os-$arch'),
    };

    final libDir = root.resolve('build/$platformDir/Release/');
    final headers = root.resolve('include/');

    // TODO: use ICU data in build.
    final icuData = root.resolve('build/share/icudtl.dat');

    if (!Directory.fromUri(libDir).existsSync()) {
      throw Exception('Library directory not found: $libDir. Is it built?');
    }

    final skiaLibs = <String>[
      'skparagraph',
      'skshaper',
      'skia',
      'skunicode_icu',
      'skunicode_core',
    ];

    for (final lib in skiaLibs) {
      final p = libDir.resolve('lib$lib.a').toFilePath();
      if (!File(p).existsSync()) {
        throw Exception('Library not found: $p');
      }
    }

    final frameworks = <String>[];
    if (os == .macOS || os == .iOS) {
      frameworks.addAll([
        'CoreFoundation',
        'CoreText',
        'CoreGraphics',
        'CoreServices',
      ]);
    }

    final packageSources = <Uri>[];
    final packageHeaders = <Uri>[];
    final packageIncludes = <Uri>[];

    /* Package source collection */
    for (final package in packages.entries) {
      final srcDir = package.value.resolve('src');
      if (!Directory.fromUri(srcDir).existsSync()) {
        print('Source directory not found for package ${package.key}: $srcDir. Skipping.');
        continue;
      }

      packageIncludes.add(srcDir);
      for (final entry in Directory.fromUri(srcDir).listSync(recursive: true).whereType<File>()) {
        final path = entry.path;
        if (path.endsWith('.cpp') || path.endsWith('.c') || path.endsWith('.cc')) {
          packageSources.add(Uri.file(path));
        } else if (path.endsWith('.h') || path.endsWith('.hpp')) {
          packageHeaders.add(Uri.file(path));
        }
      }
    }

    if (packageSources.isEmpty) {
      print('No source files found in packages.');
      return;
    }

    final builder = CBuilder.library(
      name: 'skia',
      assetName: 'src/asset.dart',
      language: .cpp,
      cppLinkStdLib: 'c++',
      sources: packageSources.map((u) => u.toFilePath()).toList(),
      includes: [
        ...packageIncludes.map((u) => u.toFilePath()),
      ],
      frameworks: frameworks,
      libraries: skiaLibs,
      libraryDirectories: [libDir.toFilePath()],
      optimizationLevel: .o0,
      flags: [
        '-std=c++17',
        '-fno-rtti',
        '-fvisibility=hidden',
        '-fvisibility-inlines-hidden',

        '-I', headers.toFilePath(),
        '-I', root.toFilePath(),

        // Frameworks
        for (final fw in frameworks) ...['-framework', fw],

        if (os == .macOS || os == .iOS) '-Wl,-dead_strip',
        if (os == .linux) '-Wl,--gc-sections',
      ],
    );

    await builder.run(input: input, output: output);

    for (final lib in skiaLibs) output.dependencies.add(libDir.resolve(lib));
    output.dependencies.add(headers);

    for (final p in [...packageSources, ...packageHeaders]) output.dependencies.add(p);
  });
}
