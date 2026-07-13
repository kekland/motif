part of '../core.dart';

final class Edge extends Cell {
  Edge(
    Vertex start,
    Vertex end, {
    ObjectId? id,
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

    this.path._edge = this;
  }

  ObjectId _startId;
  ObjectId get startId => _startId;
  set startId(ObjectId value) {
    if (_startId == value) return;
    _scene?._removeStar(_startId, this);
    _startId = value;
    _scene?._addStar(_startId, this);
    _markNeedsLayout();
  }

  ObjectId _endId;
  ObjectId get endId => _endId;
  set endId(ObjectId value) {
    if (_endId == value) return;
    _scene?._removeStar(_endId, this);
    _endId = value;
    _scene?._addStar(_endId, this);
    _markNeedsLayout();
  }

  late final EdgePath path;

  Vertex get start => _scene!._getObject(_startId);
  Vertex get end => _scene!._getObject(_endId);

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
  void setFrom(Edge other) {
    // startId = other.startId;
    // endId = other.endId;
  }

  @override
  void applyTransform(Matrix4 transform) {}

  @override
  Size performLayout([BoxConstraints? constraints]) {
    final startPosition = start.position;
    final endPosition = end.position;

    path.first.p = startPosition;
    path.last.p = endPosition;
    
    final bbox = path.bbox;
    return Size(bbox.width, bbox.height);
  }

  @override
  Aabb2 get bbox => path.bbox;

  @override
  Aabb2 get bboxTight => path.bboxTight;

  @override
  ReadonlySignal<Edge> call() => _scene!._signalFor(this);
}
