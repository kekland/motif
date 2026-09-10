part of '../generator.dart';

final class FilletNode extends FilletNodeBase {
  FilletNode({
    NodeId? id,
    super.radius,
    super.slice,
  }) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution context) {
    final input = context.resolve(i.slice).evaluate(context);
    final r = context.resolve(i.radius).evaluate(context);

    final out = <Statement>[];
    for (final s in input.statements) {
      final face = switch (s) {
        FaceStatement() => s.ref,
        ShapeStatement() => s.face,
        _ => null,
      };

      if (face == null) continue;
      out.add(
        FilletFaceStatement(
          face.selector(),
          id: context.derive(this, 0, source: s.id),
          radius: .vec(r),
        ),
      );
    }

    context.set(o.slice, .constant(input.extend(out)));
  }
}
