part of '../program.dart';

final class ProductsSelector<H extends CellHandle>(final StatementId id, {final CellKind? kind})
    extends Selector<List<CellRef<H>>> {
  @override
  List<CellRef<H>> _resolve(EvalContext context) {
    final out = <CellRef<H>>{};

    for (final p in context.products(id)) {
      if (kind != null && p.kind != kind) continue;
      for (final k in context.descendants(p)) {
        if (kind != null && k.kind != kind) continue;
        out.add(k as CellRef<H>);
      }
    }

    return out.toList();
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => context.resolve(this);

  @override
  Iterable<CellRef> get refs => const [];

  @override
  Iterable<StatementId> get dependencies => [id];
}

final class SingleSelector<H extends CellHandle>(final Selector<List<CellRef<H>>> selector)
    extends Selector<CellRef<H>> {
  @override
  CellRef<H> _resolve(EvalContext context) {
    final list = selector._resolve(context);
    if (list.length != 1) throw StateError('SingleSelector got ${list.length} results');
    return list.single;
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => [context.resolve(this)];

  @override
  Iterable<CellRef> get refs => selector.refs;

  @override
  Iterable<StatementId> get dependencies => selector.dependencies;
}

extension SingularSelector<H extends CellHandle> on Selector<List<CellRef<H>>> {
  Selector<CellRef<H>> get single => SingleSelector(this);
}
