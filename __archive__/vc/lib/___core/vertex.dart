part of 'core.dart';

mixin Vertex on Cell implements Modifiable<ImmutableVertex> {
  Vector2 get position;

  ImmutableVertex asImmutable() => .new(position.clone(), id: id);
  MutableVertex asMutable() => .new(position.clone(), id: id);

  @override
  Aabb2 get bbox => .centerAndHalfExtents(position, .zero());
}

class ImmutableVertex extends ImmutableCell with Vertex, ImmutableModifiable<ImmutableVertex> {
  ImmutableVertex(Vector2 position, {super.id, this._modifiers = const []}) : position = position.clone();

  @override
  final Vector2 position;

  @override
  final List<VertexModifier> _modifiers;

  @override
  ImmutableVertex copyWith({Vector2? position, List<VertexModifier>? modifiers}) {
    return .new(
      position ?? this.position.clone(),
      modifiers: modifiers ?? _modifiers.toList(),
      id: id,
    );
  }
}

final class MutableVertex extends MutableCell with Vertex, MutableModifiable<ImmutableVertex> {
  MutableVertex(Vector2 position, {super.id, List<VertexModifier>? modifiers}) {
    _position = $signal(position.clone());
    _modifiers = $listSignal(modifiers ?? []);

    notifyListenersOn([_position, _modifiers]);
  }

  @override
  Vector2 get position => _position.value;
  set position(Vector2 value) => _position.value = value;
  late final Signal<Vector2> _position;

  @override
  late final ListSignal<VertexModifier> _modifiers;
}
