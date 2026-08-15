part of 'core.dart';

/// Cell is a topological unit represented in the scene graph.
sealed class Cell extends SceneNode with SceneNodeBase {
  Cell({
    NodeId? id,
    this._topologyId,
  }) : id = id ?? .generate();

  @override
  final NodeId id;

  // dart format off
  factory Cell.vertex(Vector2 position, {NodeId id}) = Vertex;
  factory Cell.edge(Vertex start, Vertex end, {NodeId id, EdgePath path}) = Edge;
  // dart format on

  int get degree => _star.length;
  late final star = UnmodifiableSetView<Cell>(_star);
  final _star = <Cell>{};

  void _addStar(Cell c) => _star.add(c);
  void _removeStar(Cell c) => _star.remove(c);

  void setFrom(covariant Cell other);

  @override
  TopologicalSceneObject? get owner => super.owner as TopologicalSceneObject?;

  @override
  void _markNeedsLayout([NodeUpdateAspect? aspect]) {
    super._markNeedsLayout(aspect);
    for (final cell in _star) cell._markNeedsLayout(aspect);
  }

  @override
  bool get isLayoutBoundary => true;

  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) => [];
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {HitTestRectMode mode = .normal}) => [];

  @override
  void layout([covariant LayoutConstraints? constraints]) {
    if (constraints != null) this.constraints = constraints;
    performLayout(this.constraints!);
    for (final cell in _star) cell.layout();
  }

  @override
  bool hitTest(
    SceneHitTestResult result,
    Vector2 localPosition, {
    Matrix4? globalToScene,
    List<SceneNode> ignore = const [],
  }) {
    if (ignore.contains(this)) return false;
    final entries = _hitTestCell(localPosition, globalToScene: globalToScene);
    if (entries.isNotEmpty) {
      for (final e in entries) result.add(e);
      return true;
    }

    return false;
  }

  @override
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene}) {
    return _hitTestCell(localPosition, globalToScene: globalToScene).isNotEmpty;
  }

  @override
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    final entries = _hitTestRectCell(localRect, mode: mode);
    for (final entry in entries) result.add(entry);
    return entries.isNotEmpty;
  }

  @override
  void _attachToScene(Scene scene) {
    super._attachToScene(scene);
    if (_topology != null) _detachFromTopology();
    _attachToTopology(scene.topology);
    _topology = scene.topology;
  }

  @override
  void _detachFromScene() {
    _detachFromTopology();
    super._detachFromScene();
  }

  @mustCallSuper
  void _attachToTopology(Topology topology) {
    _topology = topology;
  }

  @mustCallSuper
  void _detachFromTopology() {
    _topology = null;
  }

  Topology? _topology;
  Topology get topology => _topology!;

  final TopologyId? _topologyId;
  TopologyId get topologyId => _topologyId ?? .new(id.id);
}
