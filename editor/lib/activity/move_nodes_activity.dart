import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class MoveNodesActivity extends NodeGroupActivity with ExclusiveCursorDragActivity {
  MoveNodesActivity(
    super.editor, {
    required super.nodes,
    this._onStart,
  });

  final VoidCallback? _onStart;

  late final List<SceneNode> targetNodes;

  @override
  MouseCursor get cursor => Cursors.toolMove;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    _onStart?.call();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final startPosition = startDetails.globalPosition.vec2;
    final currentPosition = details.globalPosition.vec2;

    final sceneDelta = editor.globalToScene(currentPosition) - editor.globalToScene(startPosition);
    final transform = Matrix4.translationValues(sceneDelta.x, sceneDelta.y, 0);
    applyTransformToNodes(transform);
    super.onUpdate(details);
  }
}
