part of '../generator.dart';

final class GeneratorInputNode extends GeneratorInputNodeBase {
  GeneratorInputNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final inputSlice = execution.environment<ProgramSlice>();
    execution.setConstant(
      o.slice,
      inputSlice.materialize((_, s) => execution.deriveFor(this, s)),
    );
  }
}

final class GeneratorOutputNode extends GeneratorOutputNodeBase {
  GeneratorOutputNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  ProgramSlice execute(BlueprintExecution execution) {
    final rootCtx = execution.scalar;
    final slices = execution.resolve(i.slices).evaluate(rootCtx);
    return .merged(slices);
  }
}

final class MergeNode extends MergeNodeBase {
  MergeNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    final slices = execution.evaluateScalar(i.slices);
    final mergedSlice = ProgramSlice.merged(slices);
    execution.setConstant(o.slice, mergedSlice);
  }
}
