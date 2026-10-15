part of '../generator.dart';

final class BoundingBoxNode extends BoundingBoxNodeBase {
  BoundingBoxNode({NodeId? id, super.slice}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slice = execution.resolve(i.slice);
    final evaluation = slice.map((s) => execution.evaluate(s));

    final bbox = evaluation.map((e) => e.bundle.query.hullAll(space: .root));

    execution.set(o.bbox, bbox);
    execution.set(o.min, bbox.map((b) => b.min));
    execution.set(o.max, bbox.map((b) => b.max));
    execution.set(o.size, bbox.map((b) => b.size));
    execution.set(o.center, bbox.map((b) => b.center));
  }
}
