import 'package:schema/codec.dart';

import 'package:blueprint/core.dart';
import 'package:schema/blueprint.dart' as gen;

// dart format off

extension NodeIdEncode on NodeId { gen.NodeId encode() => _nodeIdCodec.encode(this); }
extension NodeIdDecode on gen.NodeId { NodeId decode() => _nodeIdCodec.decode(this); }

final _nodeIdCodec = $codec<NodeId, gen.NodeId>(
  decoder: (v) => .new(v.value),
  encoder: (v) => .new(value: v.value),
);

extension SocketRefEncode on SocketRef { gen.SocketRef encode() => _socketRefCodec.encode(this); }
extension SocketRefDecode on gen.SocketRef { SocketRef decode() => _socketRefCodec.decode(this); }

final _socketRefCodec = $codec<SocketRef, gen.SocketRef>(
  decoder: (v) => .new(v.node.decode(), v.index),
  encoder: (v) => .new(node: v.node.encode(), index: v.index),
);

extension ConnectionEncode on Connection { gen.Connection encode() => _connectionCodec.encode(this); }
extension ConnectionDecode on gen.Connection { Connection decode() => _connectionCodec.decode(this); }

final _connectionCodec = $codec<Connection, gen.Connection>(
  decoder: (v) => .new(v.output.decode(), v.input.decode()),
  encoder: (v) => .new(output: v.output.encode(), input: v.input.encode()),
);