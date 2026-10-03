part of '../_program.dart';

final class const EdgeStyle({
  required final double width,
  required final Decorations decorations,
}) extends CellStyle<EdgeHandle> with Equatable {
  static const none = EdgeStyle(width: 0.0, decorations: .none);
  static const default_ = EdgeStyle(width: 1.0, decorations: .white);

  EdgeStyle copyWith({
    double? width,
    Decorations? decorations,
  }) => EdgeStyle(
    width: width ?? this.width,
    decorations: decorations ?? this.decorations,
  );

  @override
  CellKind get kind => .edge;

  @override
  List<Object?> get props => [width, decorations];
}

final class const EdgeStylePartial({
  final double? width,
  final Decorations? decorations,
}) extends CellStylePartial<EdgeStyle> with Equatable {
  factory EdgeStylePartial.from(EdgeStyle? style) => .new(
    width: style?.width,
    decorations: style?.decorations,
  );

  factory EdgeStylePartial.fromList(Iterable<EdgeStyle> styles) {
    return .new(
      width: styles.map((s) => s.width).toSet().singleOrNull,
      decorations: styles.map((s) => s.decorations).toSet().singleOrNull,
    );
  }

  @override
  EdgeStyle apply(EdgeStyle style) => style.copyWith(
    width: width,
    decorations: decorations,
  );

  EdgeStylePartial copyWith({
    double? width,
    Decorations? decorations,
  }) => .new(
    width: width ?? this.width,
    decorations: decorations ?? this.decorations,
  );

  @override
  List<Object?> get props => [width, decorations];
}
