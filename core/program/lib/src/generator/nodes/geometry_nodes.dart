part of '../generator.dart';

final class ArrayNode extends ArrayNodeBase {
  ArrayNode({
    NodeId? id,
    super.count,
    super.offset,
    super.slice,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slice = execution.resolve(i.slice);
    final offset = execution.resolve(i.offset);
    final count = execution.resolve(i.count);

    ProgramSlice build(FieldContext context) {
      final c = count.evaluate(context);
      final xCount = math.max(0, c.x.floor());
      final yCount = math.max(0, c.y.floor());
      final out = ProgramSlice.empty();

      var index = 0;
      for (var x = 0; x < xCount; x++) {
        for (var y = 0; y < yCount; y++) {
          final childCtx = context.extend(this, index);
          final s = slice.evaluate(childCtx);
          final o = offset.evaluate(childCtx);

          final copy = s.materialize((_, st) => execution.deriveFor(this, st, index: index));
          final inside = {for (final st in copy.statements) st.id};
          final shift = Vec2(o.x * x, o.y * y);
          for (final st in copy.statements) {
            out.statements.add(_shifted(st, shift, inside));
          }
          index++;
        }
      }
      return out;
    }

    if (count is ConstantField && slice is ConstantField && offset is ConstantField) {
      execution.set(o.slice, .constant(build(execution.scalar)));
    } else {
      execution.set(o.slice, .dynamic(build));
    }
  }

  static Statement _shifted(Statement s, Vec2 d, Set<StatementId> inside) {
    if (s is! PlacedStatement || inside.contains(s.parent?.ref.statementId)) return s;
    return switch (s) {
      VertexStatement v => v.copyWith(position: Vec2(v.position.x + d.x, v.position.y + d.y)),
      // FrameStatement f => f.copyWith(transform: f.transform.translated(d.x, d.y)),
      ShapeStatement sh => sh.copyWith(transform: sh.transform.translated(d.x, d.y)),
      _ => s,
    };
  }
}

final class ConnectVerticesNode extends ConnectVerticesNodeBase {
  ConnectVerticesNode({
    NodeId? id,
    super.closed,
    super.slice,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slice = execution.resolve(i.slice);
    final closed = execution.evaluateScalar(i.closed);

    ProgramSlice build(FieldContext context) {
      final s = slice.evaluate(context);
      final vertices = s.statements.whereType<VertexStatement>().toList();
      if (vertices.length < 2) return s;

      final edges = <EdgeStatement>[];
      final last = closed ? vertices.length : vertices.length - 1;

      for (var k = 0; k < last; k++) {
        final a = vertices[k];
        final b = vertices[(k + 1) % vertices.length];
        edges.add(
          EdgeStatement(
            a.ref.selector(),
            b.ref.selector(),
            id: execution.deriveFor(this, a),
          ),
        );
      }

      return s.extend(.new(statements: edges));
    }

    if (slice is ConstantField) {
      execution.set(o.slice, .constant(build(execution.scalar)));
    } else {
      execution.set(o.slice, .dynamic(build));
    }
  }
}

final class MakeFaceNode extends MakeFaceNodeBase {
  MakeFaceNode({NodeId? id, super.slice}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slice = execution.resolve(i.slice);

    ProgramSlice build(FieldContext context) {
      final s = slice.evaluate(context);
      final edges = s.statements.whereType<EdgeStatement>().toList();
      if (edges.length < 2) return s;

      final face = FaceStatement(
        ChainSelector([for (final e in edges) e.ref]),
        id: execution.deriveFor(this, edges.first),
      );

      return s.extend(.new(statements: [face]));
    }

    if (slice is ConstantField) {
      execution.set(o.slice, .constant(build(execution.scalar)));
    } else {
      execution.set(o.slice, .dynamic(build));
    }
  }
}

final class TransformNode extends TransformNodeBase {
  TransformNode({
    NodeId? id,
    super.slice,
    super.translation,
    super.scale,
    super.rotation,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slice = execution.resolve(i.slice);
    final translation = execution.resolve(i.translation);
    final scale = execution.resolve(i.scale);
    final rotation = execution.resolve(i.rotation);
    final transform = Field.zip3(
      execution.scalar,
      translation,
      scale,
      rotation,
      (context, t, s, r) => Mat4.identity()
        ..translate2(t)
        ..scale(s.x, s.y)
        ..rotateZ(r),
    );

    ProgramSlice build(FieldContext context) {
      final s = slice.evaluate(context);
      final t = transform.evaluate(context);

      final eval = execution.evaluate(s);
      final router = eval.routeTransform(eval.bundle.query.allCells);
      final changes = router.apply(t);

      final newSlice = s.replace(changes);
      return newSlice;
    }

    if (slice is ConstantField && transform is ConstantField) {
      execution.set(o.slice, .constant(build(execution.scalar)));
    } else {
      execution.set(o.slice, .dynamic(build));
    }
  }
}
