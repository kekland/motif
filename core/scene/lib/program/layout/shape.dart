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
  Iterable<Ref> produceRefs(StatementId id);
}
