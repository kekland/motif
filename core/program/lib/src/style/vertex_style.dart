part of '../_program.dart';

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
    return .new(
      radius: styles.map((s) => s.radius).toSet().singleOrNull,
      color: styles.map((s) => s.color).toSet().singleOrNull,
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
