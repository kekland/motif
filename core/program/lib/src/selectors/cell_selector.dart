part of '../_program.dart';

final class CellSelector<H extends CellHandle> extends Selector<CellRef<H>> {
  CellSelector(this._ref) : super([_ref]);

  CellRef<H> _ref;
  CellRef<H> get ref => _ref;

  @override
  CellRef<H> _resolve(EvalContext context) {
    final results = context.descendants(ref).where((r) => r.kind == ref.kind);
    if (results.length != 1) throw UnresolvedRef('no unique descendant of $ref');
    return results.single as CellRef<H>;
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => [context.resolve(this)];

  @override
  CellSelector<H> clone() => .new(ref);

  @override
  RemapResult _remap(Remap remap) {
    final (result, ref) = remap.one(_ref);
    _ref = ref;
    return result;
  }

  @override
  int get hashCode => Object.hash(runtimeType, _ref.hashCode);

  @override
  bool operator ==(Object other) {
    if (other is! CellSelector<H>) return false;
    if (other.runtimeType != runtimeType) return false;
    if (other.ref != ref) return false;
    return true;
  }
}
