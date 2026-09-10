part of '../generator.dart';

final class GeneratorOutputNode extends GeneratorOutputNodeBase {
  GeneratorOutputNode({
    NodeId? id,
    super.slice,
  }) : super(id: id ?? .generate());

  @override
  ProgramSlice execute(BlueprintExecution context) {
    final slice = context.resolve(i.slice);
    return slice.evaluate(context);
  }
}
