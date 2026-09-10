part of '../program.dart';

final class const VertexStyle({
  required final double radius,
  required final ColorData color,
}) extends CellStyle<VertexHandle> {
  static const default_ = VertexStyle(
    radius: 1.0,
    color: .white,
  );

  VertexStyle copyWith({
    double? radius,
    ColorData? color,
  }) => VertexStyle(
    radius: radius ?? this.radius,
    color: color ?? this.color,
  );

  @override
  CellKind get kind => .vertex;

  @override
  int get hashCode => Object.hash(radius, color);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VertexStyle && radius == other.radius && color == other.color);

  @override
  String toString() => 'VertexStyle(radius: $radius, color: $color)';
}

final class const VertexStylePartial({
  final double? radius,
  final ColorData? color,
}) extends CellStylePartial<VertexHandle> {
  factory VertexStylePartial.from(VertexStyle style) => VertexStylePartial(
    radius: style.radius,
    color: style.color,
  );

  factory VertexStylePartial.fromList(Iterable<VertexStyle> styles) {
    var radius = styles.firstOrNull?.radius;
    var color = styles.firstOrNull?.color;

    for (final s in styles) {
      if (s.radius != radius) radius = null;
      if (s.color != color) color = null;
    }

    return .new(
      radius: radius,
      color: color,
    );
  }

  @override
  CellStyle<VertexHandle> apply(VertexStyle style) => style.copyWith(
    radius: radius,
    color: color,
  );

  VertexStylePartial copyWith({
    double? radius,
    ColorData? color,
  }) => VertexStylePartial(
    radius: radius ?? this.radius,
    color: color ?? this.color,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VertexStylePartial && radius == other.radius && color == other.color);

  @override
  int get hashCode => Object.hash(radius, color);
}
