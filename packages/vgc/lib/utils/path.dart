part of '../vector_complex.dart';

extension EdgeGetPathExtension on Edge {
  Path getPath() {
    final path = Path();
    _appendEdgeToPath(path, this, forward: true, moveToStart: true);
    return path;
  }
}

extension RegularCycleGetPathExtension on RegularCycle {
  Path getPath() {
    final path = Path();
    _appendCycleToPath(path, this);
    return path;
  }
}

extension FaceGetPathExtension on Face {
  Path getPath() {
    final path = Path();
    for (final cycle in cycles) {
      if (cycle is RegularCycle) _appendCycleToPath(path, cycle);
    }
    return path;
  }
}

void _appendCycleToPath(Path path, RegularCycle cycle) {
  if (cycle.halfEdges.isEmpty) return;

  var first = true;
  for (final he in cycle.halfEdges) {
    _appendEdgeToPath(path, he.edge, forward: he.direction, moveToStart: first);
    first = false;
  }

  path.close();
}

void _appendEdgeToPath(
  Path path,
  Edge edge, {
  required bool forward,
  bool moveToStart = false,
}) {
  final knots = edge.spline.knots;
  if (knots.isEmpty) return;

  if (forward) {
    if (moveToStart) {
      final first = knots.first;
      path.moveTo(first.p.x, first.p.y);
    }

    for (var i = 0; i < knots.length - 1; i++) {
      final a = knots[i];
      final b = knots[i + 1];
      _cubicTo(path, a.p, a.c2, b.c1, b.p);
    }
  } else {
    if (moveToStart) {
      final last = knots.last;
      path.moveTo(last.p.x, last.p.y);
    }

    for (var i = knots.length - 2; i >= 0; i--) {
      final a = knots[i];
      final b = knots[i + 1];
      _cubicTo(path, b.p, b.c1, a.c2, a.p);
    }
  }
}

void _cubicTo(Path path, Vector2 a, Vector2? c1, Vector2? c2, Vector2 b) {
  final _c1 = c1 ?? a;
  final _c2 = c2 ?? b;
  path.cubicTo(_c1.x, _c1.y, _c2.x, _c2.y, b.x, b.y);
}
