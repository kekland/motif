part of '../program.dart';

final class DissolveSelector extends Selector<Set<CellRef>> {
  DissolveSelector(this._refs);

  Set<CellRef> _refs;

  @override
  Set<CellRef> get refs => _refs;

  @override
  Set<CellRef> _resolve(EvalContext context) {
    final out = HashSet<CellRef>();
    for (final r in refs) out.addAll(context.descendants(r));
    return out;
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => context.resolve(this);

  @override
  DissolveSelector clone() => .new({..._refs});

  @override
  RemapResult _remap(Remap remap) {
    final (result, refs) = remap.many(_refs);
    _refs = refs.toSet();
    return result;
  }

  @override
  int get hashCode => Object.hash(runtimeType, _setEquality.hash(_refs));

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && _setEquality.equals((other as DissolveSelector)._refs, _refs);
}
