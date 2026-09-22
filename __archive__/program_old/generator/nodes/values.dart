part of '../generator.dart';

final class NumberNode extends NumberNodeBase {
  NumberNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.set(o.value, execution.resolve(i.value));
  }
}

final class VectorNode extends VectorNodeBase {
  VectorNode({NodeId? id, super.value}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.set(o.value, execution.resolve(i.value));
  }
}

final class IndexNode extends IndexNodeBase {
  IndexNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.set(o.value, .dynamic((context) => context.index));
  }
}

final class ScaleVectorNode extends ScaleVectorNodeBase {
  ScaleVectorNode({NodeId? id, super.vector, super.factor}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final vector = execution.resolve(i.vector);
    final factor = execution.resolve(i.factor);
    execution.set(o.value, .zip2(vector, factor, (v, f) => v * f));
  }
}

// final class RangeNode extends RangeNodeBase {
//   RangeNode({NodeId? id, super.start, super.count, super.step}) : super(id: id ?? .generate());

//   @override
//   void execute(BlueprintExecution context) {
//     final start = context.resolve(i.start).evaluate(context);
//     final count = context.resolve(i.count).evaluate(context);
//     final step = context.resolve(i.step).evaluate(context);
//     final values = List.generate(count, (index) => start + index * step);
//     context.set(o.values, .constant(values));
//   }
// }

// final class VectorGridNode extends VectorGridNodeBase {
//   VectorGridNode({NodeId? id, super.start, super.x, super.y, super.offset}) : super(id: id ?? .generate());

//   @override
//   void execute(BlueprintExecution context) {
//     final start = context.resolve(i.start).evaluate(context);
//     final x = context.resolve(i.x).evaluate(context);
//     final y = context.resolve(i.y).evaluate(context);
//     final offset = context.resolve(i.offset).evaluate(context);

//     final vectors = <Vec2>[];
//     for (var j = 0; j < y; j++) {
//       for (var i = 0; i < x; i++) {
//         vectors.add(start + Vec2(offset.x * i, offset.y * j));
//       }
//     }

//     context.set(o.vectors, .constant(vectors));
//   }
// }
