import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

sealed class CreateShapeActivity<S extends ShapeStatement> extends DragActivity {
  CreateShapeActivity(this.editor);

  final Editor editor;
  late final S statement;

  S create(Vec2 position);

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final localPosition = editor.globalToScene(details.globalPosition);
    statement = create(localPosition);

    editor.edit((txn) => txn.insert(statement));
    editor.selection.setStatement(statement.id);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final a = editor.globalToScene(startDetails.globalPosition);
    final b = editor.globalToScene(details.globalPosition);
    final aabb = Aabb2.bbox2(a, b);

    final newRectangle = statement.copyWith(
      transform: .translation2(aabb.min),
      size: .fixed(aabb.width, aabb.height),
    );

    editor.edit((txn) => txn.replace(statement.id, [newRectangle]));
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
  ContainerStatement create(Vec2 position) => ContainerStatement(transform: .translation2(position));
}

final class CreateRectangleActivity(
  super.editor,
) extends CreateShapeActivity<RectangleStatement> {
  @override
  RectangleStatement create(Vec2 position) => RectangleStatement(transform: .translation2(position));
}

final class CreateCircleActivity(
  super.editor,
) extends CreateShapeActivity<CircleStatement> {
  @override
  CircleStatement create(Vec2 position) => CircleStatement(transform: .translation2(position));
}

final class CreateTriangleActivity(
  super.editor,
) extends CreateShapeActivity<TriangleStatement> {
  @override
  TriangleStatement create(Vec2 position) => TriangleStatement(transform: .translation2(position));
}
