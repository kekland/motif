part of 'core.dart';

sealed class Cell extends SceneNode with SceneNodeImpl {
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

  // void applyTransform(Matrix4 transform);
  void setFrom(covariant Cell other);

  @override
  void applyTransform(Matrix4 transform) {}

  @override
  void _markNeedsLayout() {
    super._markNeedsLayout();
    for (final cell in _star) cell._markNeedsLayout();
  }

  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) => [];
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {RectHitTestMode mode = .normal}) => [];

  @override
  bool hitTest(SceneHitTestResult result, Vector2 localPosition, {Matrix4? globalToScene}) {
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
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {RectHitTestMode mode = .normal}) {
    final entries = _hitTestRectCell(localRect, mode: mode);
    for (final entry in entries) result.add(entry);
    return entries.isNotEmpty;
  }
}
