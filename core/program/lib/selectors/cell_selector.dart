part of '../program.dart';

final class CellSelector<H extends CellHandle>(
  final CellRef<H> ref,
) extends Selector<CellRef<H>> {
  @override
  CellRef<H> _resolve(EvalContext context) {
    final results = context.descendants(ref).where((r) => r.kind == ref.kind);
    if (results.length != 1) throw UnresolvedRef('no unique descendant of $ref');
    return results.single as CellRef<H>;
  }

  @override
  Iterable<CellRef> resolved(EvalContext context) => [context.resolve(this)];

  @override
  Iterable<CellRef> get refs => [ref];
}
