part of 'core.dart';

final class EdgePrimitive extends CellPrimitive {
  EdgePrimitive({
    required this.startId,
    required this.endId,
    this.path,
    this.decoration,
    this.weights,
    super.id,
  });

  final CellId startId;
  final CellId endId;
  final CubicSpline2? path;
  final EdgeDecorationPrimitive? decoration;
  final EdgeWeightsPrimitive? weights;

  @override
  EdgePrimitive copyWith({
    CellId? startId,
    CellId? endId,
    CubicSpline2? path,
    EdgeDecorationPrimitive? decoration,
    EdgeWeightsPrimitive? weights,
  }) => .new(
    startId: startId ?? this.startId,
    endId: endId ?? this.endId,
    path: path ?? this.path?.copy(),
    decoration: decoration ?? this.decoration?.copyWith(),
    weights: weights ?? this.weights?.copyWith(),
    id: id,
  );

  Edge inflate(Vertex start, Vertex end) => .new(
    start,
    end,
    path: path != null ? .spline(path!) : null,
    decoration: decoration?.inflate(),
    weights: weights?.inflate(),
    id: id,
  );
}

final class Edge extends Cell {
  Edge(
    this.start,
    this.end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    super.modifiers,
    super.id,
  }) {
    if (path != null) {
      this.path = path;
      this.path.first.p = start.position;
      this.path.last.p = end.position;
    } else {
      final cubic = Cubic2.line(start.position.clone(), end.position.clone());
      this.path = .new([cubic.startKnot, cubic.endKnot]);
    }

    this.decoration = decoration ?? .new();
    this.weights = weights ?? .new();

    this.path._edge = this;
    this.decoration._edge = this;
    this.weights._edge = this;

    start._addStar(this);
    end._addStar(this);
  }

  final Vertex start;
  final Vertex end;

  late final EdgePath path;
  late final EdgeDecoration decoration;
  late final EdgeWeights weights;

  // dart format off
  @override Aabb2 get bbox => path.bbox;
  @override Aabb2 get bboxTight => path.bboxTight;
  // dart format on

  @override
  Edge copyWith({
    Vertex? start,
    Vertex? end,
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    List<Modifier<Cell>>? modifiers,
    CellId id = .keep,
  }) => .new(
    start ?? this.start,
    end ?? this.end,
    path: path ?? this.path.copyWith(),
    decoration: decoration ?? this.decoration.copyWith(),
    weights: weights ?? this.weights.copyWith(),
    modifiers: modifiers ?? this.modifiers,
    id: .resolve(this.id, id),
  );

  @override
  ReadonlySignal<Edge> call() => _complex!._signalFor(this);

  @override
  EdgePrimitive asPrimitive() => .new(
    startId: start.id,
    endId: end.id,
    decoration: decoration.asPrimitive(),
    path: path.asPrimitive(),
    weights: weights.asPrimitive(),
    id: id,
  );
}
