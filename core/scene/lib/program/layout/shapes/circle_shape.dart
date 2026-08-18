part of '../../program.dart';

final class CircleObjectShape extends ObjectShape {
  const CircleObjectShape();

  static const kappa = RectangleObjectShape.kappa;

  @override
  ShapeTopology produceTopology(Size2 size) {
    final w = size.width, h = size.height;
    final rx = w / 2, ry = h / 2;
    final kx = rx * kappa, ky = ry * kappa;

    final out = ShapeTopology();

    out.vertices.addAll([
      (#t, Vec2(rx, 0)),
      (#r, Vec2(w, ry)),
      (#b, Vec2(rx, h)),
      (#l, Vec2(0, ry)),
    ]);

    out.edges.addAll([
      (#tr, #t, #r, .new(kx, 0), .new(0, -ky)),
      (#rb, #r, #b, .new(0, ky), .new(kx, 0)),
      (#bl, #b, #l, .new(-kx, 0), .new(0, ky)),
      (#lt, #l, #t, .new(0, -ky), .new(-kx, 0)),
    ]);

    out.boundary.addAll(const [#tr, #rb, #bl, #lt]);
    return out;
  }

  @override
  Iterable<Ref> produceRefs(StatementId id) => [
    VertexRef(id, #t),
    VertexRef(id, #r),
    VertexRef(id, #b),
    VertexRef(id, #l),
    EdgeRef(id, #tr),
    EdgeRef(id, #rb),
    EdgeRef(id, #bl),
    EdgeRef(id, #lt),
  ];
}
