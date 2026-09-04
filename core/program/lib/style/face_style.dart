part of '../program.dart';

final class const FaceStyle({
  required final ColorData color,
}) extends CellStyle<FaceStyle> {
  static const default_ = FaceStyle(
    color: .white,
  );

  FaceStyle copyWith({
    ColorData? color,
  }) => FaceStyle(
    color: color ?? this.color,
  );

  @override
  CellKind get kind => .face;

  @override
  int get hashCode => color.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FaceStyle && color == other.color);
}

final class const FaceStylePartial({
  final ColorData? color,
}) extends CellStylePartial<FaceStyle> {
  factory FaceStylePartial.from(FaceStyle style) => .new(
    color: style.color,
  );

  factory FaceStylePartial.fromList(Iterable<FaceStyle> styles) {
    var color = styles.firstOrNull?.color;

    for (final s in styles) {
      if (s.color != color) color = null;
    }

    return .new(
      color: color,
    );
  }

  @override
  FaceStyle apply(FaceStyle style) => style.copyWith(
    color: color,
  );

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FaceStylePartial && color == other.color);

  @override
  int get hashCode => color.hashCode;
}
