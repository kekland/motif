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
    final input = execution.evaluateScalar(i.slice);
    final count = execution.evaluateScalar(i.count);
    final offset = execution.evaluateScalar(i.offset);

    final out = ProgramSlice.empty();
    var index = 0;
    for (var x = 0; x < count.x.floor(); x++) {
      for (var y = 0; y < count.y.floor(); y++) {
        final copy = input.materialize((s) => execution.deriveFor(this, s, index: index));
        final inside = {for (final s in copy.statements) s.id};
        final shift = Vec2(offset.x * x, offset.y * y);
        for (final s in copy.statements) out.statements.add(_shifted(s, shift, inside));
        index++;
      }
    }

    execution.setConstant(o.slice, out);
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
