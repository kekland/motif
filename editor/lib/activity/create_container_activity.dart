import 'package:editor/imports.dart';
import 'package:flutter/gestures.dart';

class CreateContainerActivity extends DragActivity {
  CreateContainerActivity({required this.editor});

  final Editor editor;
  late final ContainerObject container;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);

    container = ContainerObject(size: .zero);

    final hitTest = editor.hitTestScene(details.globalPosition.vec2);
    for (final hit in hitTest.nodes) {
      final object = hit.node;
      if (object is MultiChildSceneObject) {
        final position = hit.localPosition;
        container.transform = .translationValues(position.x, position.y, 0.0);
        object.addChild(container);
        break;
      }

      // if (object is Vertex) {
      //   final position = object.position;
      //   container.transform = .translationValues(position.x, position.y, 0.0);
      //   object.parent!.addChild(container);
      //   if (!object.isOwned) object.owner = container;
      // }
    }
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);

    final a = editor.globalToLocal(container.parent!, startDetails.globalPosition.vec2);
    final b = editor.globalToLocal(container.parent!, details.globalPosition.vec2);
    final aabb = a.aabb2(b);

    container.transform = .translationValues(aabb.min.x, aabb.min.y, 0.0);
    container.size = .fixed(aabb.width, aabb.height);
  }
}
