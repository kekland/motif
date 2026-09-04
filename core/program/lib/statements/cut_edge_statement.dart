part of '../program.dart';

final class CutEdge extends Statement {
  new(
    this.target, {
    required this.t,
    super.id,
    super.modifiers,
  });

  final Selector<EdgeRef> target;
  final double t;

  @override
  Iterable<Selector> get selectors => [target];

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    yield CutEdgeOp(context.resolve(target), [t]);
  }

  @override
  CutEdge copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    Selector<EdgeRef>? target,
    double? t,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    target ?? this.target,
    t: t ?? this.t,
  );

  @override
  TransformResult routeTransform(EvalContext context, CellRef<CellHandle> target) {
    final r = context.resolve(this.target);
    if (target.kind == .edge) return .forward([r]);

    return .absorb((m) {
      final b = context.bundle;
      final p = m.transform2(b.vertexPosition(context.handle(target.asVertex)));
      final cubic = b.edgeCubic(context.handle(r));
      final t = cubic.closestPoint(p).t.clamp(1e-6, 1 - 1e-6);
      return copyWith(t: t);
    }, target);
  }
}
