part of '../core.dart';

final class Vertex extends Cell {
  Vertex(this._position, {super.id});

  final Vector2 _position;
  Vector2 get position => _position;
  set position(Vector2 value) {
    if (_position == value) return;
    _position.setFrom(value);
    _markNeedsLayout();
  }

  @override
  void transformWith(Matrix4 transform) {
    position = transform.transform2(position);
  }

  @override
  void setFrom(Vertex other) {
    position = other.position;
  }

  @override
  Aabb2 get boundingBox => .minMax(position, position);

  @override
  ResolvedSize get resolvedSize => .zero;

  @override
  ReadonlySignal<Vertex> call() => _scene!._signalFor(this);

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
}

class VertexSnapshot extends NodeSnapshot {
  const VertexSnapshot({required super.id, required this.position});

  final Vector2 position;
}
