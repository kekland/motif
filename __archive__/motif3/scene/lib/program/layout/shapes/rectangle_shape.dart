part of '../../program.dart';

final class RectangleObjectShape extends ObjectShape {
  const RectangleObjectShape({
    this.topLeftRadius = .zero,
    this.topRightRadius = .zero,
    this.bottomLeftRadius = .zero,
    this.bottomRightRadius = .zero,
  });

  RectangleObjectShape.circular(double radius)
    : this(
        topLeftRadius: .circular(radius),
        topRightRadius: .circular(radius),
        bottomLeftRadius: .circular(radius),
        bottomRightRadius: .circular(radius),
      );

  final CornerRadius topLeftRadius;
  final CornerRadius topRightRadius;
  final CornerRadius bottomLeftRadius;
  final CornerRadius bottomRightRadius;

  static const kappa = 0.5522847498307936;

  @override
  ShapeTopology produceTopology(Size2 size) {
    final w = size.width, h = size.height;
    final f = _overlapFactor(w, h);
    final out = ShapeTopology();

    final corners = [
      (#tl, Vec2(0, 0), Vec2(0, -1), Vec2(1, 0), topLeftRadius.scale(f)),
      (#tr, Vec2(w, 0), Vec2(1, 0), Vec2(0, 1), topRightRadius.scale(f)),
      (#br, Vec2(w, h), Vec2(0, 1), Vec2(-1, 0), bottomRightRadius.scale(f)),
      (#bl, Vec2(0, h), Vec2(-1, 0), Vec2(0, -1), bottomLeftRadius.scale(f)),
    ];

    final sides = const [#top, #right, #bottom, #left];

    for (var i = 0; i < 4; i++) {
      final (key, p, inDir, outDir, r) = corners[i];
      final a = key / 'a', b = key / 'b', arc = key / 'arc';

      if (r.isZero) {
        out.vertices.add((key, p));
        out.aliases[a] = key;
        out.aliases[b] = key;
        out.edges.add((arc, key, key, null, null));
      } else {
        final aOffset = inDir.multiply(-r.vec);
        final bOffset = outDir.multiply(r.vec);
        out.vertices.add((a, p + aOffset));
        out.vertices.add((b, p + bOffset));
        out.aliases[key] = a;
        out.edges.add((arc, a, b, aOffset.scale(-kappa), bOffset.scale(-kappa)));
        out.boundary.add(arc);
      }

      final next = corners[(i + 1) % 4].$1;
      out.edges.add((sides[i], b, next / 'a', null, null));
      out.boundary.add(sides[i]);
    }

    return out;
  }

  double _overlapFactor(double w, double h) {
    var f = 1.0;
    void fit(double sum, double side) {
      if (sum > side && sum > 0) f = math.min(f, side / sum);
    }

    fit(topLeftRadius.x + topRightRadius.x, w);
    fit(bottomLeftRadius.x + bottomRightRadius.x, w);
    fit(topLeftRadius.y + bottomLeftRadius.y, h);
    fit(topRightRadius.y + bottomRightRadius.y, h);
    return f;
  }

  @override
  Iterable<Ref> produceRefs(StatementId id) sync* {
    for (final base in const [#tl, #tr, #br, #bl]) {
      yield .vertex(id, base);
      yield .vertex(id, base / 'a');
      yield .vertex(id, base / 'b');
      yield .edge(id, base / 'arc');
    }

    yield .edge(id, #top);
    yield .edge(id, #right);
    yield .edge(id, #bottom);
    yield .edge(id, #left);
  }
}
