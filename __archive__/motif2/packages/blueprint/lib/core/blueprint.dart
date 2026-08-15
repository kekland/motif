part of 'core.dart';

class Blueprint with ChangeNotifier, ChangeNotifierDisposable {
  Blueprint() : nodes = [], _nodePositions = {}, _nodeStatic = {}, _connections = .new();

  final List<Node> nodes;
  final _ConnectionContainer _connections;
  Iterable<Connection> get connections => _connections.connections;

  final Map<Node, Offset> _nodePositions;
  final Map<Node, bool> _nodeStatic;

  void addNode(Node node, {Offset? position, bool isStatic = false}) {
    nodes.add(node);
    node._blueprint = this;
    _nodePositions[node] = position ?? .zero;
    _nodeStatic[node] = isStatic;

    _markNodeAsDirty(node);
  }

  void removeNode(Node node) {
    nodes.remove(node);
    node._blueprint = null;
    _connections.removeConnectionsForNode(node);
    _markNodeAsDirty(node);

    _nodeSignals.remove(node)?.dispose();
    for (final s in node.sockets) _socketSignals.remove(s)?.dispose();
  }

  Offset getNodePosition(Node node) => _nodePositions[node]!;
  void setNodePosition(Node node, Offset position) {
    _nodePositions[node] = position;
    _markNodeAsDirty(node);
  }

  bool getNodeStatic(Node node) => _nodeStatic[node]!;
  void setNodeStatic(Node node, bool isStatic) {
    _nodeStatic[node] = isStatic;
    _markNodeAsDirty(node);
  }

  void connect(Socket a, Socket b) {
    _connections.addConnection(a, b);
    _markSocketAsDirty(a);
    _markSocketAsDirty(b);
  }

  void disconnect(Socket a, Socket b) {
    _connections.removeConnection(a, b);
    _markSocketAsDirty(a);
    _markSocketAsDirty(b);
  }

  void _markNodeAsDirty(Node node) {
    assert(node._blueprint == this);
    _nodeSignals[node]?.markAsDirty();
    notifyListeners();
  }

  void _markSocketAsDirty(Socket socket) {
    assert(socket._node?._blueprint == this);
    _socketSignals[socket]?.markAsDirty();
    notifyListeners();
  }

  final _nodeSignals = <Node, ObjectSignal<Node>>{};
  final _socketSignals = <Socket, ObjectSignal<Socket>>{};

  ObjectSignal<Node> _signalForNode(Node node) {
    assert(node._blueprint == this);
    _nodeSignals[node] ??= .new(node);
    return _nodeSignals[node]!;
  }

  ObjectSignal<Socket> _signalForSocket(Socket socket) {
    assert(socket._node?._blueprint == this);
    _socketSignals[socket] ??= .new(socket);
    return _socketSignals[socket]!;
  }
  
  final _environment = <Type, Object>{};
  void addEnvironment<T extends Object>(T value) => _environment[T] = value;
  T getEnvironment<T extends Object>() => _environment[T] as T;

  @override
  void dispose() {
    for (final s in _nodeSignals.values) s.dispose();
    for (final s in _socketSignals.values) s.dispose();
    _nodeSignals.clear();
    _socketSignals.clear();
    _environment.clear();

    super.dispose();
  }
}
