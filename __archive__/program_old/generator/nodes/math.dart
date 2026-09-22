part of '../generator.dart';

final class PolarNode extends PolarNodeBase {
  PolarNode({NodeId? id, super.angle, super.radius}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final angle = execution.resolve(i.angle);
    final radius = execution.resolve(i.radius);

    execution.set(
      o.value,
      .zip2(angle, radius, (a, r) => Vec2.rotation(a) * r),
    );
  }
}

final class PiNode extends PiNodeBase {
  PiNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.setConstant(o.value, math.pi);
  }
}

final class DivideNode extends DivideNodeBase {
  DivideNode({NodeId? id, super.numerator, super.denominator}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final numerator = execution.resolve(i.numerator);
    final denominator = execution.resolve(i.denominator);
    execution.set(o.value, .zip2(numerator, denominator, (n, d) => n / d));
  }
}
