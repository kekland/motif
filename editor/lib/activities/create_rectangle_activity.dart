import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateRectangleActivity extends DragActivity {
  CreateRectangleActivity({required this.editor});

  final Editor editor;
  late final RectangleStatement rectangle;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final localPosition = editor.globalToScene(details.globalPosition);
    rectangle = RectangleStatement(
      size: .zero,
      transform: .translation2(localPosition),
    );

    editor.edit((txn) => txn.insert(rectangle));
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final a = editor.globalToScene(startDetails.globalPosition);
    final b = editor.globalToScene(details.globalPosition);
    final aabb = Aabb2.bbox2(a, b);

    final newRectangle = rectangle.copyWith(
      transform: .translation2(aabb.min),
      size: .fixed(aabb.width, aabb.height),
    );

    editor.edit((txn) => txn.replace(rectangle.id, [newRectangle]));
  }
}
