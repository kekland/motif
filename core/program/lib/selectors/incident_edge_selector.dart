part of '../program.dart';

final class IncidentEdgeSelector(
  final EdgeRef edge,
  final VertexSelector at,
) extends EdgeSelector {
  @override
  EdgeRef _resolve(EvalContext context) {
    final v = context.handle(context.resolve(at));
    final edges = context.descendants(edge).where((r) => r.kind == .edge).cast<EdgeRef>();

    EdgeRef? result;
    for (final e in edges) {
      final handle = context.handle(e);
      if (context.bundle.edgeVertices(handle).contains(v)) {
        if (result != null) throw UnresolvedRef('no unique incident edge of $edge at $at');
        result = e;
      }
    }

    return result ?? (throw UnresolvedRef('no incident edge of $edge at $at'));
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => [context.resolve(this)];

  @override
  Iterable<CellRef> get refs => [edge, ...at.refs];
}
