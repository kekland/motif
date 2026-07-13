part of 'move_object_activity.dart';

final class MoveEdgeActivity extends _MoveObjectActivity<Edge> {
  MoveEdgeActivity(super.controller, super.object);

  Edge get edge => object;

  late final EdgePath startPath;
  late final List<(Edge, CubicKnot2, bool)> connectedEdges;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startPath = edge.path.copy();

    connectedEdges = [];
    for (final v in [edge.start, edge.end]) {
      for (final e in v.star.whereType<Edge>()) {
        if (e == edge) continue;

        final isStart = e.start == v;
        final knot = isStart ? e.path.first : e.path.last;
        connectedEdges.add((e, knot.copy(), isStart));
      }
    }
  }

  @override
  void applyDelta(Vector2 delta) {
    edge.start.position = startPath.first.p + delta;
    edge.end.position = startPath.last.p + delta;

    for (final (edge, knot, isStart) in connectedEdges) {
      if (isStart) {
        edge.path.first.setFrom(knot.shifted(delta));
      } else {
        edge.path.last.setFrom(knot.shifted(delta));
      }
    }

    for (var i = 0; i < edge.path.length; i++) {
      edge.path.knot(i).setFrom(startPath.knot(i).shifted(delta));
    }
  }
}
