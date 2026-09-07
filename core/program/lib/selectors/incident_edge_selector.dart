part of '../program.dart';

final class IncidentEdgeSelector extends EdgeSelector {
  IncidentEdgeSelector(this._edge, this.at);

  EdgeRef _edge;
  EdgeRef get edge => _edge;

  final VertexSelector at;

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

  @override
  IncidentEdgeSelector clone() => .new(edge, at.clone());

  @override
  RemapResult _remap(Remap remap) {
    final inner = at._remap(remap);
    if (inner == .refused) return .refused;
    final (result, ref) = remap.one(_edge);
    _edge = ref;
    return result == .unchanged ? inner : result;
  }

  @override
  int get hashCode => Object.hash(runtimeType, _edge.hashCode, at.hashCode);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && (other as IncidentEdgeSelector)._edge == _edge && other.at == at;
}
