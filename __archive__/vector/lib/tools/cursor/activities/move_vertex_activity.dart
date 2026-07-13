part of 'move_object_activity.dart';

final class MoveVertexActivity extends _MoveObjectActivity<Vertex> {
  MoveVertexActivity(super.controller, super.object);

  Vertex get vertex => object;

  late final Vector2 startPosition;
  late final List<(Edge, CubicKnot2, bool)> connectedEdges;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    startPosition = vertex.position.clone();
    connectedEdges = [];

    final edges = vertex.star.whereType<Edge>().toList();
    for (final e in edges) {
      final isStart = e.start == vertex;
      final knot = isStart ? e.path.knots.first : e.path.knots.last;
      connectedEdges.add((e, knot.copy(), isStart));
    }
  }

  @override
  void applyDelta(Vector2 delta) {
    final position = startPosition + delta;
    vertex.position = position;

    for (final (edge, knot, isStart) in connectedEdges) {
      if (isStart) {
        edge.path.first.setFrom(knot.shifted(delta));
      } else {
        edge.path.last.setFrom(knot.shifted(delta));
      }
    }
  }
}
