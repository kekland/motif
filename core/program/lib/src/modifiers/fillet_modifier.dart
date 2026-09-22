part of '../_program.dart';

final class FilletModifier extends Modifier<FacedStatement> {
  FilletModifier({
    this.radius,
    this.corners = const {},
    super.enabled,
  });

  final CornerRadius? radius;
  final Map<int, CornerRadius> corners;

  @override
  ModifierKind get kind => .fillet;

  @override
  FilletFaceStatement produce(ModifierEvalContext<FacedStatement> context) {
    return .new(
      context.base.face.selector(),
      id: context.id,
      radius: radius,
      corners: corners,
    );
  }
}
