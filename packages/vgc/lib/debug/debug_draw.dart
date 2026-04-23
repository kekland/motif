import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:vgc/vgc.dart';

var _debugFaceColorIndex = 0;
var _debugFaceColors = Colors.primaries;
Color _getDebugFaceColor() => _debugFaceColors[_debugFaceColorIndex++ % _debugFaceColors.length].withValues(alpha: 0.5);

void drawDebugVectorComplex(Canvas canvas, VectorComplex complex) {
  _debugFaceColorIndex = 0;

  for (var c = complex.bottom; c != null; c = c.next) drawDebugCell(canvas, c);

  for (var c = complex.bottom; c != null; c = c.next) {
    if (c is Edge) {
      _drawDebugEdgeBezierParams(canvas, c);
    }
  }
}

void drawDebugCell(Canvas canvas, Cell cell, {Color? color}) {
  switch (cell) {
    case Vertex v:
      _drawDebugVertex(canvas, v, color: color);
    case Edge e:
      _drawDebugEdge(canvas, e, color: color);
    case Face f:
      _drawDebugFace(canvas, f, color: color);
  }
}

void _drawDebugVertex(Canvas canvas, Vertex v, {Color? color}) {
  canvas.drawCircle(Offset(v.position.x, v.position.y), 4, Paint()..color = color ?? Colors.deepPurple);
}

void _drawDebugEdge(Canvas canvas, Edge e, {Color? color}) {
  final path = Path();
  _appendEdgeToPath(path, e, forward: true, moveToStart: true);

  final paint = Paint()
    ..color = color ?? Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  canvas.drawPath(path, paint);

  // final dotPaint = Paint()
  //   ..color = Colors.red
  //   ..style = PaintingStyle.fill;

  // for (final knot in e.spline.knots) {
  //   canvas.drawCircle(Offset(knot.p.x, knot.p.y), 3, dotPaint);
  // }
}

const _kDrawDebugEdgeControlPoints = true;
void _drawDebugEdgeBezierParams(Canvas canvas, Edge e) {
  if (!_kDrawDebugEdgeControlPoints) return;

  final controlPointLinePaint = Paint()
    ..color = (const Color(0xFFFFFFFF).withValues(alpha: 0.5))
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.0;

  final controlPointDotPaint = Paint()
    ..color = (const Color(0xFFFFFFFF).withValues(alpha: 1.0))
    ..style = PaintingStyle.fill;

  for (final knot in e.spline.knots) {
    final p = knot.p;
    canvas.drawCircle(Offset(p.x, p.y), 3, controlPointDotPaint);

    final c1 = knot.c1;
    if (c1 != null) {
      canvas.drawLine(Offset(knot.p.x, knot.p.y), Offset(c1.x, c1.y), controlPointLinePaint);
      canvas.drawCircle(Offset(c1.x, c1.y), 2, controlPointDotPaint);
    }
    final c2 = knot.c2;
    if (c2 != null) {
      canvas.drawLine(Offset(knot.p.x, knot.p.y), Offset(c2.x, c2.y), controlPointLinePaint);
      canvas.drawCircle(Offset(c2.x, c2.y), 2, controlPointDotPaint);
    }
  }
}

void _drawDebugFace(Canvas canvas, Face f, {Color? color}) {
  final path = Path()..fillType = .evenOdd;

  for (final cycle in f.cycles.whereType<RegularCycle>()) {
    _appendCycleToPath(path, cycle);
  }

  final paint = Paint()
    ..color = color ?? _getDebugFaceColor()
    ..style = PaintingStyle.fill;

  canvas.drawPath(path, paint);
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
