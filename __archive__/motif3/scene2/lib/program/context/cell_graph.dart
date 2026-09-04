part of '../program.dart';

extension type CellGraph._((TopologyBundle bundle, BindingTable bindings) _) {
  TopologyBundle get bundle => _.$1;
  BindingTable get bindings => _.$2;

  Iterable<Ref> dependentsOf(Ref ref) {
    final key = bindings.keyOf(ref);
    if (key == null) return const [];
    final handle = bundle.handle(key);
    if (handle == null) return const [];

    final handles = bundle.dependents(handle);
    return handles.map((h) => bindings.refOf(bundle.key(h))).nonNulls;
  }

  Iterable<Ref> dependenciesOf(Ref ref) {
    final key = bindings.keyOf(ref);
    if (key == null) return const [];
    final handle = bundle.handle(key);
    if (handle == null) return const [];

    final handles = bundle.dependencies(handle);
    return handles.map((h) => bindings.refOf(bundle.key(h))).nonNulls;
  }
}
