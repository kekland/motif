part of '../generator.dart';

final class MathNode extends MathNodeBase {
  new({NodeId? id, super.a, super.b, super.operator}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final a = execution.resolve(i.a);
    final b = execution.resolve(i.b);

    execution.set(o.value, switch (operator) {
      .add => .zip2(execution.scalar, a, b, (_, a, b) => a + b),
      .subtract => .zip2(execution.scalar, a, b, (_, a, b) => a - b),
      .multiply => .zip2(execution.scalar, a, b, (_, a, b) => a * b),
      .divide => .zip2(execution.scalar, a, b, (_, a, b) => a / b),
    });
  }
}

final class VectorMathNode extends VectorMathNodeBase {
  new({NodeId? id, super.a, super.b, super.operator}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final a = execution.resolve(i.a);
    final b = execution.resolve(i.b);

    execution.set(o.value, switch (operator) {
      .add => .zip2(execution.scalar, a, b, (_, a, b) => a + b),
      .subtract => .zip2(execution.scalar, a, b, (_, a, b) => a - b),
    });
  }
}

final class TrigMathNode extends TrigMathNodeBase {
  new({NodeId? id, super.input, super.operator}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final input = execution.resolve(i.input);

    execution.set(o.value, switch (operator) {
      .sin => input.map((v) => math.sin(v)),
      .cos => input.map((v) => math.cos(v)),
      .tan => input.map((v) => math.tan(v)),
      .arcsin => input.map((v) => math.asin(v)),
      .arccos => input.map((v) => math.acos(v)),
      .arctan => input.map((v) => math.atan(v)),
    });
  }
}

final class ExpressionNode extends ExpressionNodeBase {
  new({NodeId? id, super.expression}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final args = execution.resolve(i.args);
    final expression = parseExpression(execution.evaluateScalar(i.expression));

    execution.set(
      o.value,
      .zip1(
        execution.scalar,
        args,
        (context, args) {
          return evaluateExpression(expression, args: args);
        },
      ),
    );
  }
}

final class MathConstantNode extends MathConstantNodeBase {
  new({NodeId? id, super.constant}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.set(
      o.value,
      .constant(switch (constant) {
        .pi => math.pi,
        .e => math.e,
      }),
    );
  }
}

final class MathRoundNode extends MathRoundNodeBase {
  new({NodeId? id, super.value, super.mode}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);

    execution.set(o.value, switch (mode) {
      .ceil => value.map((v) => v.ceil()),
      .floor => value.map((v) => v.floor()),
      .round => value.map((v) => v.round()),
    });
  }
}

final class CombineXYNode extends CombineXYNodeBase {
  CombineXYNode({NodeId? id, super.x, super.y}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final x = execution.resolve(i.x);
    final y = execution.resolve(i.y);
    execution.set(o.value, .zip2(execution.scalar, x, y, (_, x, y) => Vec2(x, y)));
  }
}

final class SeparateXYNode extends SeparateXYNodeBase {
  SeparateXYNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.x, value.map((v) => v.x));
    execution.set(o.y, value.map((v) => v.y));
  }
}

final class PolarNode extends PolarNodeBase {
  PolarNode({NodeId? id, super.radius, super.angle}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final radius = execution.resolve(i.radius);
    final angle = execution.resolve(i.angle);
    execution.set(
      o.value,
      .zip2(execution.scalar, radius, angle, (_, r, a) => Vec2(r * math.cos(a), r * math.sin(a))),
    );
  }
}

final class RotateVectorNode extends RotateVectorNodeBase {
  RotateVectorNode({NodeId? id, super.vector, super.angle, super.pivot}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final vector = execution.resolve(i.vector);
    final angle = execution.resolve(i.angle);
    final pivot = execution.resolve(i.pivot);

    execution.set(
      o.value,
      .zip3(execution.scalar, vector, angle, pivot, (_, v, a, p) {
        final s = math.sin(a);
        final c = math.cos(a);
        final x = v.x - p.x;
        final y = v.y - p.y;
        return Vec2(c * x - s * y + p.x, s * x + c * y + p.y);
      }),
    );
  }
}

final class AbsNode extends AbsNodeBase {
  AbsNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v.abs()));
  }
}

final class AbsVectorNode extends AbsVectorNodeBase {
  AbsVectorNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v.abs()));
  }
}

final class WrapNode extends WrapNodeBase {
  WrapNode({NodeId? id, super.value, super.min, super.max}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    final min = execution.evaluateScalar(i.min);
    final max = execution.evaluateScalar(i.max);

    execution.set(
      o.value,
      .zip1(
        execution.scalar,
        value,
        (_, v) => _wrap(v, min, max),
      ),
    );
  }
}

final class WrapVectorNode extends WrapVectorNodeBase {
  WrapVectorNode({NodeId? id, super.value, super.min, super.max}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    final min = execution.evaluateScalar(i.min);
    final max = execution.evaluateScalar(i.max);

    execution.set(
      o.value,
      .zip1(
        execution.scalar,
        value,
        (_, v) => Vec2(
          _wrap(v.x, min.x, max.x),
          _wrap(v.y, min.y, max.y),
        ),
      ),
    );
  }
}

double _wrap(double value, double min, double max) {
  final range = max - min;
  return range != 0 ? value - range * ((value - min) / range).floor() : min;
}

final class SignNode extends SignNodeBase {
  SignNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v.sign));
  }
}

final class SignVectorNode extends SignVectorNodeBase {
  SignVectorNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => Vec2(v.x.sign, v.y.sign)));
  }
}

final class RandomFloatNode extends RandomFloatNodeBase {
  RandomFloatNode({NodeId? id, super.seed, super.min, super.max}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final seed = execution.evaluateScalar(i.seed);
    final min = execution.evaluateScalar(i.min);
    final max = execution.evaluateScalar(i.max);

    execution.set(
      o.value,
      .dynamic((context) {
        final id = context.id ?? .zero;
        return lerp(min, max, _unit(seed, id, 0));
      }),
    );
  }
}

final class RandomVectorNode extends RandomVectorNodeBase {
  RandomVectorNode({NodeId? id, super.seed, super.min, super.max}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final seed = execution.evaluateScalar(i.seed);
    final min = execution.resolve(i.min);
    final max = execution.resolve(i.max);

    execution.set(
      o.value,
      .dynamic((context) {
        final lo = min.evaluate(context), hi = max.evaluate(context);
        final id = context.id ?? .zero;

        return Vec2(
          lerp(lo.x, hi.x, _unit(seed, id, 0)),
          lerp(lo.y, hi.y, _unit(seed, id, 1)),
        );
      }),
    );
  }
}

double _unit(int seed, U64 id, int component) =>
    Mix64.hash(Mix64.mixWithKey(Mix64.mixWithKey(id, seed), component)) / 0x40000000;

final class CompareNode extends CompareNodeBase {
  CompareNode({NodeId? id, super.a, super.b, super.type, super.epsilon}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final a = execution.resolve(i.a);
    final b = execution.resolve(i.b);
    final epsilon = execution.evaluateScalar(i.epsilon);

    execution.set(o.result, switch (type) {
      .equal => .zip2(execution.scalar, a, b, (_, a, b) => (a - b).abs() <= epsilon),
      .notEqual => .zip2(execution.scalar, a, b, (_, a, b) => (a - b).abs() > epsilon),
      .less => .zip2(execution.scalar, a, b, (_, a, b) => a < b),
      .lessOrEqual => .zip2(execution.scalar, a, b, (_, a, b) => a <= b),
      .greater => .zip2(execution.scalar, a, b, (_, a, b) => a > b),
      .greaterOrEqual => .zip2(execution.scalar, a, b, (_, a, b) => a >= b),
    });
  }
}

final class BooleanToFloatNode extends BooleanToFloatNodeBase {
  BooleanToFloatNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v ? 1.0 : 0.0));
  }
}

final class MapRangeNode extends MapRangeNodeBase {
  MapRangeNode({
    NodeId? id,
    super.value,
    super.fromMin,
    super.fromMax,
    super.outMin,
    super.outMax,
    super.clamp,
    super.interpolation,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    final fromMin = execution.resolve(i.fromMin);
    final fromMax = execution.resolve(i.fromMax);
    final outMin = execution.resolve(i.outMin);
    final outMax = execution.resolve(i.outMax);
    final clamp = execution.evaluateScalar(i.clamp);

    execution.set(
      o.value,
      .zip5(execution.scalar, value, fromMin, fromMax, outMin, outMax, (_, v, a, b, lo, hi) {
        final range = b - a;
        var t = range == 0.0 ? 0.0 : (v - a) / range;
        if (clamp) t = t.clamp(0.0, 1.0);
        t = switch (interpolation) {
          .linear => t,
          .step => t < 0.5 ? 0.0 : 1.0,
          .smoothstep => _smoothstep(t),
        };

        return lo + t * (hi - lo);
      }),
    );
  }
}

double _smoothstep(double t) {
  final x = t.clamp(0.0, 1.0);
  return x * x * (3.0 - 2.0 * x);
}

final class VectorMagnitudeNode extends VectorMagnitudeNodeBase {
  VectorMagnitudeNode({NodeId? id, super.vector}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final vector = execution.resolve(i.vector);
    execution.set(o.value, vector.map((v) => v.length));
  }
}

final class Deg2RadNode extends Deg2RadNodeBase {
  Deg2RadNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v * deg2Rad));
  }
}

final class Rad2DegNode extends Rad2DegNodeBase {
  Rad2DegNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final value = execution.resolve(i.value);
    execution.set(o.value, value.map((v) => v * rad2Deg));
  }
}
