import 'package:flutter/gestures.dart';
import 'package:vector/imports.dart';

part 'move_edge_activity.dart';
part 'move_knot_control_point_activity.dart';
part 'move_vertex_activity.dart';
part 'move_knot_activity.dart';

class MoveObjectActivity extends DragActivity with ExclusiveCursorDragActivity2 {
  MoveObjectActivity({
    required this.controller,
  });

  final VectorController controller;
  _MoveObjectActivity? _innerActivity;

  @override
  bool shouldAccept(PointerDownEvent event) {
    final hits = controller.hitTestCells(event.position);

    for (final h in hits) {
      final activity = _MoveObjectActivity.fromHitTestEntry(controller, h);
      if (activity != null) {
        _innerActivity = activity;
        return true;
      }
    }

    return false;
  }

  @override
  MouseCursor get cursor => Cursors.toolMove;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    _innerActivity?.onStart(details);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    _innerActivity?.onUpdate(details);
    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    _innerActivity?.onEnd(details);
    super.onEnd(details);
  }
}

sealed class _MoveObjectActivity<T> extends DragActivity {
  _MoveObjectActivity(this.controller, this.object);

  static _MoveObjectActivity? fromHitTestEntry(VectorController controller, CellHitTestEntry entry) {
    final object = entry.hitObject;

    if (entry is KnotControlPointHitTestEntry) {
      return MoveKnotControlPointActivity(
        controller,
        entry.cell,
        entry.knotIndex,
        entry.hitObject,
      );
    } else if (entry is EdgeKnotHitTestEntry) {
      return MoveKnotActivity(
        controller,
        entry.hitObject,
        entry.cell,
        entry.knotIndex,
      );
    }

    if (object is Vertex) {
      return MoveVertexActivity(controller, object);
    } else if (object is Edge) {
      return MoveEdgeActivity(controller, object);
    }

    return null;
  }

  final VectorController controller;
  final T object;

  @override
  void onUpdate(DragUpdateDetails details) {
    final render = controller.render;
    final delta = render.globalToLocal(details.globalPosition) - render.globalToLocal(startDetails.globalPosition);
    applyDelta(delta.vec2);

    super.onUpdate(details);
  }

  void applyDelta(Vector2 delta);
}
