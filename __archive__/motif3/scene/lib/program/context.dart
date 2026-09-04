part of 'program.dart';

final class CellTable {
  final _bindings = <Ref, CellKey>{};
  final _reverseBindings = <CellKey, Ref>{};

  CellKey<H>? keyOf<H extends CellHandle>(Ref<H> ref) => _bindings[ref] as CellKey<H>?;
  Ref<H>? refOf<H extends CellHandle>(CellKey<H> key) => _reverseBindings[key] as Ref<H>?;

  void bind(Ref ref, CellKey key) {
    _bindings[ref] = key;
    _reverseBindings[key] = ref;
  }
}

extension type CellGraph._((TopologyBundle bundle, CellTable cells) _) {
  TopologyBundle get bundle => _.$1;
  CellTable get cells => _.$2;

  Iterable<Ref> dependentsOf(Ref ref) {
    final key = cells.keyOf(ref);
    if (key == null) return const [];
    final handle = bundle.handle(key);
    if (handle == null) return const [];

    final handles = bundle.dependents(handle);
    return handles.map((h) => cells.refOf(bundle.key(h))).nonNulls;
  }

  Iterable<Ref> dependenciesOf(Ref ref) {
    final key = cells.keyOf(ref);
    if (key == null) return const [];
    final handle = bundle.handle(key);
    if (handle == null) return const [];

    final handles = bundle.dependencies(handle);
    return handles.map((h) => cells.refOf(bundle.key(h))).nonNulls;
  }
}

final class UnresolvedRef implements Exception {
  UnresolvedRef(this.ref);
  final Ref ref;

  @override
  String toString() => 'unresolved ref ${ref.statement.value}/${ref.product.name}';
}

final class EvalContext {
  EvalContext({
    required this.transaction,
    required this.cells,
    required this.style,
    this.layout,
    this.styleOverrides,
  });

  final TopologyTransaction transaction;
  final CellTable cells;
  final StyleTable style;
  final LayoutOverrides? layout;
  final StyleOverrides? styleOverrides;

  H resolve<H extends CellHandle>(Arg<Ref<H>> arg) {
    final ref = arg.ref;
    final cellRef = cells.keyOf(ref);
    if (cellRef == null) throw UnresolvedRef(ref);

    final bundle = transaction.bundle;
    final handle = bundle.handle(cellRef);
    if (handle == null) throw UnresolvedRef(ref);

    assert(handle.kind == cellRef.kind);
    return handle as H;
  }

  H? resolveOptional<H extends CellHandle>(Arg<Ref<H>>? arg) {
    if (arg == null) return null;
    return resolve(arg);
  }

  void bind<H extends CellHandle>(Ref<H> ref, H handle, {CellStyle? decoration}) {
    cells.bind(ref, handle.key(transaction.bundle));

    final kind = handle.kind;
    if (kind == .edge || kind == .face) {
      decorate(ref, decoration ?? .defaultOf(handle.kind));
    }
  }

  LayoutResult? layoutOf(StatementId id) => layout?.of(id);

  void decorate(Ref ref, CellStyle<dynamic> style) {
    final override = styleOverrides?.of(ref);
    this.style.bind(ref, style.updateWith(override));
  }
}
