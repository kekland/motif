part of 'move_object_activity.dart';

final class MoveKnotActivity extends _MoveObjectActivity<CubicKnot2> {
  MoveKnotActivity(super.controller, super.object, this.edge, this.knotIndex);

  final Edge edge;
  final int knotIndex;

  late final CubicKnot2 startKnot;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startKnot = object.copy();
  }

  @override
  void applyDelta(Vector2 delta) {
    edge.path.knot(knotIndex).setFrom(startKnot.shifted(delta));
  }
}
