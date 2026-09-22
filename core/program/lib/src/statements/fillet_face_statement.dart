part of '../_program.dart';

final class FilletFaceStatement extends Statement {
  FilletFaceStatement(
    FaceSelector face, {
    this.corners = const {},
    this.radius,
    super.id,
    super.modifiers,
  }) : face = face.clone() {
    selectors = [this.face];
  }

  final FaceSelector face;
  final CornerRadius? radius;
  final Map<int, CornerRadius> corners;

  @override
  Iterable<Op> execute(EvalContext context) sync* {
    yield FilletFaceOp(
      context.resolve(face),
      corners: corners,
      radius: radius,
    );
  }

  @override
  FilletFaceStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    FaceSelector? face,
    Map<int, CornerRadius>? corners,
    CornerRadius? radius,
  }) => .new(
    face ?? this.face,
    corners: corners ?? this.corners,
    radius: radius ?? this.radius,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward([
    context.resolve(face),
  ]);
}
