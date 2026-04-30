part of 'cursor_activities.dart';

class MoveKnotControlPointsActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveKnotControlPointsActivity({required super.controller, required this.knot, required this.isC1});

  final CubicKnot2 knot;
  final bool isC1;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2? c1StartPosition;
  late final Vector2? c2StartPosition;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    c1StartPosition = knot.c1?.clone();
    c2StartPosition = knot.c2?.clone();
  }

  @override
  void applyDelta(Offset delta) {
    final deltaVec = delta.asVector2();

    // Symmetric by default
    if (isC1) {
      final newC1 = (c1StartPosition ?? knot.p) + deltaVec;
      final newC2 = c2StartPosition != null ? knot.p + (knot.p - newC1) : null;
      knot.c1 = newC1;
      knot.c2 = newC2;
    } else {
      final newC2 = (c2StartPosition ?? knot.p) + deltaVec;
      final newC1 = c1StartPosition != null ? knot.p + (knot.p - newC2) : null;
      knot.c2 = newC2;
      knot.c1 = newC1;
    }

    controller.complex.notifyListeners();
  }
}
