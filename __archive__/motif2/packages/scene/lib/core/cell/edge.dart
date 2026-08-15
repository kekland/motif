part of '../core.dart';

final class Edge extends Cell {
  Edge(
    Vertex start,
    Vertex end, {
    NodeId? id,
    TopologyId? topologyId,
    EdgePath? path,
  }) : this.fromIds(start.id, end.id, id: id, topologyId: topologyId, path: path);

  Edge.fromIds(
    this._startId,
    this._endId, {
    super.id,
    super.topologyId,
    EdgePath? path,
  }) {
    if (path != null) {
      this.path = path;
    } else {
      this.path = .new([CubicKnot2(.zero()), CubicKnot2(.zero())]);
    }

    this.path._setEdge(this);
    _constraints = EdgeConstraints.none;
  }

  NodeId _startId;
  NodeId get startId => _startId;
  Vertex get start => _topology!.getById(_startId);
  set start(Vertex vertex) => startId = vertex.id;
  set startId(NodeId value) {
    if (_startId == value) return;
    _topology?._removeStar(_startId, this);
    _startId = value;
    _topology?._addStar(_startId, this);
    _markNeedsLayout(.layout);
  }

  NodeId _endId;
  NodeId get endId => _endId;
  Vertex get end => _topology!.getById(_endId);
  set end(Vertex vertex) => endId = vertex.id;
  set endId(NodeId value) {
    if (_endId == value) return;
    _topology?._removeStar(_endId, this);
    _endId = value;
    _topology?._addStar(_endId, this);
    _markNeedsLayout(.layout);
  }

  late final EdgePath path;

  @override
  void _attachToTopology(Topology topology) {
    super._attachToTopology(topology);
    topology._addStar(_startId, this);
    topology._addStar(_endId, this);
  }

  @override
  void _detachFromTopology() {
    _topology!._removeStar(_startId, this);
    _topology!._removeStar(_endId, this);
    super._detachFromTopology();
  }

  @override
  void applyTransform(Matrix4 transform) {
    path.applyTransform(transform);
    _markNeedsLayout(.layout);
  }

  @override
  void setFrom(Edge other) {
    path.setFrom(other.path);
    constraints = other.constraints;
  }

  @override
  void performLayout(LayoutConstraints constraints) {
    final startPosition = start.getTransformTo(this).transform2(start.position);
    final endPosition = end.getTransformTo(this).transform2(end.position);

    path.first.p = startPosition;
    path.last.p = endPosition;

    path.layout();
  }

  @override
  Aabb2 get bbox => bboxTight;
  Aabb2 get bboxTight => path.bboxTight;

  @override
  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) {
    return _hitTestEdge(this, localPosition, globalToScene: globalToScene);
  }

  @override
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    return _hitTestRectEdge(this, localRect, mode: mode);
  }

  EdgeCutResult cut(double t) => topology.cutEdge(this, t);
  MultiEdgeCutResult cutMultiple(List<double> ts) => topology.multiCutEdge(this, ts);

  @override
  EdgeSnapshot snapshot() => .new(id: id, startId: _startId, endId: _endId, path: path.snapshot());

  @override
  void applySnapshot(covariant EdgeSnapshot snapshot) {
    startId = snapshot.startId;
    endId = snapshot.endId;
    path.applySnapshot(snapshot.path);
  }

  @override
  NodeType get type => .edge;
}

class EdgeSnapshot extends NodeSnapshot {
  const EdgeSnapshot({required super.id, required this.startId, required this.endId, required this.path});

  final NodeId startId;
  final NodeId endId;
  final EdgePathSnapshot path;
}
