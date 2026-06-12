part of 'cursor_activities.dart';

class MoveKnotActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveKnotActivity({required super.controller, required this.knot});

  final CubicKnot2 knot;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2 startPosition;
  late final Vector2? startCIn;
  late final Vector2? startCOut;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    controller.selection.select(knot);

    startPosition = knot.p.clone();
    startCIn = knot.cIn?.clone();
    startCOut = knot.cOut?.clone();
  }

  @override
  void applyDelta(Offset delta) {
    final deltaVector = delta.asVector2();

    knot.p = startPosition + deltaVector;
    if (startCIn != null) knot.cIn = startCIn! + deltaVector;
    if (startCOut != null) knot.cOut = startCOut! + deltaVector;

    controller.complex.notifyListeners();
  }
}
