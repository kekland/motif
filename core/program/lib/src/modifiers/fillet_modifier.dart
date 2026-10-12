part of '../_program.dart';

final class FilletModifier extends Modifier {
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
  FilletFaceStatement produce(ModifierEvalContext context) {
    final cells = context.fragment.resolved(context);
    final face = cells.whereFace().first;

    return .new(
      face.selector(),
      id: context.id,
      radius: radius,
      corners: corners,
    );
  }
}
