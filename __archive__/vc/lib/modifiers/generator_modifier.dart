import '../vc.dart';

class GeneratorModifier extends Modifier<Cell> {
  GeneratorModifier({super.isEnabled, required this.generatorId});

  final Object? generatorId;

  @override
  (Cell, List<Cell>) apply(VectorComplexContext context, Cell cell) {
    if (generatorId == null) return (cell, []);

    final generator = context.generator[generatorId!];
    if (generator == null) {
      print('warning! generator with id $generatorId not found');
      return (cell, []);
    }

    try {
      final primitiveBundle = generator.execute(cell, context);
      final cellBundle = primitiveBundle.inflate();

      return (cell, cellBundle.cells);
    } catch (e) {
      print('warning! generator with id $generatorId failed to execute: $e');
      return (cell, []);
    }
  }

  GeneratorModifier copyWith({bool? isEnabled, Object? generatorId}) {
    return GeneratorModifier(
      isEnabled: isEnabled ?? this.isEnabled,
      generatorId: generatorId ?? this.generatorId,
    );
  }
}
