part of '../generator.dart';

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

  static double _unit(int seed, U64 id, int component) =>
      Mix64.hash(Mix64.mixWithKey(Mix64.mixWithKey(id, seed), component)) / 0x40000000;
}
