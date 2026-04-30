part of 'cursor_activities.dart';

class MoveVertexActivity extends MoveDragActivity with ExclusiveCursorDragActivity {
  MoveVertexActivity({required super.controller, required this.vertex});

  final Vertex vertex;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  late final Vector2 startPosition;
  late final List<OpenEdge> connectedEdges;
  late final List<(Vector2?, Vector2?)> connectedEdgesInitialC1C2;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    startPosition = vertex.position;

    connectedEdges = vertex.directStar.whereType<OpenEdge>().toList();
    connectedEdgesInitialC1C2 = [];
    for (final e in connectedEdges) {
      connectedEdgesInitialC1C2.add((e.c1, e.c2));
    }
  }

  @override
  void applyDelta(Offset delta) {
    vertex.position = startPosition + delta.asVector2();

    for (final (i, e) in connectedEdges.indexed) {
      if (e.start == vertex && e.c1 != null) {
        final initial = connectedEdgesInitialC1C2[i].$1!;
        e.c1 = initial + delta.asVector2();
      } else if (e.end == vertex && e.c2 != null) {
        final initial = connectedEdgesInitialC1C2[i].$2!;
        e.c2 = initial + delta.asVector2();
      }
    }

    controller.complex.notifyListeners();
  }
}
