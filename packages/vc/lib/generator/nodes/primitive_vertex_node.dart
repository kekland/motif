part of '../blueprint.dart';

class PrimitiveVertexNode extends PrimitiveVertexNodeBase {
  @override
  void execute() {
    final vertexOutput = o.vertex;

    vertexOutput.value = .constant(
      PrimitiveBundle(
        cells: [VertexPrimitive(position: .zero())],
      ),
    );
  }
}
