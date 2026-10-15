part of '../generator.dart';

final class VertexNode extends VertexNodeBase {
  VertexNode({NodeId? id, super.position}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final position = execution.resolve(i.position);

    execution.set(
      o.slice,
      .zip1(
        execution.scalar,
        position,
        (context, p) => ProgramSlice.single(
          VertexStatement(p, id: context.deriveId(this)),
        ),
      ),
    );
  }
}

final class RectangleNode extends RectangleNodeBase {
  RectangleNode({NodeId? id, super.center, super.size}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final center = execution.resolve(i.center);
    final size = execution.resolve(i.size);

    execution.set(
      o.slice,
      .zip2(
        execution.scalar,
        center,
        size,
        (context, c, s) => ProgramSlice.single(
          RectangleStatement(
            id: context.deriveId(this),
            transform: .translation2(c - s / 2),
            size: .fixed(s.x, s.y),
          ),
        ),
      ),
    );
  }
}
