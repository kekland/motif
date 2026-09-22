part of '../generator.dart';

final class GeneratorOutputNode extends GeneratorOutputNodeBase {
  GeneratorOutputNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  ProgramSlice execute(BlueprintExecution execution) {
    final slices = execution.evaluateScalar(i.slices);
    return .merged(slices);
  }
}
