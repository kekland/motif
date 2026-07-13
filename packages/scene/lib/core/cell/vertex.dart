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
  void applyTransform(Matrix4 transform) {
    position = transform.transform2(position);
  }

  @override
  void setFrom(Vertex other) {
    position = other.position;
  }

  @override
  Aabb2 get boundingBox => .minMax(position, position);

  @override
  ReadonlySignal<Vertex> call() => _scene!._signalFor(this);

  @override
  List<SceneHitTestEntry> _hitTestCell(Vector2 localPosition, {Matrix4? globalToScene}) {
    return _hitTestVertex(this, localPosition, globalToScene: globalToScene);
  }

  @override
  List<SceneHitTestEntry> _hitTestRectCell(Aabb2 localRect, {RectHitTestMode mode = .normal}) {
    return _hitTestRectVertex(this, localRect);
  }
}
