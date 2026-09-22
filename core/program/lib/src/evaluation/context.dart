part of '../_program.dart';

/// A context given by the evaluation during statement execution.
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

  StatementId derive(U64 key, {Object? origin}) => id.derive(key);

  T resolve<T>(Selector<T> s) => _resolutions.putIfAbsent(s, () => s._resolve(this)) as T;
  T? maybeResolve<T>(Selector<T>? s) => s == null ? null : resolve(s);

  H handle<H extends CellHandle>(CellRef<H> ref) {
    return bundle.handle(ref) ?? (throw UnresolvedRef('$ref not found in bundle'));
  }

  Iterable<CellRef> descendants(CellRef ref) => _evaluation.lineage.descendantsOf(ref);
  Iterable<CellRef> productsOf(StatementId id) => _evaluation.productsOf(id);

  void style(CellRef ref, CellStyle style) => _styles[ref] = style;
  CellStyle styleOf(CellRef ref) => _evaluation.style.of(ref)!;
  Placement placementOf(StatementId id) => _evaluation.layout.of(id)!;
}

class ModifierEvalContext<B extends Statement> extends EvalContext {
  ModifierEvalContext(
    super._evaluation,
    this.fragment,
    super.id, {
    super.resolutions,
  });

  final FragmentSelector fragment;
  B get base => resolve(fragment) as B;
}
