part of 'core.dart';

/// Cell is a topological unit represented in the scene graph.
sealed class Cell extends SceneNode with SceneNodeBase {
  Cell({NodeId? id}) : id = id ?? .generate();

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
  void _markNeedsLayout([NodeUpdateAspect? aspect]) {
    super._markNeedsLayout(aspect);
    for (final cell in _star) cell._markNeedsLayout(aspect);
  }

  @override
  bool get isLayoutBoundary => true;

  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) => [];
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {HitTestRectMode mode = .normal}) => [];

  @override
  void layout(LayoutConstraints constraints) {
    super.layout(constraints);
    for (final cell in _star) cell.performLayout(constraints);
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
}
