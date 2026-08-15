import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateContainerActivity extends DragActivity {
  CreateContainerActivity({required this.editor});

  final Editor editor;
  late final ContainerStatement container;

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
    container = ContainerStatement(
      size: .zero,
      transform: .translation2(localPosition),
      parent: parent,
    );

    editor.edit((txn) => txn.insert(container));
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final parent = container.parent?.ref;
    final a = editor.globalToLocal(parent, startDetails.globalPosition);
    final b = editor.globalToLocal(parent, details.globalPosition);

    final aabb = Aabb2.bbox2(a, b);

    final newRectangle = container.copyWith(
      transform: .translation2(aabb.min),
      size: .fixed(aabb.width, aabb.height),
      shape: .circular(32.0),
    );

    editor.edit((txn) => txn.replace(container.id, [newRectangle]));
  }
}
