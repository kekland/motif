part of 'program.dart';

final class ExportTable {
  final _bindings = <Ref, CellKey>{};
  final _reverseBindings = <CellKey, Ref>{};

  CellKey<H>? keyOf<H extends CellHandle>(Ref<H> ref) => _bindings[ref] as CellKey<H>?;
  Ref<H>? refOf<H extends CellHandle>(CellKey<H> key) => _reverseBindings[key] as Ref<H>?;

  void bind(Ref ref, CellKey key) {
    _bindings[ref] = key;
    _reverseBindings[key] = ref;
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
    required this.exports,
    required this.style,
    this.layout,
    this.styleOverrides,
  });

  final TopologyTransaction transaction;
  final ExportTable exports;
  final StyleTable style;
  final LayoutOverrides? layout;
  final StyleOverrides? styleOverrides;

  H resolve<H extends CellHandle>(Arg<Ref<H>> arg) {
    final ref = arg.ref;
    final cellRef = exports.keyOf(ref);
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
    exports.bind(ref, handle.asKey(transaction.bundle));

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
