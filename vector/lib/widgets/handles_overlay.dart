import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';
import 'package:vector/tools/cursor/activities/cursor_activities.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

part 'handles/common.dart';
part 'handles/edge.dart';
part 'handles/handles.dart';
part 'handles/layout.dart';
part 'handles/transient.dart';

class HandlesOverlayBuilder extends HookWidget {
  const HandlesOverlayBuilder({
    super.key,
    required this.controller,
    this.hoveredCell,
    this.areGesturesEnabled = true,
  });

  final VectorController controller;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => HandlesOverlay(
        controller: controller,
        childPaintTransform: info.childPaintTransform,
        areGesturesEnabled: areGesturesEnabled,
        hoveredCell: hoveredCell,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class HandlesOverlay extends HookWidget {
  const HandlesOverlay({
    super.key,
    required this.controller,
    required this.childPaintTransform,
    this.areGesturesEnabled = true,
    this.hoveredCell,
  });

  final VectorController controller;
  final Matrix4 childPaintTransform;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;

  @override
  Widget build(BuildContext context) {
    final complex = useListenable(controller.complex);
    final selection = useComputedValue(() => {...controller.selection.selectedCells});
    final transientEdges = useListenable(controller.transientEdges).edges;

    final moveVertexActivityRecognizer = useDragActivityWithArgumentRecognizer<Vertex>(
      (v) => MoveVertexActivity(controller: controller, vertex: v),
    );

    final moveKnotActivityRecognizer = useDragActivityWithArgumentRecognizer<CubicKnot2>(
      (k) => MoveKnotActivity(controller: controller, knot: k),
    );

    final moveKnotControlPointsActivity = useDragActivityWithArgumentRecognizer<(CubicKnot2, bool)>(
      (arg) => MoveKnotControlPointsActivity(controller: controller, knot: arg.$1, isC1: arg.$2),
    );

    final moveOpenEdgeControlPointActivity = useDragActivityWithArgumentRecognizer<(OpenEdge, bool)>(
      (arg) => MoveOpenEdgeControlPointActivity(controller: controller, edge: arg.$1, isC1: arg.$2),
    );

    if (areGesturesEnabled) {
      final _value = PointerDeviceKind.values.toSet();
      moveVertexActivityRecognizer.supportedDevices = _value;
      moveKnotActivityRecognizer.supportedDevices = _value;
      moveKnotControlPointsActivity.supportedDevices = _value;
      moveOpenEdgeControlPointActivity.supportedDevices = _value;
    }
    else {
      final _value = <PointerDeviceKind>{.touch};
      moveVertexActivityRecognizer.supportedDevices = _value;
      moveKnotActivityRecognizer.supportedDevices = _value;
      moveKnotControlPointsActivity.supportedDevices = _value;
      moveOpenEdgeControlPointActivity.supportedDevices = _value;
    }

    final children = <Widget>[];
    for (var cell = complex.bottom; cell != null; cell = cell.next) {
      if (cell is Vertex) {
        children.add(
          HandleWidget(
            position: cell.position.asOffset(),
            child: VertexHandle(
              onPointerDown: (e) => moveVertexActivityRecognizer.addPointer(e, argument: cell as Vertex),
            ),
          ),
        );
      } else if (cell is Edge) {
        children.add(
          EdgeHandles(
            edge: cell,
            childPaintTransform: childPaintTransform,
            hoveredCell: hoveredCell,
            onKnotPointerDown: (e, knot) => moveKnotActivityRecognizer.addPointer(e, argument: knot),
            onKnotControlPointPointerDown: (e, arg) => moveKnotControlPointsActivity.addPointer(e, argument: arg),
            onOpenEdgeControlPointPointerDown: (e, arg) =>
                moveOpenEdgeControlPointActivity.addPointer(e, argument: arg),
          ),
        );
      }
    }

    for (final transientEdge in transientEdges) {
      children.add(
        TransientEdgeHandles(
          transientEdge: transientEdge,
          childPaintTransform: childPaintTransform,
        ),
      );
    }

    return HandlesLayout(
      childPaintTransform: childPaintTransform,
      children: children,
    );
  }
}
