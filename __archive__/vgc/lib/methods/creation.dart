part of '../vector_complex.dart';

extension VectorComplexCreation on VectorComplex {
  Vertex createVertex(Vector2 position, {String? id}) {
    final v = Vertex(position, id: id, complex: this);
    _insertWithDefaultDepth(v);
    return v;
  }

  OpenEdge createOpenEdge(
    Vertex v1,
    Vertex v2, {
    List<CubicKnot2>? interior,
    Vector2? cStart,
    Vector2? cEnd,
    String? id,
    StrokeWeightParameterProfile? strokeWeight,
  }) {
    assert(contains(v1) && contains(v2));
    final e = OpenEdge(
      v1,
      v2,
      interior: interior,
      cStart: cStart,
      cEnd: cEnd,
      id: id,
      strokeWeight: strokeWeight,
      complex: this,
    );

    _insertWithDefaultDepth(e);
    return e;
  }

  OpenEdge createOpenEdgeFromSpline(
    Vertex v1,
    Vertex v2,
    CubicSpline2 spline, {
    String? id,
    StrokeWeightParameterProfile? strokeWeight,
    double? strokeWidth,
    ColorData? color,
  }) {
    assert(contains(v1) && contains(v2));
    final e = OpenEdge.fromSpline(
      v1,
      v2,
      spline,
      id: id,
      strokeWeight: strokeWeight,
      strokeWidth: strokeWidth,
      color: color,
      complex: this,
    );
    _insertWithDefaultDepth(e);
    return e;
  }

  ClosedEdge createClosedEdge(CubicSpline2 spline, {String? id, StrokeWeightParameterProfile? strokeWeight}) {
    final e = ClosedEdge(spline, id: id, strokeWeight: strokeWeight, complex: this);
    _insertWithDefaultDepth(e);
    return e;
  }

  Face createFace(List<Cycle> cycles, {String? id}) {
    assert(() {
      for (final cycle in cycles) {
        final cells = cycle._cells;
        for (final cell in cells) {
          if (!contains(cell)) return false;
        }
      }

      return true;
    }());

    final f = Face(cycles, id: id, complex: this);
    _insertWithDefaultDepth(f);
    return f;
  }
}
