part of '../program.dart';

class EvalContext {
  EvalContext(
    this._evaluation,
    this.id, {
    Map<Selector, Object?>? resolutions,
  }) : _resolutions = resolutions ?? {};

  final Evaluation _evaluation;
  final StatementId id;
  final Map<Selector, Object?> _resolutions;
  final _styles = <CellRef, CellStyle>{};

  Bundle get bundle => _evaluation.bundle;

  StatementId derive(int key, {Object? origin}) => _evaluation.generated.derive(id, key, origin: origin);
  bool derived(StatementId generated) => _evaluation.generatorOf(generated) == id;

  T resolve<T>(Selector<T> s) => _resolutions.putIfAbsent(s, () => s._resolve(this)) as T;
  T? maybeResolve<T>(Selector<T>? s) => s == null ? null : resolve(s);

  H handle<H extends CellHandle>(CellRef<H> ref) {
    return bundle.handle(ref) ?? (throw UnresolvedRef('$ref not found in bundle'));
  }

  Iterable<CellRef> descendants(CellRef ref) => _evaluation.lineage.descendantsOf(ref, bundle);
  Iterable<CellRef> productsOf(StatementId id) => _evaluation.productsOf(id);

  void style(CellRef ref, CellStyle style) => _styles[ref] = style;
  CellStyle styleOf(CellRef ref) => _evaluation.style.of(ref)!;
  Placement placementOf(StatementId id) => _evaluation.layoutOf(id)!;
}
