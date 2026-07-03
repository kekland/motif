part of 'core.dart';

mixin Edge on Cell implements Modifiable<ImmutableEdge> {
  Vertex get start;
  Vertex get end;

  EdgePath get path;
  EdgeDecoration get decoration;
  EdgeWeights get weights;

  bool get isLoop => start.id == end.id;

  ImmutableEdge asImmutable(ImmutableVertex start, ImmutableVertex end) => .new(
    start,
    end,
    path: path.asImmutable(),
    decoration: decoration.asImmutable(),
    weights: weights.asImmutable(),
    modifiers: modifiers.toList(),
    id: id,
  );

  MutableEdge asMutable(MutableVertex start, MutableVertex end) => .new(
    start,
    end,
    path: path.asMutable(),
    decoration: decoration.asMutable(),
    weights: weights.asMutable(),
    modifiers: modifiers.toList(),
    id: id,
  );

  @override
  Aabb2 get bbox => path.bbox;
  Aabb2 get bboxTight => path.bboxTight;
}

class ImmutableEdge extends ImmutableCell with Edge, ImmutableModifiable<ImmutableEdge> {
  ImmutableEdge(
    this.start,
    this.end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    this._modifiers = const [],
    super.id,
  }) {
    if (path != null) {
      this.path = path.asImmutable();
    } else {
      final cubic = Cubic2.line(start.position.clone(), end.position.clone());
      this.path = .new(knots: [cubic.startKnot, cubic.endKnot]);
    }

    this.decoration = decoration?.asImmutable() ?? .default_;
    this.weights = weights?.asImmutable() ?? .default_;

    start._addStar(this);
    end._addStar(this);
  }

  ImmutableEdge.loop(
    ImmutableVertex vertex, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    int? id,
    List<EdgeModifier> modifiers = const [],
  }) : this(
         vertex,
         vertex,
         path: path,
         decoration: decoration,
         weights: weights,
         modifiers: modifiers,
         id: id,
       );

  // dart format off
  @override final ImmutableVertex start;
  @override final ImmutableVertex end;
  @override late final ImmutableEdgePath path;
  @override late final ImmutableEdgeDecoration decoration;
  @override late final ImmutableEdgeWeights weights;
  @override final List<EdgeModifier> _modifiers;
  // dart format on

  @override
  ImmutableEdge copyWith({
    ImmutableVertex? start,
    ImmutableVertex? end,
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<EdgeModifier>? modifiers,
  }) {
    return .new(
      start ?? this.start,
      end ?? this.end,
      path: path ?? this.path,
      decoration: decoration ?? this.decoration,
      weights: weights ?? this.weights,
      modifiers: modifiers ?? _modifiers.toList(),
      id: id,
    );
  }
}

final class MutableEdge extends MutableCell with Edge, MutableModifiable<ImmutableEdge> {
  MutableEdge(
    this.start,
    this.end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<EdgeModifier>? modifiers,
    super.id,
  }) {
    if (path != null) {
      this.path = $disposable(path.asMutable());
      this.path._knots.first.p = start.position.clone();
      this.path._knots.last.p = end.position.clone();
    } else {
      final cubic = Cubic2.line(start.position.clone(), end.position.clone());
      this.path = $disposable(.new(knots: [cubic.startKnot, cubic.endKnot]));
    }

    $listen(this.path, notifyListeners);
    $listen(start, _onStartChanged);
    $listen(end, _onEndChanged);

    this.decoration = $disposable(decoration?.asMutable() ?? .new());
    $listen(this.decoration, notifyListeners);

    this.weights = $disposable(weights?.asMutable() ?? .new());
    $listen(this.weights, notifyListeners);

    _modifiers = $listSignal(modifiers ?? []);

    start._addStar(this);
    end._addStar(this);

    notifyListenersOn([_modifiers]);
  }

  MutableEdge.loop(
    MutableVertex vertex, {
    int? id,
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<EdgeModifier>? modifiers,
  }) : this(
         vertex,
         vertex,
         path: path,
         decoration: decoration,
         weights: weights,
         modifiers: modifiers,
         id: id,
       );

  // dart format off
  @override final MutableVertex start;
  @override final MutableVertex end;
  @override late final MutableEdgePath path;
  @override late final MutableEdgeDecoration decoration;
  @override late final MutableEdgeWeights weights;
  @override late final ListSignal<EdgeModifier> _modifiers;
  // dart format on

  void _onStartChanged() {
    path.knots.first.p = start.position.clone();
    notifyListeners();
  }

  void _onEndChanged() {
    path.knots.last.p = end.position.clone();
    notifyListeners();
  }

  @override
  void dispose() {
    start._removeStar(this);
    end._removeStar(this);
    super.dispose();
  }
}
