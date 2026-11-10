import 'dart:typed_data';

import 'package:shared/shared.dart';

final class const LineMetrics({
  required final double left,
  required final double baseline,
  required final double ascent,
  required final double descent,
  required final double width,
  required final double height,
  required final int glyphStart,
  required final int glyphEnd,
});

extension type const GlyphSynthetic(int value) implements int {
  static const none = GlyphSynthetic(0);
  static const embolden = GlyphSynthetic(1);
  static const skew = GlyphSynthetic(2);

  bool get isNone => value == 0;
  bool get isEmbolden => value & 1 != 0;
  bool get isSkew => value & 2 != 0;
}

final class const GlyphMetrics({
  required final double x,
  required final double y,
  required final double left,
  required final double top,
  required final double right,
  required final double bottom,
  required final int id,
  required final int font,
  required final int typefaceId,
  required final GlyphSynthetic synthetic,
});

extension type const PathVerb._(int value) {
  static const move = PathVerb._(0);
  static const line = PathVerb._(1);
  static const quad = PathVerb._(2);
  static const conic = PathVerb._(3);
  static const cubic = PathVerb._(4);
  static const close = PathVerb._(5);

  int get points => switch (this) {
    .move => 1,
    .line => 1,
    .quad => 2,
    .conic => 2,
    .cubic => 3,
    .close => 0,
    _ => unreachable(),
  };
}

extension type const PathVerbList(Uint8List value) implements Uint8List {
  PathVerbList.fromList(List<int> value) : this(Uint8List.fromList(value));

  int get length => value.length;
  PathVerb operator [](int index) => PathVerb._(value[index]);
}

final class Path {
  Path({required this.verbs, required this.points});

  static Path join(Iterable<Path> paths, {(double, double) Function(int i)? offset}) {
    final verbCount = paths.fold<int>(0, (s, p) => s + p.verbs.length);
    final pointCount = paths.fold<int>(0, (s, p) => s + p.points.length);

    final verbs = Uint8List(verbCount);
    final points = Float32List(pointCount);

    var verbOffset = 0;
    var pointOffset = 0;
    for (final (i, path) in paths.indexed) {
      verbs.setRange(verbOffset, verbOffset + path.verbs.length, path.verbs);
      verbOffset += path.verbs.length;

      final (x, y) = offset?.call(i) ?? (0, 0);
      for (var j = 0; j < path.points.length; j += 2) {
        points[pointOffset + j] = path.points[j] + x;
        points[pointOffset + j + 1] = path.points[j + 1] + y;
      }

      pointOffset += path.points.length;
    }

    return Path(verbs: .new(verbs), points: points);
  }

  final PathVerbList verbs;
  final Float32List points;
}

extension type const FontWeight(int value) implements int {
  static const invisible = FontWeight(0);
  static const thin = FontWeight(100);
  static const extraLight = FontWeight(200);
  static const light = FontWeight(300);
  static const regular = FontWeight(400);
  static const medium = FontWeight(500);
  static const semiBold = FontWeight(600);
  static const bold = FontWeight(700);
  static const extraBold = FontWeight(800);
  static const black = FontWeight(900);
}

extension type const FontWidth(int value) implements int {
  static const ultraCondensed = FontWidth(1);
  static const extraCondensed = FontWidth(2);
  static const condensed = FontWidth(3);
  static const semiCondensed = FontWidth(4);
  static const normal = FontWidth(5);
  static const semiExpanded = FontWidth(6);
  static const expanded = FontWidth(7);
  static const extraExpanded = FontWidth(8);
  static const ultraExpanded = FontWidth(9);
}

enum FontSlant { upright, italic, oblique }

final class const FontStyle({
  final FontWeight weight = .regular,
  final FontWidth width = .normal,
  final FontSlant slant = FontSlant.upright,
}) {
  @override
  int get hashCode => Object.hash(weight, width, slant);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FontStyle) return false;
    return weight == other.weight && width == other.width && slant == other.slant;
  }

  @override
  String toString() => 'FontStyle(weight: $weight, width: $width, slant: $slant)';
}

final class FontFaceInfo({
  required final int index,
  required final FontWeight weight,
  required final FontWidth width,
  required final FontSlant slant,
  required final String family,
});
