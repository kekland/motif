part of '../controller.dart';

class TransientEdge with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdge({
    required this.start,
    Offset? cStartPosition,
    Offset? cEndPosition,
    Offset? endPosition,
  }) : _cStartPosition = cStartPosition,
       _cEndPosition = cEndPosition,
       _endPosition = endPosition;

  final Vertex start;

  Offset? _cStartPosition;
  Offset? get cStartPosition => _cStartPosition;
  set cStartPosition(Offset? value) {
    if (_cStartPosition == value) return;
    _cStartPosition = value;
    notifyListeners();
  }

  Offset? _cEndPosition;
  Offset? get cEndPosition => _cEndPosition;
  set cEndPosition(Offset? value) {
    if (_cEndPosition == value) return;
    _cEndPosition = value;
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

  TransientEdge create(Vertex start, {Offset? cStartPosition}) {
    final edge = TransientEdge(start: start, cStartPosition: cStartPosition);
    edges.add(edge);
    notifyListeners();
    return edge;
  }

  void remove(TransientEdge edge) {
    edges.remove(edge);
    notifyListeners();
  }
}
