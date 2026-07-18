part of '../core.dart';

final class Edge extends Cell {
  Edge(
    Vertex start,
    Vertex end, {
    NodeId? id,
    EdgePath? path,
  }) : this.fromIds(start.id, end.id, id: id, path: path);

  Edge.fromIds(
    this._startId,
    this._endId, {
    super.id,
    EdgePath? path,
  }) {
    if (path != null) {
      this.path = path;
    } else {
      this.path = .new([CubicKnot2(.zero()), CubicKnot2(.zero())]);
    }

    this.path._setEdge(this);
  }

  NodeId _startId;
  NodeId get startId => _startId;
  Vertex get start => _scene!._getNode(_startId);
  set start(Vertex vertex) => startId = vertex.id;
  set startId(NodeId value) {
    if (_startId == value) return;
    _scene?._removeStar(_startId, this);
    _startId = value;
    _scene?._addStar(_startId, this);
    _markNeedsLayout();
  }

  NodeId _endId;
  NodeId get endId => _endId;
  Vertex get end => _scene!._getNode(_endId);
  set end(Vertex vertex) => endId = vertex.id;
  set endId(NodeId value) {
    if (_endId == value) return;
    _scene?._removeStar(_endId, this);
    _endId = value;
    _scene?._addStar(_endId, this);
    _markNeedsLayout();
  }

  late final EdgePath path;

  @override
  void _attachToScene(Scene scene) {
    super._attachToScene(scene);
    scene._addStar(_startId, this);
    scene._addStar(_endId, this);
  }

  @override
  void _detachFromScene() {
    _scene?._removeStar(_startId, this);
    _scene?._removeStar(_endId, this);
    super._detachFromScene();
  }

  @override
  void transformWith(Matrix4 transform) {
    path.transformWith(transform);
  }

  @override
  void setFrom(Edge other) {
    path.setFrom(other.path);
  }

  @override
  void layout(LayoutConstraints constraints) {
    path.first.p = start.position;
    path.last.p = end.position;
    path.layout();

    _resolvedSize = .new(path.bboxTight.width, path.bboxTight.height);
  }

  @override
  Aabb2 get boundingBox => bboxTight;

  Aabb2 get bbox => path.bbox;
  Aabb2 get bboxTight => path.bboxTight;

  @override
  ReadonlySignal<Edge> call() => _scene!._signalFor(this);

  @override
  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) {
    return _hitTestEdge(this, localPosition, globalToScene: globalToScene);
  }

  @override
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    return _hitTestRectEdge(this, localRect, mode: mode);
  }

  EdgeCutResult cut(double t) => _scene!.topology.cutEdge(this, t);
  MultiEdgeCutResult cutMultiple(List<double> ts) => _scene!.topology.multiCutEdge(this, ts);

  @override
  EdgeSnapshot snapshot() => .new(id: id, startId: _startId, endId: _endId, path: path.snapshot());

  @override
  void applySnapshot(covariant EdgeSnapshot snapshot) {
    startId = snapshot.startId;
    endId = snapshot.endId;
    path.applySnapshot(snapshot.path);
  }
}

class EdgeSnapshot extends NodeSnapshot {
  const EdgeSnapshot({required super.id, required this.startId, required this.endId, required this.path});

  final NodeId startId;
  final NodeId endId;
  final EdgePathSnapshot path;
}
