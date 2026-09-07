part of '../../program.dart';

final class RectangleObjectShape extends ObjectShape {
  const RectangleObjectShape();
  static const default_ = RectangleObjectShape();

  @override
  int get faceTag => 9;

  @override
  void performProduce(ShapeBuilder builder, Size2 size, FrameRef frame) {
    final corners = [
      Vec2.zero(),
      Vec2(size.width, 0),
      Vec2(size.width, size.height),
      Vec2(0, size.height),
    ];

    final v = [
      for (final c in corners) builder.vertex(c, parent: frame),
    ];

    final e = [
      for (var i = 0; i < v.length; i++) builder.edge(v[i], v[(i + 1) % v.length], parent: frame),
    ];

    builder.face(e, parent: frame);
  }
}
