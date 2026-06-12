part of '../render_cell.dart';

final class RenderVertex extends RenderCell<Vertex> {
  RenderVertex({required Vertex vertex}) : super(cell: vertex);
  Vertex get vertex => cell;

  @override
  void performLayout() {
    size = Size.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // final point = Offset(offset.dx + vertex.position.x, offset.dy + vertex.position.y);
    // final paint = Paint()
    //   ..style = .fill
    //   ..color = const Color(0xFFFF0000);

    // context.canvas.drawCircle(point, 4.0, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return _hitTestRenderVertex(this, position, tolerance.vertex);
  }
}

VertexHitTestEntry? _hitTestRenderVertex(RenderVertex render, Offset position, double tolerance) {
  final result = _hitTestVertexRaw(render.vertex, Vector2(position.dx, position.dy), tolerance);
  return result != null ? VertexHitTestEntry(render, distance: result, localPosition: render.vertex.position) : null;
}

double? _hitTestVertexRaw(Vertex v, Vector2 point, double tolerance) {
  final diff = (v.position - point)..absolute();
  final max = math.max(diff.x, diff.y);
  if (max > tolerance) return null;
  return max;
}
