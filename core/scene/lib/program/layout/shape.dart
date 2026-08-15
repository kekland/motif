part of '../program.dart';

extension type CornerRadius._((double x, double y) _) {
  const CornerRadius(double x, double y) : _ = (x, y);
  const CornerRadius.circular(double radius) : this(radius, radius);
  static const zero = CornerRadius(0, 0);

  double get x => _.$1;
  double get y => _.$2;

  bool get isZero => x <= 0 || y <= 0;
  CornerRadius scale(double f) => CornerRadius(x * f, y * f);

  Vec2 get vec => .new(x, y);
}

final class ShapeTopology {
  final vertices = <(Symbol key, Vec2 position)>[];
  final edges = <(Symbol key, Symbol start, Symbol end, Vec2? t0, Vec2? t1)>[];
  final boundary = <Symbol>[];
  final aliases = <Symbol, Symbol>{};

  Symbol resolve(Symbol key) {
    var current = key;
    var hops = 0;
    while (aliases.containsKey(current)) {
      current = aliases[current]!;
      assert(hops++ < 16, 'alias loop was detected at ${key.name}');
    }
    return current;
  }
}

sealed class ObjectShape {
  const ObjectShape();

  static const default_ = ObjectShape.rectangle();

  const factory ObjectShape.rectangle({
    CornerRadius topLeftRadius,
    CornerRadius topRightRadius,
    CornerRadius bottomLeftRadius,
    CornerRadius bottomRightRadius,
  }) = RectangleObjectShape;

  ShapeTopology produceTopology(Size2 size);
}

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
}
