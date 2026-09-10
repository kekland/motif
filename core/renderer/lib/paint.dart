import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:color/color_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:renderer/renderer.dart';

List<DrawEntry> paintFrame(Evaluation e, FrameHandle frame, int depth) {
  final bundle = e.bundle;
  final entries = <DrawEntry>[];
  final paints = <CellStyle, ui.Paint>{};

  ui.PictureRecorder? recorder;
  ui.Canvas? canvas;

  Canvas open() {
    recorder ??= ui.PictureRecorder();
    canvas ??= ui.Canvas(recorder!);
    return canvas!;
  }

  void flush() {
    if (recorder == null) return;
    entries.add(DrawPicture(recorder!.endRecording()));
    recorder = null;
    canvas = null;
  }

  final edgePath = Path();
  final facePath = Path()..fillType = .nonZero;
  EdgeStyle? strokeStyle;

  void flushStroke() {
    if (strokeStyle == null) return;
    open().drawPath(
      edgePath,
      paints.putIfAbsent(
        strokeStyle!,
        () => ui.Paint()
          ..style = .stroke
          ..color = strokeStyle!.color.toUiColor()
          ..strokeCap = .square
          ..strokeWidth = strokeStyle!.width,
      ),
    );

    edgePath.reset();
    strokeStyle = null;
  }

  for (final (ref, h) in e.drawOrder.of(frame)) {
    switch (ref.kind) {
      case .frame:
        {
          flushStroke();
          flush();
          entries.add(DrawFrame(h.asFrame));
        }

      case .vertex:
        {
          // final p = bundle.vertexPosition(h.asVertex);
          // final style = e.styleOf(ref).asVertex;
          // final paint = ui.Paint()
          //   ..color = style.color.toUiColor()
          //   ..style = .fill;

          // open().drawCircle(Offset(p.x, p.y), style.radius, paint);
        }

      case .edge:
        {
          final style = e.style.of(ref)!.asEdge;
          if (style != strokeStyle) {
            flushStroke();
            strokeStyle = style;
          }

          _addCubicPath(edgePath, bundle.edgeCubic(h.asEdge));
        }

      case .face:
        {
          flushStroke();
          _addFacePath(bundle, facePath, h.asFace);
          final style = e.style.of(ref)!.asFace;

          final paint = ui.Paint()
            ..style = .fill
            ..color = style.color.toUiColor();

          open().drawPath(facePath, paint);
          facePath.reset();
        }
    }
  }

  flushStroke();
  flush();
  return entries;
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
