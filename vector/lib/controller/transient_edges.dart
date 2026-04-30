part of '../controller.dart';

class TransientEdge with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdge({
    required this.start,
    Offset? c1Position,
    Offset? c2Position,
    Offset? endPosition,
  }) : _c1Position = c1Position,
       _c2Position = c2Position,
       _endPosition = endPosition;

  final Vertex start;

  Offset? _c1Position;
  Offset? get c1Position => _c1Position;
  set c1Position(Offset? value) {
    if (_c1Position == value) return;
    _c1Position = value;
    notifyListeners();
  }

  Offset? _c2Position;
  Offset? get c2Position => _c2Position;
  set c2Position(Offset? value) {
    if (_c2Position == value) return;
    _c2Position = value;
    notifyListeners();
  }

  Offset? _endPosition;
  Offset? get endPosition => _endPosition;
  set endPosition(Offset? value) {
    if (_endPosition == value) return;
    _endPosition = value;
    notifyListeners();
  }
}

class TransientEdges with ChangeNotifier, ChangeNotifierDisposable {
  final edges = <TransientEdge>[];

  TransientEdge create(Vertex start, {Offset? c1Position}) {
    final edge = TransientEdge(start: start, c1Position: c1Position);
    edges.add(edge);
    notifyListeners();
    return edge;
  }

  void remove(TransientEdge edge) {
    edges.remove(edge);
    notifyListeners();
  }
}
