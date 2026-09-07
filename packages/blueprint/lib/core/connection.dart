part of 'core.dart';

extension type const Connection._(({OutputSocket output, InputSocket input}) _) {
  const Connection(OutputSocket output, InputSocket input) : this._((output: output, input: input));

  factory Connection.from(Socket a, Socket b) {
    if (a._node == b._node) {
      throw ArgumentError('Cannot connect two sockets on the same node');
    }

    if (a is InputSocket && b is OutputSocket) {
      return .new(b, a);
    } else if (a is OutputSocket && b is InputSocket) {
      return .new(a, b);
    } else {
      throw ArgumentError('Cannot connect two sockets of the same type');
    }
  }

  OutputSocket get output => _.output;
  InputSocket get input => _.input;
}

class _ConnectionContainer {
  _ConnectionContainer();

  final List<Connection> connections = [];
  final Map<InputSocket, List<OutputSocket>> _incomingConnections = {};
  final Map<OutputSocket, List<InputSocket>> _outgoingConnections = {};

  void addConnection(Socket a, Socket b) => _addConnection(.from(a, b));
  void _addConnection(Connection connection) {
    connections.add(connection);

    _incomingConnections[connection.input] ??= [];
    _incomingConnections[connection.input]!.add(connection.output);

    _outgoingConnections[connection.output] ??= [];
    _outgoingConnections[connection.output]!.add(connection.input);
  }

  void removeConnection(Socket a, Socket b) => _removeConnection(.from(a, b));
  void _removeConnection(Connection connection) {
    connections.remove(connection);
    _incomingConnections.remove(connection.input);
    _outgoingConnections[connection.output]?.remove(connection.input);
  }

  void removeConnectionsForSocket(Socket socket) {
    final connections = this.connections.where((c) => c.input == socket || c.output == socket).toList();
    for (final connection in connections) _removeConnection(connection);
  }

  void removeConnectionsForNode(Node node) {
    for (final socket in node.sockets) removeConnectionsForSocket(socket);
  }

  Iterable<OutputSocket> incomingConnectionFor(InputSocket input) => _incomingConnections[input] ?? [];
  Iterable<InputSocket> outgoingConnectionsFor(OutputSocket output) => _outgoingConnections[output] ?? [];
}
