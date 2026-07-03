part of 'move_object_activity.dart';

class MoveKnotControlPointActivity extends _MoveObjectActivity<EdgeKnotControlPoint> {
  MoveKnotControlPointActivity(super.controller, this.edge, this.knotIndex, super.object);

  final Edge edge;
  final int knotIndex;

  late final Vector2 startPosition;

  bool get isIn => object.isIn;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startPosition = object.clone();
  }

  @override
  void applyDelta(Vector2 delta) {
    final newPosition = startPosition + delta;

    final knot = edge.path.knot(knotIndex);

    if (knotIndex != 0 && knotIndex != edge.path.length - 1) {
      var cIn = isIn ? newPosition : knot.cIn;
      var cOut = isIn ? knot.cOut : newPosition;

      if (isIn) {
        cOut = cIn!.pointReflect(knot.p);
      } else {
        cIn = cOut!.pointReflect(knot.p);
      }

      knot.cOut = cOut;
      knot.cIn = cIn;
    } else {
      if (isIn) {
        knot.cIn = newPosition;
      } else {
        knot.cOut = newPosition;
      }

      final vertex = knotIndex == 0 ? edge.start : edge.end;
      if (vertex.degree == 2) {
        final otherEdge = vertex.star.firstWhere((e) => e != edge) as Edge;
        final otherKnotIndex = isIn ? 0 : otherEdge.path.length - 1;
        final otherKnot = otherEdge.path.knot(otherKnotIndex);

        final otherC = newPosition.pointReflect(vertex.position);
        if (isIn) {
          otherKnot.cOut = otherC;
        } else {
          otherKnot.cIn = otherC;
        }
      }
    }
  }
}
