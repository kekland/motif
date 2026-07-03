import 'package:geometry/geometry.dart';
import 'package:vc/core/core.dart';

class MirrorModifier extends Modifier {
  MirrorModifier({super.isEnabled});

  Vector2 _mirror(Vector2 p) => .new(-p.x, p.y);
  Vector2? _maybeMirror(Vector2? p) => p != null ? _mirror(p) : null;

  @override
  (Cell, List<Cell>) apply(VectorComplexContext context, Cell cell) {
    return switch (cell) {
      Vertex v => _applyVertex(v),
      Edge e => _applyEdge(e),
    };
  }

  (Vertex, List<Vertex>) _applyVertex(Vertex vertex) {
    final mirroredVertex = Vertex(_mirror(vertex.position));
    return (vertex, [mirroredVertex]);
  }

  (Edge, List<Cell>) _applyEdge(Edge edge) {
    final path = edge.path.copy();
    for (final k in path.knots) {
      k.p = _mirror(k.p);
      k.cIn = _maybeMirror(k.cIn);
      k.cOut = _maybeMirror(k.cOut);
    }

    final mirroredStart = _applyVertex(edge.start).$2.first;
    final mirroredEnd = _applyVertex(edge.end).$2.first;

    final mirroredEdge = Edge(
      mirroredStart,
      mirroredEnd,
      path: path,
      weights: edge.weights.copyWith(),
      decoration: edge.decoration.copyWith(),
    );

    print('apply');

    return (edge, [mirroredStart, mirroredEnd, mirroredEdge]);
  }

  MirrorModifier copyWith({bool? isEnabled}) {
    return MirrorModifier(isEnabled: isEnabled ?? this.isEnabled);
  }
}
