part of '../core.dart';

final class Vertex extends Cell {
  Vertex(this._position, {super.id}) : super(transform: .translationValues(_position.x, _position.y));

  final Vector2 _position;
  Vector2 get position => _position;
  set position(Vector2 value) {
    if (_position == value) return;
    _position.setFrom(value);
    _transform._setTranslationRaw(value.x, value.y);
    _markNeedsLayout();
  }

  @override
  set transform(ObjectTransform value) {
    if (_transform == value) return;
    super.transform = value;
    _position.setValues(_transform.dx, _transform.dy);
    _markNeedsLayout();
  }

  @override
  void setFrom(Vertex vertex) {
    position = vertex.position;
  }

  @override
  void applyTransform(Matrix4 transform) {
    position = transform.transform2(position);
  }

  @override
  Size performLayout([BoxConstraints? constraints]) => .zero;

  @override
  Aabb2 get bbox => .minMax(.zero(), .zero());

  @override
  Aabb2 get bboxTight => bbox;

  @override
  ReadonlySignal<Vertex> call() => _scene!._signalFor(this);
}
