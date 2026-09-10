part of '../generator.dart';

final class VertexNode extends VertexNodeBase {
  VertexNode({
    NodeId? id,
    super.position,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution context) {
    final position = context.resolve(i.position).evaluate(context);

    final out = VertexStatement(
      position,
      id: context.derive(this, 0),
    );

    context.set(o.slice, .constant(ProgramSlice(statements: [out])));
  }
}
