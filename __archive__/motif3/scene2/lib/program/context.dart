part of 'program.dart';

/// Evaluation context for a program.
///
/// During evaluation, the context is used to resolve references to other statements and their products.
///
/// Evaluation context can also be extended with auxiliary data, like layout/style information.
final class EvalContext {
  new({
    required this.graph,
    required this.transaction,
    required this.bindings,
    required this.style,
    this.styleOverrides,
  });

  final ProgramGraph graph;
  final TopologyTransaction transaction;
  final BindingTable bindings;
  final StyleTable style;

  final StyleOverrides? styleOverrides;

  late final CellResolver resolve = CellResolver(this);

  TopologyBundle get bundle => transaction.bundle;

  final failures = <EvalFailure>[];
  final _stack = <Statement>[];

  TransactionMark? _currentMark;
  Statement get current => _stack.last;
  void push(Statement statement) => _stack.add(statement);
  void pop() => _stack.removeLast();

  void bind<H extends CellHandle>(Ref<H> ref, H handle, {CellStyle? style}) {
    assert(ref.kind == handle.kind, '$ref (${ref.kind}) kind does not match handle');
    bindings.bind(ref, bundle.key(handle), current);

    final kind = handle.kind;
    if (kind == .vertex || kind == .edge || kind == .face) {
      decorate(ref, style ?? .defaultOf(kind));
    }
  }

  void autobind(Statement statement) {
    final delta = transaction.delta;
    final added = delta._added.skip(_currentMark!.added);
    for (final key in added) {
      if (bindings.refOf(key) != null) continue; // binding added manually

      final handle = bundle.handle(key);
      if (handle == null) continue; // handle consumed internally

      final source = delta.sourceOf(key);
      var baseStyle = source != null ? style.of(bindings.refOf(source.source)!) : null;
      if (baseStyle?.kind != key.kind) baseStyle = null;

      final ref = Ref.of(statement, key.id.value, key.kind);
      bind(ref, handle, style: baseStyle);
    }
  }

  void decorate(Ref ref, CellStyle<dynamic> base) {
    final override = styleOverrides?.of(ref);
    style.bind(ref, base.updateWith(override));
  }
}
