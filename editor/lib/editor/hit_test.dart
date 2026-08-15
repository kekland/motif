part of '../editor.dart';

extension EditorHitTest on Editor {
  SceneHitResult hitTest(Offset globalPosition) {
    final transform = renderScene.getTransformTo(null);
    final scale = transform.getMaxScaleOnAxis();
    return scene.query.hitTest(globalToScene(globalPosition), tolerance: 8.0 / scale);
  }

  SceneHitResult hitTestScene(Vec2 scenePosition) {
    final transform = renderScene.getTransformTo(null);
    final scale = transform.getMaxScaleOnAxis();
    return scene.query.hitTest(scenePosition, tolerance: 8.0 / scale);
  }

  SceneHitResult hitTestRect(Rect globalRect, {HitTestRectMode mode = .normal}) {
    final transform = renderScene.getTransformTo(null);
    final rect = MatrixUtils.inverseTransformRect(transform, globalRect);

    return scene.query.hitTestRect(
      Aabb2(rect.left, rect.top, rect.right, rect.bottom),
      mode: mode,
    );
  }

  SceneHitResult hitTestSceneRect(Aabb2 rect, {HitTestRectMode mode = .normal}) {
    return scene.query.hitTestRect(rect, mode: mode);
  }
}
