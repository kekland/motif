import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:shared/shared.dart';

part 'socket.dart';
part 'node.dart';
part 'field.dart';
part 'execution.dart';
part 'slice.dart';

final _random = math.Random();

extension type const NodeId(int value) implements int {
  NodeId.generate() : this(_random.nextInt(1 << 32));
}

extension type const SocketRef._((NodeId node, int index) _) implements Object {
  const SocketRef(NodeId node, int index) : this._((node, index));
  NodeId get node => _.$1;
  int get index => _.$2;

  SocketRef copyWith({
    NodeId? node,
    int? index,
  }) => .new(
    node ?? this.node,
    index ?? this.index,
  );
}

extension type const Connection._((SocketRef output, SocketRef input, int index) _) implements Object {
  const Connection(SocketRef output, SocketRef input, {int index = 0}) : this._((output, input, index));
  SocketRef get output => _.$1;
  SocketRef get input => _.$2;
  int get index => _.$3;

  bool hasNode(NodeId id) => output.node == id || input.node == id;
  bool hasSocket(SocketRef ref) => output == ref || input == ref;

  Connection copyWith({
    SocketRef? output,
    SocketRef? input,
    int? index,
  }) => .new(
    output ?? this.output,
    input ?? this.input,
    index: index ?? this.index,
  );
}

Map<SocketRef, List<SocketRef>> _buildConnectionsCache(
  List<Connection> connections,
  (SocketRef, SocketRef) Function(Connection) orient,
) {
  final out = <SocketRef, List<SocketRef>>{};
  for (final c in connections) {
    final (key, value) = orient(c);
    out[key] ??= [];
    out[key]!.add(value);
  }
  return out;
}

abstract class Blueprint<B extends Blueprint<B>> {
  Blueprint.empty() : this();

  Blueprint({
    this.nodes = const [],
    this.connections = const [],
    this.positions = const {},
    this.fixed = const {},
  }) {
    _nodeMap = {for (final n in nodes) n.id: n};
    _incoming = _buildConnectionsCache(connections, (c) => (c.input, c.output));
    _outgoing = _buildConnectionsCache(connections, (c) => (c.output, c.input));
  }

  final List<Node> nodes;
  final List<Connection> connections;
  final Map<NodeId, Vec2> positions;
  final Set<NodeId> fixed;

  late final Map<NodeId, Node> _nodeMap;
  late final Map<SocketRef, List<SocketRef>> _incoming;
  late final Map<SocketRef, List<SocketRef>> _outgoing;

  N node<N extends Node>(NodeId id) => _nodeMap[id]! as N;
  S socket<S extends Socket>(SocketRef ref) => node(ref.node)._sockets[ref.index] as S;

  bool hasNode(NodeId id) => _nodeMap.containsKey(id);

  Iterable<Connection> connectionsOf(NodeId id) => connections.where((c) => c.hasNode(id));
  Iterable<Connection> socketConnections(SocketRef ref) => connections.where((c) => c.hasSocket(ref));
  Iterable<OutputSocket> incoming(InputSocket s) => _incoming[s.ref]?.map(socket) ?? const [];
  Iterable<InputSocket> outgoing(OutputSocket s) => _outgoing[s.ref]?.map(socket) ?? const [];

  int listIncomingLength(ListInputSocket s) {
    final incoming = socketConnections(s.ref);
    return incoming.isEmpty ? 0 : incoming.map((c) => c.index).reduce(math.max) + 1;
  }

  Iterable<OutputSocket?> listIncoming(ListInputSocket s) {
    final length = listIncomingLength(s);
    if (length == 0) return const [];
    return List.generate(length, (i) {
      final c = socketConnections(s.ref).firstWhereOrNull((c) => c.index == i)?.output;
      return c != null ? socket(c) : null;
    });
  }

  bool isConnected(Socket s) => switch (s) {
    InputSocket() => _incoming.containsKey(s.ref),
    OutputSocket() => _outgoing.containsKey(s.ref),
    _ => false,
  };

  Vec2 positionOf(NodeId id) => positions[id]!;
  bool isFixed(NodeId id) => fixed.contains(id);

  B add(Node node, {Vec2? position, bool isFixed = false}) => copyWith(
    nodes: [...nodes, node],
    connections: connections,
    positions: {...positions, node.id: position ?? .zero()},
    fixed: isFixed ? {...fixed, node.id} : fixed,
  );

  B remove(NodeId id) {
    if (isFixed(id)) throw ArgumentError('cannot remove a fixed node');
    return copyWith(
      nodes: nodes.where((n) => n.id != id).toList(),
      connections: connections.where((c) => !c.hasNode(id)).toList(),
      positions: {...positions}..remove(id),
      fixed: {...fixed}..remove(id),
    );
  }

  B replace(Node node) => copyWith(
    nodes: nodes.map((n) => n.id == node.id ? node : n).toList(),
  );

  B move(NodeId id, Vec2 position) => copyWith(
    positions: {...positions, id: position},
  );

  B moveMany(Map<NodeId, Vec2> positions) => copyWith(
    positions: {...this.positions, ...positions},
  );

  B setFixed(NodeId id, bool isFixed) => copyWith(
    fixed: isFixed ? {...fixed, id} : ({...fixed}..remove(id)),
  );

  (OutputSocket, InputSocket) _orientConnection(SocketRef a, SocketRef b) {
    assert(a.node != b.node, 'cannot connect a node to itself');
    final aSocket = socket(a);
    final bSocket = socket(b);

    if (aSocket is OutputSocket && bSocket is InputSocket) {
      return (aSocket, bSocket);
    } else if (aSocket is InputSocket && bSocket is OutputSocket) {
      return (bSocket, aSocket);
    } else {
      throw ArgumentError('cannot connect two sockets of the same direction');
    }
  }

  B connect(SocketRef a, SocketRef b, {int index = 0}) {
    final (output, input) = _orientConnection(a, b);
    assert(input.accepts(output), 'cannot connect ${output.type} to ${input.type}');

    final c = Connection(output.ref, input.ref, index: index);
    if (connections.contains(c)) return this as B;

    return copyWith(
      connections: [
        for (final x in connections)
          if (input.isList || x.input != input.ref) x,
        c,
      ],
    );
  }

  B disconnect(SocketRef a, SocketRef b, {int index = 0}) {
    final (output, input) = _orientConnection(a, b);
    final c = Connection(output.ref, input.ref, index: index);
    if (!connections.contains(c)) return this as B;

    return copyWith(
      connections: connections.where((x) => x != c).toList(),
    );
  }

  B copyWith({
    List<Node>? nodes,
    List<Connection>? connections,
    Map<NodeId, Vec2>? positions,
    Set<NodeId>? fixed,
  });

  BlueprintSlice slice(Set<NodeId> nodes) {
    final acceptedNodes = <NodeId>{};
    final positions = <NodeId, Vec2>{};
    for (final id in nodes) {
      if (isFixed(id)) continue;
      acceptedNodes.add(id);
      positions[id] = positionOf(id);
    }

    final acceptedConnections = connections
        .where((c) => acceptedNodes.contains(c.input.node) && acceptedNodes.contains(c.output.node))
        .toList();

    return .new(
      nodes: acceptedNodes.map((id) => node(id)).toList(),
      connections: acceptedConnections,
      positions: positions,
    );
  }

  Uint8List encodeSlice(BlueprintSlice slice);
  BlueprintSlice decodeSlice(Uint8List data);

  /// Whether this and [other] are structurally equivalent.
  bool isEquivalentTo(B other) {
    if (nodes.length != other.nodes.length) return false;
    if (connections.length != other.connections.length) return false;

    final _otherNodes = other.nodes.toSet();
    final _otherConnections = other.connections.toSet();

    for (final node in nodes) {
      if (!_otherNodes.contains(node)) return false;
    }

    for (final connection in connections) {
      if (!_otherConnections.contains(connection)) return false;
    }

    return true;
  }
}
