import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:ui/ui.dart' as ui;

part 'resize_nodes/resize_nodes_activities.dart';
part 'resize_nodes/single_node_resize.dart';
part 'resize_nodes/multi_node_resize.dart';

class ResizeNodesActivity {
  static DragActivity edge(Editor editor, {required List<SceneNode> nodes, required ui.Edge edge}) {
    final targetNodes = NodeGroupActivity.getTargetNodes(nodes);

    if (targetNodes.length > 1) {
      return _EdgeResizeMultiNodeActivity(editor, nodes: targetNodes, edge: edge);
    } else {
      return _EdgeResizeSingleNodeActivity(editor, nodes: targetNodes.toList(), edge: edge);
    }
  }

  static DragActivity corner(Editor editor, {required List<SceneNode> nodes, required ui.Corner corner}) {
    final targetNodes = NodeGroupActivity.getTargetNodes(nodes);

    if (targetNodes.length > 1) {
      return _CornerResizeMultiNodeActivity(editor, nodes: targetNodes, corner: corner);
    } else {
      return _CornerResizeSingleNodeActivity(editor, nodes: targetNodes.toList(), corner: corner);
    }
  }
}
