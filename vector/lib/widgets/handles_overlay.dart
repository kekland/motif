import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';
import 'package:vector/tools/cursor/activities/cursor_activities.dart';

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
    this.isVisible = true,
    this.areGesturesEnabled = true,
  });

  final VectorController controller;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => HandlesOverlay(
        controller: controller,
        childPaintTransform: info.childPaintTransform,
        areGesturesEnabled: areGesturesEnabled,
        hoveredCell: hoveredCell,
        isVisible: isVisible,
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
    this.isVisible = true,
  });

  final VectorController controller;
  final Matrix4 childPaintTransform;
  final bool areGesturesEnabled;
  final Cell? hoveredCell;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final complex = useListenable(controller.complex);
    final selection = useComputedValue(() => {...controller.selection.selectedObjects});
    final transientEdges = useListenable(controller.transientEdges).edges;

    final moveVertexActivityRecognizer = useDragActivityWithArgumentRecognizer<Vertex>(
      (v) => MoveVertexActivity(controller: controller, vertex: v),
      supportedDevices: {.stylus},
    );

    final moveKnotActivityRecognizer = useDragActivityWithArgumentRecognizer<(Edge, CubicKnot2)>(
      (k) => MoveKnotActivity(controller: controller, edge: k.$1, knot: k.$2),
      supportedDevices: {.stylus},
    );

    final moveKnotControlPointsActivity = useDragActivityWithArgumentRecognizer<(Edge, CubicKnot2, bool)>(
      (arg) => MoveKnotControlPointsActivity(controller: controller, edge: arg.$1, knot: arg.$2, isC1: arg.$3),
      supportedDevices: {.stylus},
    );

    final moveOpenEdgeControlPointActivity = useDragActivityWithArgumentRecognizer<(OpenEdge, bool)>(
      (arg) => MoveOpenEdgeControlPointActivity(controller: controller, edge: arg.$1, isC1: arg.$2),
      supportedDevices: {.stylus},
    );

    if (areGesturesEnabled) {
      final _value = PointerDeviceKind.values.toSet();
      moveVertexActivityRecognizer.supportedDevices = _value;
      moveKnotActivityRecognizer.supportedDevices = _value;
      moveKnotControlPointsActivity.supportedDevices = _value;
      moveOpenEdgeControlPointActivity.supportedDevices = _value;
    } else {
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
              isSelected: selection.contains(cell),
              onPointerDown: (e) => moveVertexActivityRecognizer.addPointer(e, argument: cell as Vertex),
            ),
          ),
        );
      } else if (cell is Edge) {
        final edge = cell;

        children.add(
          EdgeHandles(
            edge: edge,
            selection: selection,
            childPaintTransform: childPaintTransform,
            hoveredCell: hoveredCell,
            onKnotPointerDown: (e, knot) => moveKnotActivityRecognizer.addPointer(e, argument: (edge, knot)),
            onKnotControlPointPointerDown: (e, arg) =>
                moveKnotControlPointsActivity.addPointer(e, argument: (edge, arg.$1, arg.$2)),
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

    return Visibility(
      visible: isVisible,
      child: ClipRect(
        child: HandlesLayout(
          childPaintTransform: childPaintTransform,
          children: children,
        ),
      ),
    );
  }
}
