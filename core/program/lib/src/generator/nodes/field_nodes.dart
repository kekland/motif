part of '../generator.dart';

final class IndexNode extends IndexNodeBase {
  IndexNode({NodeId? id}) : super(id: id ?? .generate());

  @override
  void execute(BlueprintExecution execution) {
    execution.set(o.index, .dynamic((context) => context.index));
  }
}
