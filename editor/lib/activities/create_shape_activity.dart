import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateShapeActivity<S extends ShapeStatement> extends DragActivity {
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
      final statement = editor.program.byId(id)!;
      if (statement is ContainerStatement) {
        parent = statement.frame;
        break;
      }
    }

    final localPosition = editor.globalToLocal(parent, details.globalPosition);
    statement = create(localPosition, parent);

    transaction!.insert(statement);
    transaction!.preview();
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

    transaction!.replace(statement.id, [newStatement]);
    transaction!.preview();
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
