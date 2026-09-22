part of '../generator.dart';

final class FilletNode extends FilletNodeBase {
  FilletNode({
    NodeId? id,
    super.radius,
    super.slice,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final input = execution.evaluateScalar(i.slice);
    final radius = execution.resolve(i.radius);

    final out = ProgramSlice.empty();

    for (final context in execution.sliceContext(input)) {
      final face = switch (context.statement) {
        FacedStatement s => s.face,
        _ => null,
      };

      if (face == null) continue;
      out.statements.add(
        FilletFaceStatement(
          face.selector(),
          id: execution.derive(this, context),
          radius: .vec(radius.evaluate(context)),
        ),
      );
    }

    execution.setConstant(o.slice, input.extend(out));
  }
}
