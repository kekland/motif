part of '../../core.dart';

class MirrorEdgeModifier extends EdgeModifier {
  MirrorEdgeModifier({super.isEnabled});

  Vector2 _mirror(Vector2 p) => .new(-p.x, p.y);
  Vector2? _maybeMirror(Vector2? p) => p != null ? _mirror(p) : null;

  @override
  (ImmutableEdge, List<ImmutableCell>) apply(ImmutableEdge cell) {
    final knots = cell.path.knots.copy();
    for (final k in knots) {
      k.p = _mirror(k.p);
      k.cIn = _maybeMirror(k.cIn);
      k.cOut = _maybeMirror(k.cOut);
    }

    final mirroredStart = ImmutableVertex(_mirror(cell.start.position));
    final mirroredEnd = ImmutableVertex(_mirror(cell.end.position));

    final mirroredEdge = ImmutableEdge(
      cell.start,
      cell.end,
      path: .immutable(knots: knots),
      weights: cell.weights.asImmutable(),
      decoration: cell.decoration.asImmutable(),
    );

    return (cell, [mirroredStart, mirroredEnd, mirroredEdge]);
  }

  MirrorEdgeModifier copyWith({bool? isEnabled}) {
    return MirrorEdgeModifier(isEnabled: isEnabled ?? this.isEnabled);
  }
}
