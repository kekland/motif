part of '../generator.dart';

final class VerticesNode extends VerticesNodeBase {
  VerticesNode({NodeId? id, super.count, super.position}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final count = execution.evaluateScalar(i.count);
    final position = execution.resolve(i.position);

    final out = ProgramSlice.empty();
    for (final context in execution.freshContext(this, count: count)) {
      out.statements.add(
        VertexStatement(
          position.evaluate(context),
          id: execution.derive(this, context),
        ),
      );
    }

    execution.setConstant(o.slice, out);
  }
}

final class ConnectVerticesNode extends ConnectVerticesNodeBase {
  ConnectVerticesNode({NodeId? id, super.slice, super.closed}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final input = execution.evaluateScalar(i.slice);
    final closed = execution.evaluateScalar(i.closed);

    final vertices = input.statements.whereType<VertexStatement>().toList();
    if (vertices.length < 2) {
      execution.setConstant(o.slice, ProgramSlice.empty());
      return;
    }

    final out = ProgramSlice.empty();
    final last = closed ? vertices.length : vertices.length - 1;

    for (var k = 0; k < last; k++) {
      final a = vertices[k];
      final b = vertices[(k + 1) % vertices.length];
      out.statements.add(EdgeStatement(a.ref.selector(), b.ref.selector(), id: execution.deriveFor(this, a)));
    }

    execution.setConstant(o.slice, input.extend(out));
  }
}

final class FaceNode extends FaceNodeBase {
  FaceNode({NodeId? id, super.slice}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final input = execution.evaluateScalar(i.slice);

    final edges = input.statements.whereType<EdgeStatement>().toList();
    if (edges.length < 2) {
      execution.setConstant(o.slice, input);
      return;
    }

    final face = FaceStatement(
      ChainSelector([for (final e in edges) e.ref]),
      id: execution.deriveFor(this, edges.first),
    );

    execution.setConstant(o.slice, input.extend(.new(statements: [face])));
  }
}
