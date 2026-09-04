part of '../program.dart';

final class ChainSelector(
  final List<EdgeRef> edges,
) extends Selector<List<EdgeRef>> {
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
}
