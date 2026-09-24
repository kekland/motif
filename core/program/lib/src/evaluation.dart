part of '_program.dart';

/// A live evaluation of a [Program].
///
/// Holds the live [Bundle], indexes for statements, and other runtime information.
final class Evaluation {
  Evaluation(this.program) {
    bundle = .new();
    graph = .new(this);
    lineage = .new(this);
    live = .new(this);
    style = .new(this);
    drawOrder = .new(this);
    tree = .new(this);
    layout = .new(this);
    transientTransform = .new();
    _initialPass();
  }

  final Program program;
  late final Bundle bundle;
  late final DependencyGraph graph;
  late final LineageIndex lineage;
  late final LiveIndex live;
  late final StyleIndex style;
  late final DrawOrderIndex drawOrder;
  late final LayoutTree layout;
  late final TransientTransforms transientTransform;

  // -------------------------------------------------------------------------------------------------------------------
  // State
  // -------------------------------------------------------------------------------------------------------------------

  late final EvalTree tree;

  /// Returns the evaluation node of the statement.
  EvalNode? nodeOf(StatementId id) => tree[id];

  /// Returns whether the evaluation node exists for a statement.
  bool hasNode(StatementId id) => tree[id] != null;

  /// Returns the commit associated with the statement.
  Commit? commitOf(StatementId id) => tree[id]?.commit;

  /// Returns the root statement id of the statement.
  StatementId rootOf(StatementId id) => tree[id]!.root.id;

  /// Returns the statement associated with the statement.
  S? statement<S extends Statement>(StatementId id) => tree[id]?.statement as S?;

  /// Returns the root statement associated with the statement.
  S? rootStatement<S extends Statement>(StatementId id) => statement(rootOf(id));

  /// Returns the index of the statement in the program (i.e. the index of the root statement).
  int? indexOf(StatementId id) => program.indexOf(rootOf(id));

  /// Resolves the evaluation order between two statements.
  int evalOrder(StatementId a, StatementId b) => tree.order(tree[a]!, tree[b]!);

  /// Returns the products (added cells) of the statement and its subtree.
  Iterable<CellRef> productsOf(StatementId id) => switch (tree[id]) {
    final node? => [for (final n in tree.subtree(node)) ...?n.commit?.added],
    null => const [],
  };

  /// Returns the consumed cells (deleted cells) of the statement and its subtree.
  Iterable<CellRef> consumedOf(StatementId id) => switch (tree[id]) {
    final node? => [for (final n in tree.subtree(node)) ...?n.commit?.deleted],
    null => const [],
  };

  /// Returns the set of statements that [id] and its subtree depends on.
  Set<StatementId> dependenciesOf(StatementId id) =>
      graph.dependencies(tree.subtreeIds(id)).map((i) => rootOf(i)).toSet()..remove(id);

  /// Returns the set of statements that depend on [id] and its subtree.
  Set<StatementId> dependentsOf(StatementId id) =>
      graph.dependents(tree.subtreeIds(id)).map((i) => rootOf(i)).toSet()..remove(id);

  /// Returns the set of dependents of the given root statements that appear before the specified index.
  List<StatementId> dependentsBefore(Iterable<StatementId> roots, int index, {Set<StatementId> except = const {}}) {
    bool isBefore(StatementId o) => !except.contains(o) && indexOf(o)! < index;

    final out = SplayTreeSet<StatementId>(evalOrder);
    final work = [...roots.where(isBefore)];
    while (work.isNotEmpty) {
      final o = work.removeLast();
      if (out.add(o)) work.addAll(dependentsOf(o).where(isBefore));
    }

    return out.toList();
  }

  /// Returns the set of statements that depend on [cells].
  Set<StatementId> readersOf(Iterable<CellRef> cells) => graph.topologyReaders(cells).map((i) => rootOf(i)).toSet();

  // -------------------------------------------------------------------------------------------------------------------
  // Context
  // -------------------------------------------------------------------------------------------------------------------

  EvalContext contextFor(StatementId id, {bool includeResolutions = true}) => .new(
    this,
    id,
    resolutions: includeResolutions ? commitOf(id)?.resolutions : null,
  );

  EvalPass beginPass() => .new(this);

  // -------------------------------------------------------------------------------------------------------------------
  // Update propagation
  // -------------------------------------------------------------------------------------------------------------------

  late var _lastPass = EvalPass(this);
  late final _updateNotifier = AlwaysNotifier<EvalPass>(_lastPass);

  void addUpdateListener(void Function(EvalPass) listener) {
    _updateNotifier.addListener(() => listener(_updateNotifier.value));
  }

  void removeUpdateListener(void Function(EvalPass) listener) {
    _updateNotifier.removeListener(() => listener(_updateNotifier.value));
  }

  void _onPassComplete(EvalPass pass) {
    _lastPass = pass;
    _updateNotifier.value = pass;
  }

  void dispose() {
    _updateNotifier.dispose();
  }

  void _initialPass() {
    final pass = beginPass();
    pass.edit(0, [], program._statements, initialPass: true);
    pass.drain();
  }
}

class AlwaysNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  AlwaysNotifier(this._value);

  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
