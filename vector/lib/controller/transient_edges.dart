part of '../controller.dart';

class TransientEdge with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdge({
    required this.complex,
    required this.startVertex,
    Vector2? cStart,
    Vector2? cEnd,
    Vector2? end,
  }) : _cStart = cStart,
       _cEnd = cEnd,
       _end = end;

  final VectorComplex complex;
  final Vertex startVertex;
  Vector2 get start => startVertex.position;

  Vector2? _cStart;
  Vector2? get cStart => _cStart;
  set cStart(Vector2? value) {
    if (_cStart == value) return;
    _cStart = value;
    _recomputeIntersections();
    notifyListeners();
  }

  Vector2? _cEnd;
  Vector2? get cEnd => _cEnd;
  set cEnd(Vector2? value) {
    if (_cEnd == value) return;
    _cEnd = value;
    _recomputeIntersections();
    notifyListeners();
  }

  Vector2? _end;
  Vector2? get end => _end;
  set end(Vector2? value) {
    if (_end == value) return;
    _end = value;
    _recomputeIntersections();
    notifyListeners();
  }

  Cubic2 get cubic => Cubic2(start, end ?? start, p1: cStart, p2: cEnd);

  List<Vector2> _intersections = [];
  Iterable<Vector2> get intersections => _intersections;
  void _recomputeIntersections() {
    if (end == null) {
      _intersections = [];
    } else {
      final complexIntersections = complex.intersectWithCubic(cubic).map((i) => i.point).toList();
      final selfIntersection = cubic.selfIntersect()?.point;

      _intersections = [
        ?selfIntersection,
        ...complexIntersections,
      ];
    }

    notifyListeners();
  }

  List<OpenEdge> _commit({CellHitTestEntry? endHitTest}) {
    if (end == null) return [];

    final endVertex = endHitTest != null ? complex.createVertexAtHitTest(endHitTest) : complex.createVertex(end!);
    end = endVertex.position;

    final cubic = this.cubic;
    final spline = CubicSpline2.cubics([cubic]);
    return complex.commitSpline(spline, startVertex: startVertex, endVertex: endVertex);
  }
}

class TransientEdges with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdges(this.controller);

  final VectorController controller;
  final edges = <TransientEdge>[];

  TransientEdge create(Vertex start, {Vector2? cStart}) {
    final edge = TransientEdge(complex: controller.complex, startVertex: start, cStart: cStart);
    edges.add(edge);
    notifyListeners();
    return edge;
  }

  TransientEdge createWithHitTest(Vector2 startPosition, CellHitTestEntry? hitTest, {Vector2? cStart}) {
    final startVertex = hitTest != null
        ? controller.complex.createVertexAtHitTest(hitTest)
        : controller.complex.createVertex(startPosition);

    return create(startVertex, cStart: cStart);
  }

  TransientEdge? commit(TransientEdge edge, {CellHitTestEntry? endHitTest, bool startNewEdge = false}) {
    if (!edges.contains(edge)) return null;

    final newEdges = edge._commit(endHitTest: endHitTest);
    remove(edge);

    if (startNewEdge && newEdges.isNotEmpty) {
      final last = newEdges.last;
      final cStart = last.cEnd?.pointReflect(last.end.position);
      return create(last.end, cStart: cStart);
    }

    return null;
  }

  void remove(TransientEdge edge) {
    edges.remove(edge);
    notifyListeners();
  }
}
