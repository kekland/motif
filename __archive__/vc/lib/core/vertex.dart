part of 'core.dart';

final class VertexPrimitive extends CellPrimitive {
  VertexPrimitive({required this.position, super.id});
  final Vector2 position;

  @override
  VertexPrimitive copyWith({
    Vector2? position,
    CellId id = .keep,
  }) => .new(
    position: position ?? this.position.clone(),
    id: .resolve(this.id, id),
  );

  @override
  VertexPrimitive transform(Matrix4 transform, {CellId id = .keep}) {
    return .new(
      position: transform.transform2(position),
      id: .resolve(this.id, id),
    );
  }

  Vertex inflate() => .new(position.clone(), id: id);
}

final class Vertex extends Cell {
  Vertex(
    this._position, {
    super.modifiers,
    super.id,
  });

  final Vector2 _position;

  Vector2 get position => _position;
  set position(Vector2 value) {
    if (_position == value) return;
    _position.setFrom(value);
    _markAsDirty();

    for (final c in star) c._markAsDirty();
  }

  // dart format off
  @override Aabb2 get bbox => Aabb2.minMax(_position, _position);
  @override Aabb2 get bboxTight => Aabb2.minMax(_position, _position);
  // dart format on

  @override
  Vertex copyWith({
    Vector2? position,
    List<Modifier>? modifiers,
    CellId id = .keep,
  }) => .new(
    position ?? this.position.clone(),
    modifiers: modifiers ?? this.modifiers,
    id: .resolve(this.id, id),
  );

  @override
  ReadonlySignal<Vertex> call() => _complex!._signalFor(this);

  @override
  VertexPrimitive deflate() => .new(
    position: position.clone(),
    id: id,
  );
}
