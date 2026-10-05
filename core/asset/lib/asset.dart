import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:schema/asset.dart' as gen;
import 'package:schema/codec.dart' as codec;
import 'package:skia/skia.dart' as skia;

export 'package:schema/codec/asset_codec.dart';

part 'font_catalog.dart';
part 'license.dart';
part 'manifest.dart';

sealed class const Asset({
  required final Hash hash,
  required final int size,
}) {
  factory decode(gen.Asset bundle) => bundle.decode();
  static Asset? decodeRaw(Uint8List data) => codec.decodeRaw(() => .decode(.fromBuffer(data)));
}

final class const FontAsset({
  required super.hash,
  required super.size,
  required final String family,
  required final Hash license,
  required final List<FontFace> faces,
}) extends Asset;

final class const FontFace({
  required final String family,
  required final int index,
  required final skia.FontWeight weight,
  required final skia.FontWidth width,
  required final skia.FontSlant slant,
  final FontFaceThumbnail? thumbnail,
}) {
  FontFace copyWith({
    String? family,
    int? index,
    skia.FontWeight? weight,
    skia.FontWidth? width,
    skia.FontSlant? slant,
    FontFaceThumbnail? thumbnail,
  }) => .new(
    family: family ?? this.family,
    index: index ?? this.index,
    weight: weight ?? this.weight,
    width: width ?? this.width,
    slant: slant ?? this.slant,
    thumbnail: thumbnail ?? this.thumbnail,
  );
}

final class const ImageAsset({
  required super.hash,
  required super.size,
  required final int width,
  required final int height,
  required final String mimeType,
}) extends Asset;

final class const FontFaceThumbnail({
  required final skia.Path path,
  required final double width,
  required final double height,
});

extension FontFaceResolver on Iterable<FontFace> {
  FontFace? resolveExact({
    required skia.FontWeight weight,
    required skia.FontWidth width,
    required skia.FontSlant slant,
  }) => firstWhereOrNull(
    (f) => f.weight == weight && f.width == width && f.slant == slant,
  );

  FontFace resolveClosest({
    required skia.FontWeight weight,
    required skia.FontWidth width,
    required skia.FontSlant slant,
  }) {
    int distance(FontFace f) =>
        (f.slant == slant ? 0 : 10000) +
        (f.width.value - width.value).abs() * 1000 +
        (f.weight.value - weight.value).abs();

    return reduce((a, b) => distance(a) < distance(b) ? a : b);
  }
}
