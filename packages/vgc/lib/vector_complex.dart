import 'dart:math' as math;
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:uuid/v4.dart';
import 'package:geometry/geometry.dart';

part 'topology.dart';
part 'utils/hit_testing.dart';

class VectorComplex extends ChangeNotifier {
  Cell? _bottom, _top;
  Cell? get bottom => _bottom;
  Cell? get top => _top;

  final _cells = <Cell>{};
  bool contains(Cell c) => _cells.contains(c);
  int get length => _cells.length;

  // Depth-list operations
  void _linkAtTop(Cell c) {
    assert(!contains(c));

    c._prev = _top;
    _top?._next = c;
    _top = c;
    _bottom ??= c;
  }

  void _linkBelow(Cell c, Cell anchor) {
    assert(!contains(c) && contains(anchor));

    c._next = anchor;
    c._prev = anchor._prev;
    anchor._prev?._next = c;
    anchor._prev = c;

    if (_bottom == anchor) _bottom = c;
  }

  void _linkAbove(Cell c, Cell anchor) {
    assert(!contains(c) && contains(anchor));

    c._prev = anchor;
    c._next = anchor._next;
    anchor._next?._prev = c;
    anchor._next = c;

    if (_top == anchor) _top = c;
  }

  void _unlink(Cell c) {
    assert(contains(c));

    c._prev?._next = c._next;
    c._next?._prev = c._prev;
    if (_bottom == c) _bottom = c._next;
    if (_top == c) _top = c._prev;
    c._prev = null;
    c._next = null;
  }

  Cell? _lowestInBoundary(Cell c) {
    final boundary = c.directBoundary;
    if (boundary.isEmpty) return null;

    for (var x = _bottom; x != null; x = x._next) {
      if (boundary.contains(x)) return x;
    }

    return null;
  }

  void _insertWithDefaultDepth(Cell c) {
    final anchor = _lowestInBoundary(c);

    if (anchor == null) {
      _linkAtTop(c);
    } else {
      _linkBelow(c, anchor);
    }

    _cells.add(c);
    notifyListeners();
  }

  Vertex createVertex(Vector2 position, {String? id}) {
    final v = Vertex(position, id: id);
    _insertWithDefaultDepth(v);
    return v;
  }

  OpenEdge createOpenEdge(Vertex v1, Vertex v2, {List<CubicKnot2>? interior, Vector2? c1, Vector2? c2, String? id}) {
    assert(contains(v1) && contains(v2));
    final e = OpenEdge(v1, v2, interior: interior, c1: c1, c2: c2, id: id);
    _insertWithDefaultDepth(e);
    return e;
  }

  ClosedEdge createClosedEdge(CubicSpline2 spline, {String? id}) {
    final e = ClosedEdge(spline, id: id);
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

    final f = Face(cycles, id: id);
    _insertWithDefaultDepth(f);
    return f;
  }

  void hardDelete(Cell c) {
    assert(contains(c));

    final toDelete = <Cell>{c, ...c.star};

    for (final f in toDelete.whereType<Face>()) _detach(f);
    for (final e in toDelete.whereType<Edge>()) _detach(e);
    for (final v in toDelete.whereType<Vertex>()) _detach(v);

    notifyListeners();
  }

  void _detach(Cell c) {
    assert(contains(c));

    for (final b in c.directBoundary) b._directStar.remove(c);
    _unlink(c);
    _cells.remove(c);
  }

  // --
  // Hit testing
  // --

  List<HitTestEntry> hitTest(Vector2 point, {HitTestTolerance tolerance = .defaultTolerance}) {
    return _hitTestComplex(this, point, tolerance: tolerance);
  }
}
