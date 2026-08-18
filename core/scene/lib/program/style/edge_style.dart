part of '../program.dart';

final class const EdgeStyle({
  required final double width,
  required final ColorData color,
}) extends CellStyle<EdgeStyle> {
  static const default_ = EdgeStyle(
    width: 1.0,
    color: .transparent,
  );

  EdgeStyle copyWith({
    double? width,
    ColorData? color,
  }) => EdgeStyle(
    width: width ?? this.width,
    color: color ?? this.color,
  );

  @override
  int get hashCode => Object.hash(width, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EdgeStyle && width == other.width && color == other.color);
}

final class const EdgeStylePartial({
  final double? width,
  final ColorData? color,
}) extends CellStylePartial<EdgeStyle> {
  @override
  EdgeStyle apply(EdgeStyle style) => style.copyWith(
    width: width,
    color: color,
  );
}
