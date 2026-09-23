part of '../_program.dart';

final class const EdgeStyle({
  required final double width,
  required final ColorData color,
}) extends CellStyle<EdgeHandle> {
  static const default_ = EdgeStyle(
    width: 1.0,
    color: .white,
  );

  EdgeStyle copyWith({
    double? width,
    ColorData? color,
  }) => EdgeStyle(
    width: width ?? this.width,
    color: color ?? this.color,
  );

  @override
  CellKind get kind => .edge;

  @override
  int get hashCode => Object.hash(width, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EdgeStyle && width == other.width && color == other.color);

  @override
  String toString() => 'EdgeStyle(width: $width, color: $color)';
}

final class const EdgeStylePartial({
  final double? width,
  final ColorData? color,
}) extends CellStylePartial<EdgeHandle> {
  factory EdgeStylePartial.from(EdgeStyle? style) => EdgeStylePartial(
    width: style?.width,
    color: style?.color,
  );

  factory EdgeStylePartial.fromList(Iterable<EdgeStyle> styles) {
    return .new(
      width: styles.map((s) => s.width).toSet().singleOrNull,
      color: styles.map((s) => s.color).toSet().singleOrNull,
    );
  }

  @override
  EdgeStyle apply(EdgeStyle style) => style.copyWith(
    width: width,
    color: color,
  );

  EdgeStylePartial copyWith({
    double? width,
    ColorData? color,
  }) => .new(
    width: width ?? this.width,
    color: color ?? this.color,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EdgeStylePartial && width == other.width && color == other.color);

  @override
  int get hashCode => Object.hash(width, color);
}
