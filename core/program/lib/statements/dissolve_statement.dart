part of '../program.dart';

final class DissolveStatement extends Statement {
  new(
    DissolveSelector selector, {
    this.keep = const [],
    super.id,
    super.modifiers,
  }) : selector = selector.clone();

  final DissolveSelector selector;
  final List<(CellSelector, FrameSelector?)> keep;

  @override
  Iterable<Selector> get selectors => [
    selector,
    for (final (c, f) in keep) ...[c, ?f],
  ];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    for (final (cell, frame) in keep) {
      yield ReparentOp(
        cell: context.resolve(cell),
        parent: context.maybeResolve(frame),
      );
    }

    final targets = context.resolve(selector);
    final targetByKind = <CellKind, HashSet<CellRef>>{.frame: .new(), .vertex: .new(), .edge: .new(), .face: .new()};
    for (final target in targets) targetByKind[target.kind]!.add(target);

    for (final f in targetByKind[CellKind.frame]!) yield DeleteFrameOp(f.asFrame);
    for (final v in targetByKind[CellKind.vertex]!) yield DeleteVertexOp(v.asVertex);
    for (final e in targetByKind[CellKind.edge]!) yield DeleteEdgeOp(e.asEdge);
    for (final f in targetByKind[CellKind.face]!) yield DeleteFaceOp(f.asFace);
  }

  @override
  DissolveStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    DissolveSelector? selector,
    List<(CellSelector, FrameSelector?)>? keep,
  }) => .new(
    selector ?? this.selector,
    keep: keep ?? this.keep,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );
}
