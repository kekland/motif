import 'package:blueprint/core.dart';
import 'package:geometry/geometry.dart';
import 'package:program/program.dart';

import 'generator.g.dart';

part 'nodes/array.dart';
part 'nodes/generator_input.dart';
part 'nodes/generator_output.dart';
part 'nodes/fillet.dart';
part 'nodes/primitives.dart';

class Generator extends Blueprint<Generator> {
  Generator({super.nodes, super.connections, super.positions, super.fixed}) {
    inputNode = nodes.singleWhere((n) => n is GeneratorInputNode) as GeneratorInputNode;
    outputNode = nodes.singleWhere((n) => n is GeneratorOutputNode) as GeneratorOutputNode;
  }

  factory Generator.empty() {
    final inputNode = GeneratorInputNode();
    final outputNode = GeneratorOutputNode();
    final generator = Generator(
      nodes: [inputNode, outputNode],
      connections: [.new(inputNode.o.slice.ref, outputNode.i.slice.ref)],
      fixed: {inputNode.id, outputNode.id},
      positions: {inputNode.id: .new(0.0, 0.0), outputNode.id: .new(200.0, 0.0)},
    );

    return generator;
  }

  late final GeneratorInputNode inputNode;
  late final GeneratorOutputNode outputNode;

  ProgramSlice execute(EvalContext context, ProgramSlice input) {
    final execution = BlueprintExecution(
      blueprint: this,
      environment: {
        EvalContext: context,
        ProgramSlice: input,
      },
    );

    return outputNode.execute(execution);
  }

  @override
  Generator copyWith({
    List<Node>? nodes,
    List<Connection>? connections,
    Map<NodeId, Vec2>? positions,
    Set<NodeId>? fixed,
  }) => .new(
    nodes: nodes ?? this.nodes,
    connections: connections ?? this.connections,
    positions: positions ?? this.positions,
    fixed: fixed ?? this.fixed,
  );
}

extension GeneratorNode on BlueprintExecution {
  EvalContext get evalContext => environment<EvalContext>();

  StatementId derive(Node node, int i, {StatementId? source}) {
    final key = source != null
        ? StatementId.mix(StatementId.mix(node.id.value, source.value), i)
        : StatementId.mix(node.id.value, i);

    return evalContext.derive(key, origin: this);
  }
}
