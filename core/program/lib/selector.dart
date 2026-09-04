part of 'program.dart';

sealed class Selector<T> {
  T _resolve(EvalContext context);
  Iterable<CellRef> resolved(EvalContext context);

  Iterable<CellRef> get refs;
  Iterable<StatementId> get dependencies => [for (final r in refs) ._(r.namespace)];
}

typedef FrameSelector = Selector<FrameRef>;
typedef VertexSelector = Selector<VertexRef>;
typedef EdgeSelector = Selector<EdgeRef>;
typedef FaceSelector = Selector<FaceRef>;

extension CellExtension<H extends CellHandle> on CellRef<H> {
  CellSelector<H> selector() => CellSelector(this);
}
