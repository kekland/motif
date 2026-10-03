import 'dart:convert';
import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:schema/asset.dart' as gen;
import 'package:schema/codec.dart' as codec;
import 'package:skia/skia.dart' as skia;
import 'package:crypto/crypto.dart' as crypto;

export 'package:schema/codec/asset_codec.dart';

part 'hash.dart';
part 'font_catalog.dart';
part 'license.dart';

sealed class const Asset({
  required final Hash hash,
  required final int size,
}) {
  factory decode(gen.Asset asset) => asset.decode();
  static Asset? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));

  AssetId get id;
}

final class FontAsset({
  required super.hash,
  required super.size,
  required final Hash licenseHash,
  required final String family,
  required final List<FontFile> files,
  required final FontFamilyThumbnail thumbnail,
}) extends Asset {
  @override
  FontFamilyId get id => .new(hash: hash, name: family);

  late final Set<skia.FontWeight> weights = files.expand((file) => file.weights).toSet();
  late final Set<skia.FontWidth> widths = files.expand((file) => file.widths).toSet();
  late final Set<skia.FontSlant> slants = files.expand((file) => file.slants).toSet();

  FontFile? resolveFile({
    required skia.FontWeight weight,
    required skia.FontWidth width,
    required skia.FontSlant slant,
  }) {
    return files.firstWhereOrNull(
      (f) => f.faces.any((face) => face.weight == weight && face.width == width && face.slant == slant),
    );
  }
}

final class FontFile({
  required final Hash hash,
  required final int size,
  required final List<FontFace> faces,
}) {
  FontFileId get id => .new(hash: hash);

  late final Set<skia.FontWeight> weights = faces.map((face) => face.weight).toSet();
  late final Set<skia.FontWidth> widths = faces.map((face) => face.width).toSet();
  late final Set<skia.FontSlant> slants = faces.map((face) => face.slant).toSet();
}

final class FontFace({
  required final int index,
  required final String family,
  required final skia.FontWeight weight,
  required final skia.FontWidth width,
  required final skia.FontSlant slant,
});

final class const FontFamilyThumbnail({
  required final skia.Path path,
  required final double width,
  required final double height,
}) {
  factory decode(gen.FontFamilyThumbnail thumbnail) => thumbnail.decode();
}

final class const ImageAsset({
  required super.hash,
  required super.size,
  required final int width,
  required final int height,
  required final String mimeType,
}) extends Asset {
  @override
  ImageId get id => .new(hash: hash);
}

sealed class AssetId({required final Hash hash}) {
  @override
  int get hashCode => hash.value.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AssetId) return false;
    if (runtimeType != other.runtimeType) return false;
    return hash == other.hash;
  }
}

final class FontFamilyId({required super.hash, required final String name}) extends AssetId;
final class FontFileId({required super.hash}) extends AssetId;
final class ImageId({required super.hash}) extends AssetId;
