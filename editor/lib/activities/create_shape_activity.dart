import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateShapeActivity<S extends ShapeStatement> extends DragActivity {
  CreateShapeActivity(this.editor);

  final Editor editor;
  late final S statement;

  S create(Vec2 position, FrameRef? parent);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final hitTest = editor.hitTest(details.globalPosition);

    FrameRef? parent;
    for (final frame in hitTest.frames) {
      final id = frame.statementId;
      final statement = editor.program.byId(id)!;
      if (statement is ContainerStatement) {
        parent = statement.frame;
        break;
      }
    }

    final localPosition = editor.globalToLocal(parent, details.globalPosition);
    statement = create(localPosition, parent);

    editor.edit((txn) => txn.insert(statement));
    editor.selection.setStatement(statement.id);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final parent = statement.parent?.ref;
    final a = editor.globalToLocal(parent, startDetails.globalPosition);
    final b = editor.globalToLocal(parent, details.globalPosition);

    final aabb = Aabb2.bbox2(a, b);

    final newStatement = statement.copyWith(
      transform: .translation2(aabb.min),
      size: .fixed(aabb.width, aabb.height),
    );

    editor.edit((txn) => txn.replace(statement.id, [newStatement]));
  }

  @override
  void onEnd(DragEndDetails? details) {
    editor.tool.activeTool = tools.cursor;
    super.onEnd(details);
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

final class CreateCircleActivity(
  super.editor,
) extends CreateShapeActivity<CircleStatement> {
  @override
  CircleStatement create(Vec2 position, FrameRef? parent) => CircleStatement(
    transform: .translation2(position),
    parent: parent,
  );
}

final class CreateTriangleActivity(
  super.editor,
) extends CreateShapeActivity<TriangleStatement> {
  @override
  TriangleStatement create(Vec2 position, FrameRef? parent) => TriangleStatement(
    transform: .translation2(position),
    parent: parent,
  );
}
