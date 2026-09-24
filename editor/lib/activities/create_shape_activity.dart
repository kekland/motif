import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateShapeActivity<S extends ShapeStatement> extends DragActivity with KeyboardListenerDragActivity {
  CreateShapeActivity(
    this.editor, {
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
    this.snapToPixel = false,
  });

  final Editor editor;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final bool snapToPixel;

  late final Vec2 startPosition;
  late final S statement;

  SceneTransaction? transaction;
  final mergeKey = Object();

  S create(Vec2 position, FrameRef? parent);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    transaction = editor.beginTransaction();
    final hitTest = editor.hitTest(details.globalPosition);

    FrameRef? parent;
    for (final frame in hitTest.frames) {
      final id = frame.statementId;
      final statement = editor.statement(id);
      if (statement is ContainerStatement) {
        parent = statement.frame;
        break;
      }
    }

    var localPosition = editor.globalToLocal(parent, details.globalPosition);
    if (snapToPixel) localPosition = localPosition.round();
    startPosition = localPosition;

    statement = create(startPosition, parent);
    transaction!.insert(statement);
    transaction!.flush();
    editor.selection.set(statement.frame);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final parent = statement.parent?.ref;
    final a = startPosition;
    var d = editor.globalToLocal(parent, details.globalPosition) - a;
    if (snapToPixel) d = d.round();

    if (isShiftPressed) {
      final side = math.max(d.x.abs(), d.y.abs());
      d = Vec2(side * d.x.sign, side * d.y.sign);
    }

    final aabb = isAltPressed ? Aabb2.bbox2(a - d, a + d) : Aabb2.bbox2(a, a + d);

    final newStatement = statement.copyWith(
      transform: .translation2(aabb.min),
      size: .fixed(aabb.width, aabb.height),
    );

    transaction!.replace(statement.id, [newStatement]);
    transaction!.flush();
  }

  @override
  void onEnd(DragEndDetails details) {
    transaction!.commit(mergeKey: mergeKey);
    editor.tool.activeTool = tools.cursor;
    super.onEnd(details);
  }

  @override
  void onCancel() {
    transaction?.cancel();
    super.onCancel();
  }
}

final class CreateContainerActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
}) extends CreateShapeActivity<ContainerStatement> {
  @override
  ContainerStatement create(Vec2 position, FrameRef? parent) => ContainerStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreateRectangleActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
}) extends CreateShapeActivity<RectangleStatement> {
  @override
  RectangleStatement create(Vec2 position, FrameRef? parent) => RectangleStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreateEllipseActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
}) extends CreateShapeActivity<EllipseStatement> {
  @override
  EllipseStatement create(Vec2 position, FrameRef? parent) => EllipseStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}

final class CreatePolygonActivity(
  super.editor, {
  super.snapToPixel,
  super.edgeStyle,
  super.faceStyle,
}) extends CreateShapeActivity<PolygonStatement> {
  @override
  PolygonStatement create(Vec2 position, FrameRef? parent) => PolygonStatement(
    transform: .translation2(position),
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}
