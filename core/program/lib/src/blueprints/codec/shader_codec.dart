import 'package:blueprint/core.dart' as bp;
import 'package:program/program.dart';
import 'package:schema/program.dart' as gen;

export 'blueprint_codec.g.dart';

// dart format off

extension ShaderBlueprintEncode on ShaderBlueprint { gen.ShaderBlueprint encode() => _shaderBlueprintCodec.encode(this); }
extension ShaderBlueprintDecode on gen.ShaderBlueprint { ShaderBlueprint decode() => _shaderBlueprintCodec.decode(this); }

final _shaderBlueprintCodec = $codec<ShaderBlueprint, gen.ShaderBlueprint>(
  decoder: (v) => .new(
    nodes: $map(v.blueprint.nodes, (e) => e.decode()),
    connections: $map(v.blueprint.connections, (e) => e.decode()),
    positions: $mapFrom(v.blueprint.positions, (v) => v.node.decode(), (v) => v.position.decode()),
    fixed: $map(v.blueprint.fixed, (e) => e.decode()).toSet(),
  ),
  encoder: (v) => .new(
    blueprint: .new(
      nodes: $map(v.nodes, (e) => e.encode()),
      connections: $map(v.connections, (e) => e.encode()),
      positions: $fromMap(v.positions, (k, v) => .new(node: k.encode(), position: v.encode())),
      fixed: $map(v.fixed, (e) => e.encode()).toList(),
    ),
  ),
);
