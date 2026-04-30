part of 'cursor_activities.dart';

class MoveKnotControlPointsActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveKnotControlPointsActivity({required super.controller, required this.knot, required this.isC1});

  final CubicKnot2 knot;
  final bool isC1;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2? cInStartPosition;
  late final Vector2? cOutStartPosition;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    cInStartPosition = knot.cIn?.clone();
    cOutStartPosition = knot.cOut?.clone();
  }

  @override
  void applyDelta(Offset delta) {
    final deltaVec = delta.asVector2();

    // Symmetric by default
    if (isC1) {
      final newCIn = (cInStartPosition ?? knot.p) + deltaVec;
      final newCOut = cOutStartPosition != null ? knot.p + (knot.p - newCIn) : null;
      knot.cIn = newCIn;
      knot.cOut = newCOut;
    } else {
      final newCOut = (cOutStartPosition ?? knot.p) + deltaVec;
      final newCIn = cInStartPosition != null ? knot.p + (knot.p - newCOut) : null;
      knot.cOut = newCOut;
      knot.cIn = newCIn;
    }

    controller.complex.notifyListeners();
  }
}
