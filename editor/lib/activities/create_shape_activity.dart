import 'dart:math' as math;

import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateShapeActivity<S extends ShapeStatement> extends DragActivity with KeyboardListenerDragActivity {
  CreateShapeActivity(this.editor);

  final Editor editor;
  SceneTransaction? transaction;
  late final S statement;

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

    final localPosition = editor.globalToLocal(parent, details.globalPosition);
    statement = create(localPosition, parent);

    transaction!.insert(statement);
    transaction!.flush();
    editor.selection.set(statement.frame);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final parent = statement.parent?.ref;
    final a = editor.globalToLocal(parent, startDetails.globalPosition);
    var d = editor.globalToLocal(parent, details.globalPosition) - a;

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
  void onEnd(DragEndDetails? details) {
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
  super.editor,
) extends CreateShapeActivity<ContainerStatement> {
  @override
  ContainerStatement create(Vec2 position, FrameRef? parent) => ContainerStatement(
    transform: .translation2(position),
    parent: parent,
  );
}

final class CreateRectangleActivity(
  super.editor,
) extends CreateShapeActivity<RectangleStatement> {
  @override
  RectangleStatement create(Vec2 position, FrameRef? parent) => RectangleStatement(
    transform: .translation2(position),
    parent: parent,
  );
}

final class CreateEllipseActivity(
  super.editor,
) extends CreateShapeActivity<EllipseStatement> {
  @override
  EllipseStatement create(Vec2 position, FrameRef? parent) => EllipseStatement(
    transform: .translation2(position),
    parent: parent,
  );
}

final class CreatePolygonActivity(
  super.editor,
) extends CreateShapeActivity<PolygonStatement> {
  @override
  PolygonStatement create(Vec2 position, FrameRef? parent) => PolygonStatement(
    transform: .translation2(position),
    parent: parent,
  );
}
