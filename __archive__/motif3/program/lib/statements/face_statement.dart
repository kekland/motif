part of '../program.dart';

final class FaceStatement extends Statement with PlacedStatement {
  new(
    BoundarySelector outer, {
    List<BoundarySelector> holes = const [],
    this.style = .default_,
    super.id,
    super.modifiers,
    FrameKey? parent,
  }) : outer = outer.copyWith(),
       holes = holes.map((h) => h.copyWith()).toList(),
       parent = parent?.selector();

  final BoundarySelector outer;
  final List<BoundarySelector> holes;
  final FaceStyle style;

  @override
  final CellSelector<FrameHandle>? parent;

  @override
  Iterable<Selector> get selectors => [outer, ...holes, ?parent];

  late final FaceKey key = .face(cellId('face'));

  @override
  void performExecute(EvalContext context) {
    final outer = this.outer.resolve(context);
    final holes = this.holes.map((h) => h.resolve(context)).toList();

    final handle = context.transaction.makeFace(
      key.id,
      outer,
      holes: holes,
      parent: parent?.resolve(context),
    );
  }

  @override
  FaceStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    BoundarySelector? outer,
    List<BoundarySelector>? holes,
    FaceStyle? style,
    FrameKey? parent,
  }) => .new(
    outer ?? this.outer,
    holes: holes ?? this.holes,
    style: style ?? this.style,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.key,
  );
}
