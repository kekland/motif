part of 'cursor_activities.dart';

class MoveKnotActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveKnotActivity({required super.controller, required this.knot});

  final CubicKnot2 knot;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2 startPosition;
  late final Vector2? startC1;
  late final Vector2? startC2;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startPosition = knot.p.clone();
    startC1 = knot.c1?.clone();
    startC2 = knot.c2?.clone();
  }

  @override
  void applyDelta(Offset delta) {
    final deltaVector = delta.asVector2();

    knot.p = startPosition + deltaVector;
    if (startC1 != null) knot.c1 = startC1! + deltaVector;
    if (startC2 != null) knot.c2 = startC2! + deltaVector;

    controller.complex.notifyListeners();
  }
}
