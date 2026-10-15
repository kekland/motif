import 'package:blueprint/core.dart' as bp;
import 'package:program/program.dart';
import 'package:schema/program.dart' as gen;

export 'generator.codec.g.dart';

// dart format off

extension GeneratorEncode on Generator { gen.Generator encode() => _generatorCodec.encode(this); }
extension GeneratorDecode on gen.Generator { Generator decode() => _generatorCodec.decode(this); }

final _generatorCodec = $codec<Generator, gen.Generator>(
  decoder: (v) => .new(
    nodes: $map(v.nodes, (e) => e.decode()),
    connections: $map(v.connections, (e) => e.decode()),
    positions: $mapFrom(v.positions, (v) => v.node.decode(), (v) => v.position.decode()),
    fixed: $map(v.fixed, (e) => e.decode()).toSet(),
  ),
  encoder: (v) => .new(
    nodes: $map(v.nodes, (e) => e.encode()),
    connections: $map(v.connections, (e) => e.encode()),
    positions: $fromMap(v.positions, (k, v) => .new(node: k.encode(), position: v.encode())),
    fixed: $map(v.fixed, (e) => e.encode()).toList(),
  ),
);

extension GeneratorSliceEncode on bp.BlueprintSlice { gen.GeneratorSlice encode() => _generatorSliceCodec.encode(this); }
extension GeneratorSliceDecode on gen.GeneratorSlice { bp.BlueprintSlice decode() => _generatorSliceCodec.decode(this); }

final _generatorSliceCodec = $codec<bp.BlueprintSlice, gen.GeneratorSlice>(
  decoder: (v) => .new(
    nodes: $map(v.nodes, (e) => e.decode()),
    connections: $map(v.connections, (e) => e.decode()),
    positions: $mapFrom(v.positions, (v) => v.node.decode(), (v) => v.position.decode()),
  ),
  encoder: (v) => .new(
    nodes: $map(v.nodes, (e) => e.encode()),
    connections: $map(v.connections, (e) => e.encode()),
    positions: $fromMap(v.positions, (k, v) => .new(node: k.encode(), position: v.encode())),
  ),
);
