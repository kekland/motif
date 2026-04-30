part of 'cursor_activities.dart';

class MoveOpenEdgeControlPointActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveOpenEdgeControlPointActivity({required super.controller, required this.edge, required this.isC1});

  final OpenEdge edge;
  final bool isC1;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2 c1StartPosition;
  late final Vector2 c2StartPosition;
  late final OpenEdge? nextEdge;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    c1StartPosition = edge.c1 ?? edge.start.position;
    c2StartPosition = edge.c2 ?? edge.end.position;

    final vtx = isC1 ? edge.start : edge.end;
    final degree = vtx.directStar.length;
    if (degree == 2) {
      final other = vtx.directStar.firstWhere((e) => e != edge);
      if (other is OpenEdge)
        nextEdge = other;
      else
        nextEdge = null;
    } else {
      nextEdge = null;
    }
  }

  @override
  void applyDelta(Offset delta) {
    final deltaVec = delta.asVector2();

    if (isC1) {
      final newC1 = c1StartPosition + deltaVec;
      edge.c1 = c1StartPosition + deltaVec;

      if (nextEdge != null) {
        final pos = nextEdge!.end.position;
        nextEdge!.c2 = pos + (pos - newC1);
      }
    } else {
      final newC2 = c2StartPosition + deltaVec;
      edge.c2 = c2StartPosition + deltaVec;

      if (nextEdge != null) {
        final pos = nextEdge!.start.position;
        nextEdge!.c1 = pos + (pos - newC2);
      }
    }

    controller.complex.notifyListeners();
  }
}
