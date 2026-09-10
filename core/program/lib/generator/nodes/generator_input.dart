part of '../generator.dart';

final class GeneratorInputNode extends GeneratorInputNodeBase {
  GeneratorInputNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution context) {
    final inputSlice = context.environment<ProgramSlice>();
    context.set(o.slice, .constant(inputSlice));
  }
}
