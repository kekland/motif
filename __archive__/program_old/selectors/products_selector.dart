part of '../program.dart';

final class ProductsSelector<H extends CellHandle> extends Selector<List<CellRef<H>>> {
  ProductsSelector(this.id, {this.kind});

  final StatementId id;
  final CellKind? kind;

  @override
  List<CellRef<H>> _resolve(EvalContext context) {
    final out = <CellRef<H>>{};

    for (final p in context.productsOf(id)) {
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

  @override
  ProductsSelector<H> clone() => .new(id, kind: kind);

  @override
  RemapResult _remap(Remap remap) => .unchanged;

  @override
  int get hashCode => Object.hash(runtimeType, id, kind);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && (other as ProductsSelector).id == id && other.kind == kind;
}
