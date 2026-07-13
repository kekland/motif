import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:color/color.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:uuid/v4.dart';
import 'package:geometry/geometry.dart';

// Topology
part 'topology/cell.dart';
part 'topology/vertex.dart';
part 'topology/edge.dart';
part 'topology/half_edge.dart';
part 'topology/cycle.dart';
part 'topology/face.dart';

// Geometry utils on topological units
part 'geometry/cycle.dart';
part 'geometry/edge.dart';
part 'geometry/half_edge.dart';
part 'geometry/vertex.dart';

// Methods on the complex
part 'methods/commit_spline.dart';
part 'methods/creation.dart';
part 'methods/deletion.dart';
part 'methods/face_decomposition.dart';
part 'methods/intersections.dart';
part 'methods/cut/cut_edge.dart';

// Other utilities
part 'utils/path.dart';

class VectorComplex extends ChangeNotifier {
  Cell? _bottom, _top;
  Cell? get bottom => _bottom;
  Cell? get top => _top;

  final _cells = <Cell>{};
  bool contains(Cell c) => _cells.contains(c);
  int get length => _cells.length;

  Iterable<Cell> get cells sync* {
    for (var c = _bottom; c != null; c = c._next) yield c;
  }

  Iterable<Cell> get cellsReversed sync* {
    for (var c = _top; c != null; c = c._prev) yield c;
  }

  Iterable<Vertex> get vertices => cells.whereType<Vertex>();
  Iterable<Edge> get edges => cells.whereType<Edge>();
  Iterable<Face> get faces => cells.whereType<Face>();

  Aabb2 get bbox {
    if (length == 0) return Aabb2();

    var min = Vector2(.infinity, .infinity);
    var max = Vector2(.negativeInfinity, .negativeInfinity);

    for (final c in cells) {
      final aabb = c.boundingBoxApproximate;
      Vector2.min(min, aabb.min, min);
      Vector2.max(max, aabb.max, max);
    }

    return Aabb2.minMax(min, max);
  }

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

  void _detach(Cell c) {
    assert(contains(c));

    for (final b in c.directBoundary) b._directStar.remove(c);
    _unlink(c);
    _cells.remove(c);
  }

  final _streamController = StreamController<String>.broadcast();
  Stream<void> streamFor(Cell c) => _streamController.stream.where((id) => id == c.id);

  void notifyFor(Cell c) {
    _streamController.add(c.id);
    notifyListeners();
  }

  void _internalNotify() {
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  // Vertex splitEdge(Edge edge, double t) {
  //   assert(contains(edge));
  // }
}
