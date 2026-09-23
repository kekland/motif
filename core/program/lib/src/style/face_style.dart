part of '../_program.dart';

final class const FaceStyle({
  required final ColorData color,
}) extends CellStyle<FaceHandle> {
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

  @override
  String toString() => 'FaceStyle(color: $color)';
}

final class const FaceStylePartial({
  final ColorData? color,
}) extends CellStylePartial<FaceHandle> {
  factory FaceStylePartial.from(FaceStyle? style) => .new(
    color: style?.color,
  );

  factory FaceStylePartial.fromList(Iterable<FaceStyle> styles) {
    return .new(
      color: styles.map((s) => s.color).toSet().singleOrNull,
    );
  }

  @override
  FaceStyle apply(FaceStyle style) => style.copyWith(
    color: color,
  );

  FaceStylePartial copyWith({
    ColorData? color,
  }) => .new(
    color: color ?? this.color,
  );

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FaceStylePartial && color == other.color);

  @override
  int get hashCode => color.hashCode;
}
