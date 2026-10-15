import 'dart:math' as math;
import 'dart:typed_data';

import 'package:blueprint/core.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:schema/program.dart' as gen;
import 'package:shared/shared.dart';

export 'generator.g.dart';
export 'generator_codec.dart';

part 'nodes/io_nodes.dart';
part 'nodes/math_nodes.dart';
part 'nodes/primitive_nodes.dart';
part 'nodes/query_nodes.dart';
part 'nodes/geometry_nodes.dart';
part 'nodes/field_nodes.dart';

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
      connections: [.new(inputNode.o.slice.ref, outputNode.i.slices.ref)],
      fixed: {inputNode.id, outputNode.id},
      positions: {inputNode.id: .new(0.0, 0.0), outputNode.id: .new(360.0, 0.0)},
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

  @override
  BlueprintSlice decodeSlice(Uint8List data) {
    final pb = gen.GeneratorSlice.fromBuffer(data);
    return pb.decode();
  }

  @override
  Uint8List encodeSlice(BlueprintSlice slice) {
    final pb = slice.encode();
    return pb.writeToBuffer();
  }
}

extension GeneratorBlueprintExecution on BlueprintExecution {
  EvalContext get evalContext => environment<EvalContext>();

  StatementId derive(Node node, FieldContext context) {
    final base = U64.of(0, node.id.value);
    final key = Mix64.mix(base, context.id ?? .zero);
    return evalContext.derive(key, origin: node);
  }

  StatementId deriveFor(Node node, Statement source, {int index = 0}) {
    final base = U64.of(0, node.id.value);
    final key = Mix64.mixWithKey(Mix64.mix(base, source.id.value), index);
    return evalContext.derive(key, origin: node);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Sub-evaluations
  // -------------------------------------------------------------------------------------------------------------------

  static final _evaluationCache = Expando<Evaluation>();

  Evaluation evaluate(ProgramSlice slice) {
    final cached = _evaluationCache[slice];
    if (cached != null) return cached;

    final evaluation = evalContext.evaluation.subEvaluation(slice);
    evaluation.performInitialPass();

    _evaluationCache[slice] = evaluation;
    return evaluation;
  }
}

extension GeneratorFieldContext on FieldContext {
  Statement get statement => element as Statement;
  StatementId deriveId(Node node) => execution.derive(node, this);
}
