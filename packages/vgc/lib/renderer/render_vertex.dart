part of 'render.dart';

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
