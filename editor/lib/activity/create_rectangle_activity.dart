import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateRectangleActivity extends DragActivity {
  CreateRectangleActivity({required this.editor});

  final Editor editor;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final rectangle = RectangleObject(size: .fixed(10.0, 10.0));

    final hitTest = editor.hitTestScene(details.globalPosition.vec2);
    for (final hit in hitTest.objects) {
      final object = hit.node;
      if (object is MultiChildSceneObject) {
        final position = hit.localPosition;
        rectangle.transform = .translationValues(position.x, position.y, 0.0);
        object.addChild(rectangle);
        break;
      }
    }
  }
}
