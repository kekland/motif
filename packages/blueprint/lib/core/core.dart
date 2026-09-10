import 'package:geometry/geometry.dart';

part 'socket.dart';
part 'node.dart';
part 'field.dart';
part 'execution.dart';

extension type const NodeId(int value) implements Object {
  NodeId.generate() : this(_seq++);
  static int _seq = 1;
}

extension type const SocketRef._((NodeId node, int index) _) implements Object {
  const SocketRef(NodeId node, int index) : this._((node, index));
  NodeId get node => _.$1;
  int get index => _.$2;
}

extension type const Connection._((SocketRef output, SocketRef input) _) implements Object {
  const Connection(SocketRef output, SocketRef input) : this._((output, input));
  SocketRef get output => _.$1;
  SocketRef get input => _.$2;

  bool hasNode(NodeId id) => output.node == id || input.node == id;
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
  Iterable<OutputSocket> incoming(InputSocket s) => _incoming[s.ref]?.map(socket) ?? const [];
  Iterable<InputSocket> outgoing(OutputSocket s) => _outgoing[s.ref]?.map(socket) ?? const [];

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

  B connect(SocketRef a, SocketRef b) {
    final (output, input) = _orientConnection(a, b);
    assert(input.accepts(output), 'cannot connect ${output.type} to ${input.type}');

    final c = Connection(output.ref, input.ref);
    if (connections.contains(c)) return this as B;

    return copyWith(
      connections: [
        for (final x in connections)
          if (input.isList || x.input != input.ref) x,
        c,
      ],
    );
  }

  B disconnect(SocketRef a, SocketRef b) {
    final (output, input) = _orientConnection(a, b);
    final c = Connection(output.ref, input.ref);
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
}
