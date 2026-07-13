import 'dart:math' as math;

import 'package:design/imports.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';
import 'package:vector_math/vector_math_64.dart';

part 'activities/selection_resize_nodes_activity.dart';
part 'activities/selection_rotate_nodes_activity.dart';

MouseCursor _resolveRotatingCursor(RotatingMouseCursor cursor, List<RenderNode> nodes, {Edge? edge, Corner? corner}) {
  if (nodes.length > 1) return cursor;

  final node = nodes.single;
  final transform = node.getTransformTo(null);
  return cursor.resolveRaw(transform, edge: edge, corner: corner);
}
