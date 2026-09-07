part of '../program.dart';

final class EvalContext {
  EvalContext(
    this._evaluation,
    this.id, {
    Map<Selector, Object?>? resolutions,
  }) : _resolutions = resolutions ?? {};

  final Evaluation _evaluation;
  final StatementId id;
  final Map<Selector, Object?> _resolutions;

  Bundle get bundle => _evaluation.bundle;

  T resolve<T>(Selector<T> s) => _resolutions.putIfAbsent(s, () => s._resolve(this)) as T;
  T? maybeResolve<T>(Selector<T>? s) => s == null ? null : resolve(s);

  H handle<H extends CellHandle>(CellRef<H> ref) {
    return bundle.handle(ref) ?? (throw UnresolvedRef('$ref not found in bundle'));
  }

  Iterable<CellRef> descendants(CellRef ref) => _evaluation.lineage.descendantsOf(ref, bundle);
  // CellRef ancestor(CellRef ref) => _evaluation.lineage.ances(ref);
  Iterable<CellRef> productsOf(StatementId id) => _evaluation.productsOf(id);

  final _styles = <CellRef, CellStyle>{};
  void style(CellRef ref, CellStyle style) => _styles[ref] = style;
  CellStyle styleOf(CellRef ref) => _evaluation.styleOf(ref);

  Placement placementOf(StatementId id) => _evaluation.layoutOf(id)!;
}
