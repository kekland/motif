part of '../_program.dart';

final class const VertexStyle({
  required final double radius,
  required final Decorations decorations,
}) extends CellStyle<VertexHandle> with Equatable {
  static const default_ = VertexStyle(
    radius: 1.0,
    decorations: .none,
  );

  VertexStyle copyWith({
    double? radius,
    Decorations? decorations,
  }) => .new(
    radius: radius ?? this.radius,
    decorations: decorations ?? this.decorations,
  );

  @override
  CellKind get kind => .vertex;
  
  @override
  List<Object?> get props => [radius, decorations];
}

final class const VertexStylePartial({
  final double? radius,
  final Decorations? decorations,
}) extends CellStylePartial<VertexStyle> with Equatable {
  factory VertexStylePartial.from(VertexStyle style) => VertexStylePartial(
    radius: style.radius,
    decorations: style.decorations,
  );

  factory VertexStylePartial.fromList(Iterable<VertexStyle> styles) {
    return .new(
      radius: styles.map((s) => s.radius).toSet().singleOrNull,
      decorations: styles.map((s) => s.decorations).toSet().singleOrNull,
    );
  }

  @override
  VertexStyle apply(VertexStyle style) => style.copyWith(
    radius: radius,
    decorations: decorations,
  );

  VertexStylePartial copyWith({
    double? radius,
    Decorations? decorations,
  }) => VertexStylePartial(
    radius: radius ?? this.radius,
    decorations: decorations ?? this.decorations,
  );

  @override
  List<Object?> get props => [radius, decorations];
}
