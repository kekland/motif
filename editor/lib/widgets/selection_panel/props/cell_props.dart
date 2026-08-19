part of 'prop.dart';

List<Prop> frameProps(Scene scene, FrameRef ref) {
  return [
    TransformProp(
      (txn) => TransformSession.of(scene, [ref], transaction: txn),
      (scene) => scene.bundle.frameTransform(scene.handleOf(ref)),
    ),
  ];
}

List<Prop> vertexProps(Scene scene, VertexRef ref) {
  return [
    PositionProp(
      (txn) => TransformSession.of(scene, [ref], transaction: txn),
      (scene) => .from(scene.bundle.vertexPosition(scene.handleOf(ref))),
    ),
  ];
}

List<Prop> edgeProps(Scene scene, EdgeRef ref) {
  return [
    EdgeStyleProp(
      (scene) => .from(scene.styleOf(ref)!),
      (txn, value) => txn.decorate(ref, value),
    ),
  ];
}

List<Prop> faceProps(Scene scene, FaceRef ref) {
  return [
    FaceStyleProp(
      (scene) => .from(scene.styleOf(ref)!),
      (txn, value) => txn.decorate(ref, value),
    ),
  ];
}
