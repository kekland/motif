part of '../_program.dart';

final class const FaceStyle({
  required final Decorations decorations,
}) extends CellStyle<FaceHandle> with Equatable {
  static const default_ = FaceStyle(decorations: .white);
  static const none = FaceStyle(decorations: .none);

  FaceStyle copyWith({
    Decorations? decorations,
  }) => .new(
    decorations: decorations ?? this.decorations,
  );

  @override
  CellKind get kind => .face;

  @override
  List<Object?> get props => [decorations];

  @override
  String toString() => 'FaceStyle($decorations)';
}

final class const FaceStylePartial({
  final Decorations? decorations,
}) extends CellStylePartial<FaceStyle> with Equatable {
  factory from(FaceStyle? style) => .new(decorations: style?.decorations);

  factory fromList(Iterable<FaceStyle> styles) {
    return .new(
      decorations: styles.map((s) => s.decorations).singleOrNull,
    );
  }

  @override
  FaceStyle apply(FaceStyle style) => style.copyWith(
    decorations: decorations,
  );

  FaceStylePartial copyWith({
    Decorations? decorations,
  }) => .new(
    decorations: decorations ?? this.decorations,
  );

  @override
  List<Object?> get props => [decorations];
}
