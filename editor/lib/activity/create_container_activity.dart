import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateContainerActivity extends DragActivity {
  CreateContainerActivity({required this.editor});

  final Editor editor;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    final container = ContainerObject(size: .fixed(10.0, 10.0));

    final hitTest = editor.hitTestScene(details.globalPosition);
    for (final hit in hitTest.objects) {
      final object = hit.node;
      if (object is MultiChildSceneObject) {
        final position = hit.localPosition;
        container.transform = .translationValues(position.dx, position.dy, 0.0);
        object.addChild(container);
        break;
      }
    }
  }
}
