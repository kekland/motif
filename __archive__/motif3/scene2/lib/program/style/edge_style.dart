part of '../program.dart';

final class const EdgeStyle({
  required final double width,
  required final ColorData color,
}) extends CellStyle<EdgeStyle> {
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
}

final class const EdgeStylePartial({
  final double? width,
  final ColorData? color,
}) extends CellStylePartial<EdgeStyle> {
  factory EdgeStylePartial.from(EdgeStyle style) => EdgeStylePartial(
    width: style.width,
    color: style.color,
  );

  factory EdgeStylePartial.fromList(Iterable<EdgeStyle> styles) {
    var width = styles.firstOrNull?.width;
    var color = styles.firstOrNull?.color;

    for (final s in styles) {
      if (s.width != width) width = null;
      if (s.color != color) color = null;
    }

    return .new(
      width: width,
      color: color,
    );
  }

  @override
  EdgeStyle apply(EdgeStyle style) => style.copyWith(
    width: width,
    color: color,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is EdgeStylePartial && width == other.width && color == other.color);

  @override
  int get hashCode => Object.hash(width, color);
}
