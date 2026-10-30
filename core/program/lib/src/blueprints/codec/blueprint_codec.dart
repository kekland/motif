import 'package:program/program.dart';
import 'package:blueprint/core.dart' as bp;
import 'package:schema/program.dart' as gen;

export 'blueprint_codec.g.dart';
export 'generator_codec.dart';
export 'shader_codec.dart';

// dart format off

extension BlueprintSliceEncode on bp.BlueprintSlice { gen.BlueprintSlice encode() => blueprintSliceCodec.encode(this); }
extension BlueprintSliceDecode on gen.BlueprintSlice { bp.BlueprintSlice decode() => blueprintSliceCodec.decode(this); }

final blueprintSliceCodec = $codec<bp.BlueprintSlice, gen.BlueprintSlice>(
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
