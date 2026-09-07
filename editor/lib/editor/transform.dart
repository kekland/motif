part of '../editor.dart';

extension EditorTransform on Editor {
  Vec2 globalToScene(Offset globalPosition) {
    return renderScene.globalToLocal(globalPosition).vec2;
  }

  Offset sceneToGlobal(Vec2 scenePosition) {
    return renderScene.localToGlobal(scenePosition.offset);
  }

  Vec2 globalToLocal(CellRef<FrameHandle>? ref, Offset globalPosition) {
    if (ref == null) return globalToScene(globalPosition);

    final frame = handleOf(ref)!;
    final worldTransform = bundle.frameTransform(frame, space: .root);
    final inverse = worldTransform..invert();
    return inverse.transform2(globalToScene(globalPosition));
  }
}
