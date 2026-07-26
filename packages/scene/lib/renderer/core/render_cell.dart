part of 'core.dart';

class RenderCellWidget extends LeafRenderObjectWidget {
  const RenderCellWidget({super.key, required this.cell});

  final Cell cell;

  @override
  RenderCell createRenderObject(BuildContext context) {
    return .from(cell);
  }

  @override
  void updateRenderObject(BuildContext context, RenderCell renderObject) {
    renderObject.cell = cell;
  }
}

sealed class RenderCell<C extends Cell> extends RenderSceneNode<C> {
  RenderCell({required C cell}) : super(node: cell);

  static RenderCell from(Cell c) => switch (c) {
    Vertex v => RenderVertex(vertex: v),
    Edge e => RenderEdge(edge: e),
  };

  C get cell => node;
  set cell(C value) => node = value;

  @override
  void paint(PaintingContext context, Offset offset) {
    final transform = Matrix4.identity();
    applyPaintTransform(this, transform);
    
    context.canvas.save();
    final canvasTrasform = Matrix4.fromFloat64List(context.canvas.getTransform());
    final inverseCanvasTransform = Matrix4.inverted(canvasTrasform);
    context.canvas.translate(offset.dx, offset.dy);
    context.canvas.transform(inverseCanvasTransform.storage);
    debugPaintCell(context, canvasTrasform * transform);
    context.canvas.restore();
  }

  void debugPaintCell(PaintingContext context, Matrix4 transform) {}

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}

final class RenderVertex extends RenderCell<Vertex> {
  RenderVertex({required Vertex vertex}) : super(cell: vertex);

  @override
  Rect get boundingBox => cell.position.offset & .zero;

  @override
  void performLayout() {
    size = .zero;
    _maybeSortChildrenList();
  }

  @override
  void debugPaintCell(PaintingContext context, Matrix4 transform) {
    final paint = Paint()
      ..color = .new(0xFFFF0000)
      ..style = .fill;

    final p = transform.transform2(cell.position);
    context.canvas.drawCircle(p.offset, 4.0, paint);
  }
}

final class RenderEdge extends RenderCell<Edge> {
  RenderEdge({required Edge edge}) : super(cell: edge);

  @override
  Rect get boundingBox => cell.bbox.asRect;

  @override
  void performLayout() {
    size = .zero;
    _maybeSortChildrenList();
  }

  @override
  void debugPaintCell(PaintingContext context, Matrix4 transform) {
    final paint = Paint()
      ..color = .new(0xFF00FF00)
      ..style = .stroke
      ..strokeWidth = 1.0;

    final controlPointPaint = Paint()
      ..color = .new(0xFF0000FF)
      ..style = .fill;

    final cubics = cell.path.segments.toList();
    final cubicCount = cubics.length;
    if (cubicCount == 0) return;

    final path = Path();
    var cubic = cubics.first;
    var point = transform.transform2(cubic.p0);
    path.moveTo(point.x, point.y);

    for (var i = 0; i < cubicCount; i++) {
      cubic = cubics[i];
      final p1 = transform.transform2(cubic.p1);
      final p2 = transform.transform2(cubic.p2);
      final p3 = transform.transform2(cubic.p3);

      context.canvas.drawCircle(p1.offset, 2.0, controlPointPaint);
      context.canvas.drawCircle(p2.offset, 2.0, controlPointPaint);

      path.cubicTo(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }

    context.canvas.drawPath(path, paint);
  }
}
