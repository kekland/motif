import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';

ui.Picture paintFrame(Bundle bundle, FrameHandle frame, int depth) {
  // print('repainting frame ${frame.ref(bundle)}');
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final edges = Path();
  final vertices = <Offset>[];

  for (final child in bundle.frameChildren(frame)) {
    final kind = child.kind;

    if (kind == .vertex) {
      final p = bundle.vertexPosition(child.asVertex);
      vertices.add(Offset(p.x, p.y));
    } else if (kind == .edge) {
      _addCubicPath(edges, bundle.edgeCubic(child.asEdge));
    } else if (kind == .face) {
      final path = Path()..fillType = .nonZero;
      _addFacePath(bundle, path, child.asFace);

      final paint = Paint()
        ..shader = hatchShader(
          color: Colors.primaries[child.index.i % Colors.primaries.length].withValues(alpha: 0.5),
          depth: depth,
        );
      canvas.drawPath(path, paint);
    }
  }

  final vertexPaint = Paint()
    ..color = Colors.blueGrey
    ..strokeWidth = 4.0
    ..strokeCap = .round
    ..style = .fill;

  final edgePaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1.0
    ..style = .stroke;

  canvas.drawPath(edges, edgePaint);
  canvas.drawPoints(ui.PointMode.points, vertices, vertexPaint);
  return recorder.endRecording();
}

void _addCubicPath(Path path, Cubic2 c) {
  path.moveTo(c.p0.x, c.p0.y);
  path.cubicTo(c.p1.x, c.p1.y, c.p2.x, c.p2.y, c.p3.x, c.p3.y);
}

void _addFacePath(Bundle bundle, Path path, FaceHandle f) {
  final space = bundle.parentOf(f)!;

  for (final cycle in bundle.faceBoundary(f)) {
    var first = true;
    for (final u in cycle) {
      var cubic = bundle.edgeCubic(u.edge, space: space);
      if (!u.forward) cubic = cubic.reversed();

      if (first) {
        path.moveTo(cubic.p0.x, cubic.p0.y);
        first = false;
      }

      path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
    }

    path.close();
  }
}

ui.Shader hatchShader({
  double spacing = 12,
  double strokeWidth = 1,
  ui.Color color = const ui.Color(0x80FFFFFF),
  double feather = 0.0,
  int depth = 0,
}) {
  final d = spacing / math.sqrt2;
  final on = strokeWidth / spacing, f = feather / spacing;

  final from = depth.isEven ? Offset.zero : Offset(d, 0);
  final to = depth.isEven ? Offset(d, d) : Offset(0, d);

  return ui.Gradient.linear(
    from,
    to,
    [color, color, color.withAlpha(0), color.withAlpha(0), color],
    [0, math.max(0, on - f), math.min(1, on + f), 1 - f, 1],
    .repeated,
  );
}
