part of '../program.dart';

sealed class Modifier<S extends Statement> {
  S produce(ModifierEvalContext context);
}

final class FilletFaceModifier extends Modifier<FilletFaceStatement> {
  @override
  FilletFaceStatement produce(ModifierEvalContext context) {
    final face = context.products.firstWhere((r) => r.kind == .face).asFace;

    return .new(
      .of(face),
      corners: [],
      radius: null,
      enabled: true,
      id: context.derive(.of(0, context.index)),
    );
  }
}

final class GeneratorModifier extends Modifier<GeneratorStatement> {
  @override
  GeneratorStatement produce(ModifierEvalContext context) {
    return .new(
      id: context.derive(.of(0, context.index)),
    );
  }
}
