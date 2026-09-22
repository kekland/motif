part of '../../program.dart';

final class EllipseObjectShape extends ObjectShape {
  const EllipseObjectShape();
  static const default_ = EllipseObjectShape();

  @override
  int get frameTag => 0;

  @override
  int get faceTag => 9;

  @override
  void performProduce(ShapeBuilder builder, Size2 size, FrameRef frame) {
    const k = 0.552284749831;
    final rx = size.width / 2, ry = size.height / 2;

    final top = builder.vertex(Vec2(rx, 0), parent: frame);
    final right = builder.vertex(Vec2(size.width, ry), parent: frame);
    final bottom = builder.vertex(Vec2(rx, size.height), parent: frame);
    final left = builder.vertex(Vec2(0, ry), parent: frame);

    final krx = k * rx;
    final kry = k * ry;

    final e = [
      builder.edge(top, right, startTangent: Vec2(krx, 0), endTangent: Vec2(0, -kry), parent: frame),
      builder.edge(right, bottom, startTangent: Vec2(0, kry), endTangent: Vec2(krx, 0), parent: frame),
      builder.edge(bottom, left, startTangent: Vec2(-krx, 0), endTangent: Vec2(0, kry), parent: frame),
      builder.edge(left, top, startTangent: Vec2(0, -kry), endTangent: Vec2(-krx, 0), parent: frame),
    ];

    builder.face(e, parent: frame);
  }
}
