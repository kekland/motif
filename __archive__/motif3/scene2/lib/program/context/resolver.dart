part of '../program.dart';

final class CellResolver {
  new(this._context);

  final EvalContext _context;

  TopologyBundle get _bundle => _context.bundle;
  BindingTable get _bindings => _context.bindings;

  H one<H extends CellHandle>(Ref<H> ref) {
    final key = _bindings.keyOf(ref) ?? (throw UnresolvedRef(ref));
    final handle = _bundle.handle<H>(key) ?? (throw ConsumedRef(ref));
    return handle;
  }

  H? maybe<H extends CellHandle>(Ref<H>? ref) => ref == null ? null : one(ref);

  H call<H extends CellHandle>(Ref<H> ref) => one(ref);

  List<H> all<H extends CellHandle>(Iterable<Ref<H>> refs) => [for (final ref in refs) one(ref)];
}
