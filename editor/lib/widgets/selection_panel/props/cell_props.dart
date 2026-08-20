part of 'prop.dart';

List<PropSource> frameProps(Scene scene, FrameRef ref) {
  return [
    PropType.transform.transforming(
      (txn) => TransformSession.of(scene, [ref], transaction: txn),
      (scene) => .from(scene.bundle.frameTransform(scene.handleOf(ref)!)),
      (session, current, value) => value.execute(session, current),
    ),
  ];
}

List<PropSource> vertexProps(Scene scene, VertexRef ref) {
  return [
    PropType.position.transforming(
      (txn) => TransformSession.of(scene, [ref], transaction: txn),
      (scene) => .new(scene.bundle.vertexPosition(scene.handleOf(ref)!)),
      (session, current, value) => session.setTranslation(value.apply(current).value),
    ),
  ];
}

List<PropSource> edgeProps(Scene scene, EdgeRef ref) {
  return [
    PropType.edgeStyle.delegating(
      (scene) => .from(scene.styleOf(ref)!),
      (txn, value) => txn.decorate(ref, value),
    ),
  ];
}

List<PropSource> faceProps(Scene scene, FaceRef ref) {
  return [
    PropType.faceStyle.delegating(
      (scene) => .from(scene.styleOf(ref)!),
      (txn, value) => txn.decorate(ref, value),
    ),
  ];
}
