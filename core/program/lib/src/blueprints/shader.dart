import 'dart:typed_data';

import 'package:blueprint/core.dart';
import 'package:geometry/geometry.dart';
import 'package:program/program.dart';
import 'package:schema/program.dart' as gen;

import 'shader/wgsl_generator.dart';

export 'blueprint.g.dart';
export 'codec/blueprint_codec.g.dart';
export 'codec/generator_codec.dart';

part 'shader/io_nodes.dart';

class ShaderBlueprint extends Blueprint<ShaderBlueprint> {
  ShaderBlueprint({super.nodes, super.connections, super.positions, super.fixed}) {
    inputNode = nodes.singleWhere((n) => n is ShaderInputNode) as ShaderInputNode;
    outputNode = nodes.singleWhere((n) => n is ShaderOutputNode) as ShaderOutputNode;
  }

  factory ShaderBlueprint.empty() {
    final inputNode = ShaderInputNode();
    final outputNode = ShaderOutputNode(color: .white);
    final generator = ShaderBlueprint(
      nodes: [inputNode, outputNode],
      fixed: {inputNode.id, outputNode.id},
      positions: {inputNode.id: .new(0.0, 0.0), outputNode.id: .new(360.0, 0.0)},
    );

    return generator;
  }

  late final ShaderInputNode inputNode;
  late final ShaderOutputNode outputNode;

  @override
  ShaderBlueprint copyWith({
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
    final pb = gen.BlueprintSlice.fromBuffer(data);
    return pb.decode();
  }

  @override
  Uint8List encodeSlice(BlueprintSlice slice) {
    final pb = slice.encode();
    return pb.writeToBuffer();
  }
}

extension ShaderBlueprintExtension on ShaderBlueprint {
  List<String> toWgsl(String fnName) => ShaderWgslGenerator(this).generate(fnName);
}
