part of '../_program.dart';

final class ChainSelector extends Selector<List<EdgeRef>> {
  ChainSelector(this._edges) : super(_edges);

  List<EdgeRef> _edges;
  List<EdgeRef> get edges => _edges;

  @override
  List<EdgeRef> _resolve(EvalContext context) {
    final result = <EdgeRef>[];
    for (final e in edges) {
      final results = context.descendants(e).where((r) => r.kind == .edge).cast<EdgeRef>();
      if (results.isEmpty) throw StateError('ChainSelector: no edges found for $e');
      result.addAll(results);
    }
    return result;
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => context.resolve(this);

  @override
  Iterable<CellRef> get refs => edges;

  @override
  ChainSelector clone() => .new([...edges]);

  @override
  RemapResult _remap(Remap remap) {
    final (result, edges) = remap.many(_edges, kind: .edge);
    _edges = edges;
    return result;
  }

  @override
  int get hashCode => Object.hash(runtimeType, listHash(edges));

  @override
  bool operator ==(Object other) {
    if (other is! ChainSelector) return false;
    if (other.runtimeType != runtimeType) return false;
    if (!listEquals(other.edges, edges)) return false;
    return true;
  }
}
