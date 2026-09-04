part of '../program.dart';

final class FrameStatement extends Statement with PlacedStatement {
  FrameStatement({
    Mat4? transform,
    super.id,
    super.modifiers,
    FrameKey? parent,
  }) : transform = transform ?? .identity(),
       parent = parent?.selector();

  final Mat4 transform;

  @override
  final CellSelector<FrameHandle>? parent;

  @override
  Iterable<Selector> get selectors => [?parent];

  late final FrameKey key = .frame(cellId('frame'));

  @override
  void performExecute(EvalContext context) {
    final handle = context.transaction.addFrame(
      key.id,
      transform: transform,
      parent: parent?.resolve(context),
    );
  }

  @override
  FrameStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Mat4? transform,
    FrameKey? parent,
  }) => .new(
    transform: transform ?? this.transform,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    parent: parent ?? this.parent?.key,
  );
}
