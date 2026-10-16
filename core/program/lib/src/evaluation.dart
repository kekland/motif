part of '_program.dart';

class Evaluation {
  Evaluation(
    this.program, {
    this.assetCache,
    ObjectTree Function(Evaluation)? createObjectTree,
  }) {
    bundle = .new(order: cellEvalOrder);
    graph = .new(this);
    lineage = .new(this);
    style = .new(this);
    tree = .new(this);
    object = createObjectTree?.call(this) ?? .new(this);
    layout = .new(this);
    prefabs = .new(this);
    transientTransform = .new();
    live = .new(this);
  }

  final Program program;
  final AssetCache? assetCache;
  late final LiveIndex live;
  late final Bundle bundle;
  late final DependencyGraph graph;
  late final LineageIndex lineage;
  late final StyleIndex style;
  late final TransientTransforms transientTransform;
  late final LayoutTree layout;
  late final PrefabIndex prefabs;
  late final ObjectTree object;

  AssetManifest get assetManifest => program.assetManifest;

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

  /// Resolves the evaluation order between two cells.
  int cellEvalOrder(CellRef a, CellRef b) => evalOrder(a.statementId, b.statementId);

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

  void _onPassComplete(EvalPass pass) {}

  void _onDelta(Delta delta) {}

  void _install(Commit commit) {}

  void _uninstall(Commit commit) {}

  void performInitialPass() {
    final pass = beginPass();
    pass.edit(0, [], program._statements, initialPass: true);
    pass.drain();
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Asset resolution
  // -------------------------------------------------------------------------------------------------------------------

  void loadAsset(StatementId? id, Asset asset) => assetCache?.fetch(id, asset);

  /// Creates a child evaluation for the given program slice.
  Evaluation subEvaluation(ProgramSlice slice) {
    final evaluation = Evaluation(.new(slice.statements), assetCache: assetCache);
    return evaluation;
  }
}

/// A live evaluation of a [Program].
///
/// Holds the live [Bundle], indexes for statements, and other runtime information.
final class SceneEvaluation extends Evaluation {
  SceneEvaluation(super.program, {super.assetCache}) : super(createObjectTree: SceneObjectTree.new) {
    assetCache?.addFetchListener(_onAssetLoaded);
  }

  @override
  SceneObjectTree get object => super.object as SceneObjectTree;

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

  @override
  void _install(Commit commit) {
    object.attach(commit);
  }

  @override
  void _uninstall(Commit commit) {
    object.detach(commit);
  }

  @override
  void _onDelta(Delta delta) {
    object.onMovedFrames(delta.movedFrames);
  }

  @override
  void _onPassComplete(EvalPass pass) {
    _lastPass = pass;
    _updateNotifier.value = pass;
  }

  void dispose() {
    assetCache?.removeFetchListener(_onAssetLoaded);
    object.dispose();
    _updateNotifier.dispose();
  }

  void _onAssetLoaded(StatementId id) {
    final pass = beginPass();
    pass.queue.add(rootOf(id));

    final origin = prefabs.originOf(id)?.id;
    if (origin != null) pass._markPrefabsDirty([origin]);
    pass.drain();
  }
}
