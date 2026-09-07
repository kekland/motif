part of '../../program.dart';

final class PolygonObjectShape extends ObjectShape {
  const PolygonObjectShape({required this.sides});
  static const default_ = PolygonObjectShape(sides: 3);

  final int sides;

  @override
  int get faceTag => 1 + 2 * sides;

  @override
  void performProduce(ShapeBuilder builder, Size2 size, FrameRef frame) {
    final u = <Vec2>[];
    for (var i =0 ; i < sides; i++) {
      final a = -math.pi / 2 + 2 * math.pi * i / sides;
      u.add(Vec2(math.cos(a), math.sin(a)));
    }

    final hull = Aabb2.invertedInfinity();
    for (final p in u) hull.hullPoint(p);

    final sx = size.width / hull.width, sy = size.height / hull.height;

    final v = <VertexRef>[];
    for (final p in u) {
      final vtx = builder.vertex(Vec2((p.x - hull.left) * sx, (p.y - hull.top) * sy), parent: frame);
      v.add(vtx);
    }

    final e = <EdgeRef>[];
    for (var i = 0; i < v.length; i++) {
      final edge = builder.edge(v[i], v[(i + 1) % v.length], parent: frame);
      e.add(edge);
    }

    builder.face(e, parent: frame);
  }
}
