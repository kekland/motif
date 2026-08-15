part of '../core.dart';

final class Vertex extends Cell {
  Vertex(this._position, {super.id, super.topologyId}) {
    _constraints = VertexConstraints.none;
  }

  final Vector2 _position;
  Vector2 get position => _position;
  set position(Vector2 value) {
    if (_position == value) return;
    _position.setFrom(value);
    _markNeedsLayout(.transform);
  }

  @override
  void applyTransform(Matrix4 transform) {
    position = transform.transform2(position);
  }

  @override
  void setFrom(Vertex other) {
    position = other.position;
    constraints = other.constraints;
  }

  @override
  Aabb2 get bbox => .minMax(position, position);

  @override
  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) {
    return _hitTestVertex(this, localPosition, globalToScene: globalToScene);
  }

  @override
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {HitTestRectMode mode = .normal}) {
    return _hitTestRectVertex(this, localRect);
  }

  @override
  VertexSnapshot snapshot() => .new(id: id, position: position.clone());

  @override
  void applySnapshot(covariant VertexSnapshot snapshot) {
    position = snapshot.position.clone();
  }

  @override
  NodeType get type => .vertex;

  @override
  void performLayout(VertexConstraints constraints) {
    position = constraints.constrain(position);
  }
}

class VertexSnapshot extends NodeSnapshot {
  const VertexSnapshot({required super.id, required this.position});

  final Vector2 position;
}
