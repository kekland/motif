import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import '../../renderer.dart';

void debugPaintCell(
  ui.Canvas canvas,
  Cell cell,
  Matrix4 transform,
  CellHitTestEntry? hitTest,
) {
  final _ = switch (cell) {
    Vertex v => debugPaintVertex(canvas, v, transform, hitTest as VertexHitTestEntry?),
    Edge e => debugPaintEdge(canvas, e, transform, hitTest as EdgeHitTestEntry?),
  };

  if (hitTest != null) {
    final position = hitTest.localPosition;
    canvas.drawCircle(
      MatrixUtils.transformPoint(transform, .new(position.dx, position.dy)),
      4.0,
      ui.Paint()
        ..color = const ui.Color(0xFFFF0000)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}

ui.Color __color(bool hit, ui.Color c) => hit ? const ui.Color(0xFFFF0000) : c;

ui.Paint _vertexPaint(bool hit) => ui.Paint()
  ..color = __color(hit, ui.Color(0xFF00FF00))
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

Offset _transformed(Vector2 p, Matrix4 t) => MatrixUtils.transformPoint(t, .new(p.x, p.y));

const bool _kDebugPaintVertexPosition = false;
final _localPainter = TextPainter(textDirection: .ltr);

void debugPaintVertex(ui.Canvas canvas, Vertex vertex, Matrix4 transform, VertexHitTestEntry? hitTest) {
  final position = vertex.position;

  canvas.drawCircle(
    _transformed(position, transform),
    8.0,
    _vertexPaint(hitTest != null),
  );

  if (_kDebugPaintVertexPosition) {
    _localPainter.text = TextSpan(
      text: '(${position.x.toStringAsFixed(1)}, ${position.y.toStringAsFixed(1)})',
      style: const TextStyle(color: ui.Color(0xFF777777), fontSize: 8.0),
    );

    _localPainter.layout();
    _localPainter.paint(canvas, _transformed(position, transform) + const Offset(2.0, 2.0));
  }
}

ui.Paint _edgePathPaint(bool hit) => ui.Paint()
  ..color = __color(hit, const ui.Color(0xFF00AAFF))
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

ui.Paint get _edgeKnotPaint => ui.Paint()
  ..color = const ui.Color(0xFFFFFF00)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

ui.Paint get _edgeKnotControlPointPaint => ui.Paint()
  ..color = const ui.Color(0xFFFF00FF)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

ui.Paint get _edgeKnotControlPointLinePaint => ui.Paint()
  ..color = const ui.Color(0xFF888888)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 0.0;

void _debugPaintEdgeKnot(ui.Canvas canvas, CubicKnot2 knot, Matrix4 transform) {
  // diamond at knots
  final p = knot.p;
  final _p = _transformed(p, transform);

  canvas.drawCircle(_p, 2.0, _edgeKnotPaint);

  if (_kDebugPaintEdgeKnotControlPoints) {
    // circle at control points
    final cIn = knot.cIn;
    if (cIn != null) {
      final _cIn = _transformed(cIn, transform);
      canvas.drawLine(_p, _cIn, _edgeKnotControlPointLinePaint);
      canvas.drawCircle(_cIn, 2.0, _edgeKnotControlPointPaint);
    }

    final cOut = knot.cOut;
    if (cOut != null) {
      final _cOut = _transformed(cOut, transform);
      canvas.drawLine(_p, _cOut, _edgeKnotControlPointLinePaint);
      canvas.drawCircle(_cOut, 2.0, _edgeKnotControlPointPaint);
    }
  }
}

const double? _kDebugPaintEdgeSimplified = null;
const bool _kDebugPaintEdgeBbox = false;
const bool _kDebugPaintEdgeKnotControlPoints = true;

ui.Paint get _edgeSimplifiedPaint => ui.Paint()
  ..color = const ui.Color(0xFFFF0000)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

ui.Paint get _edgeBboxPaint => ui.Paint()
  ..color = const ui.Color(0xFF888888)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

void debugPaintEdge(ui.Canvas canvas, Edge edge, Matrix4 transform, EdgeHitTestEntry? hitTest) {
  final path = edge.path;

  var current = path.knots.first;

  final uiPath = ui.Path();
  uiPath.moveTo(current.p.x, current.p.y);
  for (final knot in path.knots.skip(1)) {
    final currentOut = current.cOut ?? current.p;
    final knotIn = knot.cIn ?? knot.p;
    uiPath.cubicTo(currentOut.x, currentOut.y, knotIn.x, knotIn.y, knot.p.x, knot.p.y);
    current = knot;
  }

  canvas.drawPath(uiPath.transform(transform.storage), _edgePathPaint(hitTest != null));

  for (final knot in path.knots) {
    _debugPaintEdgeKnot(canvas, knot, transform);
  }

  if (_kDebugPaintEdgeSimplified != null) {
    final simplified = path.flatten(tolerance: _kDebugPaintEdgeSimplified).$1;
    final simplifiedPath = ui.Path();

    simplifiedPath.moveTo(simplified.points.first.x, simplified.points.first.y);
    for (final point in simplified.points.skip(1)) {
      simplifiedPath.lineTo(point.x, point.y);
    }

    canvas.drawPath(simplifiedPath.transform(transform.storage), _edgeSimplifiedPaint);
  }

  if (_kDebugPaintEdgeBbox) {
    final bbox = edge.bbox;
    final bboxPath = ui.Path()..addRect(ui.Rect.fromLTRB(bbox.min.x, bbox.min.y, bbox.max.x, bbox.max.y));

    canvas.drawPath(bboxPath.transform(transform.storage), _edgeBboxPaint);
  }

  if (hitTest != null) {
    final t = hitTest.t;
    final position = path.point(t);

    canvas.drawCircle(_transformed(position, transform), 4.0, ui.Paint()..color = const ui.Color(0xFFFF0000));
  }
}

ui.Paint get _debugPaintTransientStrokePaint => ui.Paint()
  ..color = const ui.Color(0xFF0000FF)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

ui.Paint get _debugPaintTransientStrokePointPaint => ui.Paint()
  ..color = const ui.Color(0xFF00FFFF)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

void debugPaintTransientStroke(ui.Canvas canvas, TransientStroke stroke, Matrix4 transform) {
  final points = stroke.points;
  if (points.length < 2) return;

  final path = ui.Path()..moveTo(points.first.dx, points.first.dy);
  for (final point in points.skip(1)) {
    path.lineTo(point.dx, point.dy);
  }

  canvas.drawPath(path.transform(transform.storage), _debugPaintTransientStrokePaint);

  for (final point in points) {
    canvas.drawCircle(
      _transformed(Vector2(point.dx, point.dy), transform),
      2.0,
      _debugPaintTransientStrokePointPaint,
    );
  }
}

final _geometryPaint = ui.Paint()
  ..color = const ui.Color(0xFFABABAB)
  ..style = ui.PaintingStyle.stroke
  ..strokeWidth = 1.0;

void debugPaintCellGeometry(
  ui.Canvas canvas,
  Cell cell,
  Matrix4 transform,
) => switch (cell) {
  Vertex v => debugPaintVertexGeometry(canvas, v, transform),
  Edge e => debugPaintEdgeGeometry(canvas, e, transform),
};

void debugPaintVertexGeometry(
  ui.Canvas canvas,
  Vertex vertex,
  Matrix4 transform,
) {
  final position = vertex.position;
  canvas.drawCircle(_transformed(position, transform), 8.0, _geometryPaint);
}

void debugPaintEdgeGeometry(
  ui.Canvas canvas,
  Edge edge,
  Matrix4 transform,
) {
  final path = edge.path;

  var current = path.knots.first;

  final uiPath = ui.Path();
  uiPath.moveTo(current.p.x, current.p.y);
  for (final knot in path.knots.skip(1)) {
    final currentOut = current.cOut ?? current.p;
    final knotIn = knot.cIn ?? knot.p;
    uiPath.cubicTo(currentOut.x, currentOut.y, knotIn.x, knotIn.y, knot.p.x, knot.p.y);
    current = knot;
  }

  canvas.drawPath(uiPath.transform(transform.storage), _geometryPaint);
}
