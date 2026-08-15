import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateRectangleActivity extends DragActivity {
  CreateRectangleActivity({required this.editor});

  final Editor editor;
  late final RectangleObject rectangle;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    rectangle = RectangleObject(size: .zero);

    final hitTest = editor.hitTestScene(details.globalPosition.vec2);
    for (final hit in hitTest.nodes) {
      final object = hit.node;
      if (object is MultiChildSceneObject) {
        final position = hit.localPosition;
        rectangle.transform = .translationValues(position.x, position.y, 0.0);
        object.addChild(rectangle);
        break;
      }
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final a = editor.globalToLocal(rectangle.parent!, startDetails.globalPosition.vec2);
    final b = editor.globalToLocal(rectangle.parent!, details.globalPosition.vec2);
    final aabb = a.aabb2(b);

    rectangle.transform = .translationValues(aabb.min.x, aabb.min.y, 0.0);
    rectangle.size = .fixed(aabb.width, aabb.height);
  }
}
