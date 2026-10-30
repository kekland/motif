import 'package:blueprint/core.dart' as bp;
import 'package:program/program.dart';
import 'package:schema/program.dart' as gen;

export 'blueprint_codec.g.dart';

// dart format off

extension GeneratorBlueprintEncode on GeneratorBlueprint { gen.GeneratorBlueprint encode() => _generatorBlueprintCodec.encode(this); }
extension GeneratorBlueprintDecode on gen.GeneratorBlueprint { GeneratorBlueprint decode() => _generatorBlueprintCodec.decode(this); }

final _generatorBlueprintCodec = $codec<GeneratorBlueprint, gen.GeneratorBlueprint>(
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
