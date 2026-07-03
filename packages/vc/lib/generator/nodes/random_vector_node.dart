part of '../blueprint.dart';

class RandomVectorNode extends RandomVectorNodeBase {
  @override
  void execute() {
    final vectorOutput = o.vector;

    vectorOutput.value = .dynamic((ctx) {
      final context = ctx as FilledEvaluationContext;
      final rng = Random(context.seed);
      return Vector2.random(rng) * 20.0;
    });
  }
}
