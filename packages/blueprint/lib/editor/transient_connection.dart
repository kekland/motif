part of 'editor.dart';

class TransientConnection with ChangeNotifier {
  TransientConnection({required this.source, required this.sourceIndex, required this._position});

  final SocketRef source;
  final int sourceIndex;
  Offset _position;
  Offset get position => _position;
  set position(Offset value) {
    if (_position == value) return;
    _position = value;
    notifyListeners();
  }
}

class TransientConnections with ChangeNotifier {
  TransientConnections();

  final _connections = <TransientConnection>[];
  Iterable<TransientConnection> get connections => _connections;

  TransientConnection add(SocketRef source, int sourceIndex, Offset position) {
    final connection = TransientConnection(source: source, sourceIndex: sourceIndex, position: position);
    _connections.add(connection);
    notifyListeners();
    return connection;
  }

  void remove(TransientConnection connection) {
    _connections.remove(connection);
    connection.dispose();
    notifyListeners();
  }
}
