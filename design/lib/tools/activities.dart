import 'package:design/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';

export 'cursor/selection/selection_activities.dart';
export 'move/move_nodes_activity.dart';
export 'marquee/select_nodes_activity.dart';

abstract class NodeDragActivity extends DragActivity {
  NodeDragActivity({required this.controller, required this.nodes});

  final DesignController controller;
  RenderRootNode get root => controller.renderRootNode;

  final List<MutableNode> nodes;
  late final List<ImmutableNode> initialNodes;
  late final List<RenderNode> renderNodes;
  late final List<Matrix4> globalToNodes;
  late final List<Matrix4> globalToParent;

  Matrix4 get globalToRoot => Matrix4.inverted(root.getTransformTo(null));
  Matrix4 getGlobalToNode(int i) => globalToNodes[i];
  Matrix4 getGlobalToParent(int i) => globalToParent[i];

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    initialNodes = nodes.map((n) => n.copyAsImmutable()).toList();
    renderNodes = nodes.map((n) => root.getRenderNode(n)!).toList();
    globalToNodes = renderNodes.map((n) => Matrix4.inverted(n.getTransformTo(null))).toList();
    globalToParent = renderNodes.map((n) => Matrix4.inverted(n.parentNode!.getTransformTo(null))).toList();
  }
}

mixin ExclusiveCursorDragActivity on DragActivity {
  MouseCursor get cursor;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    ExclusiveMouseCursor.instance.set(cursor);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    ExclusiveMouseCursor.instance.set(cursor);
    super.onUpdate(details);
  }

  @override
  void onEnd(DragEndDetails? details) {
    ExclusiveMouseCursor.instance.release();
    super.onEnd(details);
  }
}
