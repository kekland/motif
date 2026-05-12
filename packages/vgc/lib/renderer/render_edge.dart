part of 'render.dart';

final class RenderEdge extends RenderCell<Edge> {
  RenderEdge({required Edge edge}) : super(cell: edge);
  Edge get edge => cell;

  @override
  void performLayout() {
    final bbox = edge.boundingBoxApproximate;
    size = Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // final spline = edge.spline;
    // final segments = spline.segments.toList();

    // context.canvas.save();
    // context.canvas.translate(offset.dx, offset.dy);

    // final paint1 = Paint()
    //   ..color = Colors.white
    //   ..style = .stroke
    //   ..strokeWidth = 4.0;

    // final paint2 = Paint()
    //   ..color = Colors.blue
    //   ..style = .stroke
    //   ..strokeWidth = 1.0;

    // for (final cubic in segments) {
    //   final quads = cubic.toQuads();

    //   for (final quad in quads) {
    //     paint1.color = Colors.primaries[quads.indexOf(quad) % Colors.primaries.length];

    //     final path = Path()
    //       ..moveTo(quad.p0.x, quad.p0.y)
    //       ..quadraticBezierTo(quad.p1.x, quad.p1.y, quad.p2.x, quad.p2.y);

    //     context.canvas.drawPath(path, paint1);
    //   }

    //   final path = Path()
    //     ..moveTo(cubic.p0.x, cubic.p0.y)
    //     ..cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);

    //   context.canvas.drawPath(path, paint2);
    // }

    // context.canvas.restore();

    // if (_program == null) return;

    // final transform = getTransformTo(null);
    // final scale = transform.getMaxScaleOnAxis();

    // final spline = edge.spline;
    // final segments = spline.segments.toList();
    // for (final cubic in segments) {
    //   final shader = _program!.fragmentShader();
    //   shader.setFloat(0, cubic.p0.x);
    //   shader.setFloat(1, cubic.p0.y);
    //   shader.setFloat(2, cubic.p1.x);
    //   shader.setFloat(3, cubic.p1.y);
    //   shader.setFloat(4, cubic.p2.x);
    //   shader.setFloat(5, cubic.p2.y);
    //   shader.setFloat(6, cubic.p3.x);
    //   shader.setFloat(7, cubic.p3.y);

    //   final halfWidth = 4.0 / 2.0;
    //   shader.setFloat(12, halfWidth);
    //   shader.setFloat(13, scale);

    //   final tightBbox = cubic.bboxTight;
    //   tightBbox.min.sub(.new(halfWidth, halfWidth));
    //   tightBbox.max.add(.new(halfWidth, halfWidth));

    //   shader.setFloat(8, tightBbox.min.x);
    //   shader.setFloat(9, tightBbox.min.y);
    //   shader.setFloat(10, tightBbox.max.x);
    //   shader.setFloat(11, tightBbox.max.y);

    //   final color = Colors.white;
    //   shader.setFloat(14, color.r);
    //   shader.setFloat(15, color.g);
    //   shader.setFloat(16, color.b);
    //   shader.setFloat(17, color.a);

    //   final paint = Paint()..shader = shader;
    //   final bounds = Rect.fromLTRB(tightBbox.min.x, tightBbox.min.y, tightBbox.max.x, tightBbox.max.y);

    //   context.canvas.save();
    //   context.canvas.translate(offset.dx, offset.dy);
    //   context.canvas.drawRect(bounds, paint);
    //   context.canvas.restore();
    // }
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return _hitTestRenderEdge(this, position, tolerance.edge);
  }

  @override
  void submitGeometry(TileGrid grid, double tolerance) {
    final spline = edge.spline;

    final segmentCount = spline.segmentCount;
    if (segmentCount == 0) return;

    final segments = spline.segments.toList();
    var strokeWeight = edge.strokeWeight;
    for (var i = 0; i < segmentCount; i++) {
      final segment = segments[i];
      final t0 = i / segmentCount;
      final t1 = (i + 1) / segmentCount;

      final segmentWeightProfile = strokeWeight?.splitMultiple([t0, t1])[1];
      for (final (quad, q0, q1) in segment.toQuads(tolerance: tolerance)) {
        final quadWeightProfile = segmentWeightProfile?.splitMultiple([q0, q1])[1];
        final maxWeight = quadWeightProfile?.max ?? 1.0;
        
        grid.addQuad(quad, maxWeight);
      }
    }
  }
}
