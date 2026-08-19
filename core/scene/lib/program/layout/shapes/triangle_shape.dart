part of '../../program.dart';

final class TriangleObjectShape extends ObjectShape {
  const TriangleObjectShape();

  @override
  ShapeTopology produceTopology(Size2 size) {
    final w = size.width, h = size.height;
    final out = ShapeTopology();

    out.vertices.addAll([
      (#top, .new(w / 2, 0)),
      (#br, .new(w, h)),
      (#bl, .new(0, h)),
    ]);

    out.edges.addAll([
      (#right, #top, #br, null, null),
      (#bottom, #br, #bl, null, null),
      (#left, #bl, #top, null, null),
    ]);

    out.boundary.addAll(const [#right, #bottom, #left]);
    return out;
  }

  @override
  Iterable<Ref> produceRefs(StatementId id) => [
    .vertex(id, #top),
    .vertex(id, #br),
    .vertex(id, #bl),
    .edge(id, #right),
    .edge(id, #bottom),
    .edge(id, #left),
  ];
}
