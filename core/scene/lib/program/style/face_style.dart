part of '../program.dart';

final class const FaceStyle({
  required final ColorData color,
}) extends CellStyle<FaceStyle> {
  static const default_ = FaceStyle(
    color: .transparent,
  );

  FaceStyle copyWith({
    ColorData? color,
  }) => FaceStyle(
    color: color ?? this.color,
  );

  @override
  int get hashCode => color.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FaceStyle && color == other.color);
}

final class const FaceStylePartial({
  final ColorData? color,
}) extends CellStylePartial<FaceStyle> {
  @override
  FaceStyle apply(FaceStyle style) => style.copyWith(
    color: this.color,
  );
}
