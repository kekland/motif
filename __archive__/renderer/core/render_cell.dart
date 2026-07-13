part of 'core.dart';

sealed class RenderCell<C extends Cell> extends RenderSceneObject {
  RenderCell({required C super.object});

  static RenderCell from(Cell c) => switch (c) {
    Vertex v => RenderVertex(object: v),
    Edge e => RenderEdge(object: e),
  };

  // dart format off
  @override C get object => super.object as C;
  @override set object(C value) => super.object = value;
  // dart format on

  CellHitTestEntry? hitTestCell(Offset position);
  CellHitTestEntry? hitTestCellRect(Rect rect, {ObjectHitTestRectMode mode = .normal}) => null;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final entry = hitTestCell(position);
    if (entry != null) {
      result.add(entry);
      return true;
    }
    return false;
  }

  @override
  bool objectHitTestRect(SceneObjectHitTestResult result, {required Rect rect, ObjectHitTestRectMode mode = .normal}) {
    final entry = hitTestCellRect(rect, mode: mode);
    if (entry != null) {
      result.add(entry);
      return true;
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    final transform = Matrix4.fromFloat64List(context.canvas.getTransform());
    final inverse = Matrix4.inverted(transform);
    context.canvas.translate(offset.dx, offset.dy);
    context.canvas.transform(inverse.storage);
    debugPaintCell(context, transform);
    context.canvas.restore();
  }

  void debugPaintCell(PaintingContext context, Matrix4 transform) {}
}

final class RenderVertex extends RenderCell<Vertex> {
  RenderVertex({required super.object});

  @override
  void debugPaintCell(PaintingContext context, Matrix4 transform) {
    final paint = Paint()
      ..color = .new(0xFFFF0000)
      ..style = .fill;

    final p = transform.transform2(.zero());
    context.canvas.drawCircle(p.offset, 4.0, paint);
  }

  @override
  VertexHitTestEntry? hitTestCell(Offset position) => hitTestVertex(this, position);

  @override
  VertexHitTestEntry? hitTestCellRect(
    Rect rect, {
    ObjectHitTestRectMode mode = .normal,
  }) => rectHitTestVertex(this, rect);
}

final class RenderEdge extends RenderCell<Edge> {
  RenderEdge({required super.object});

  @override
  void debugPaintCell(PaintingContext context, Matrix4 transform) {
    final paint = Paint()
      ..color = .new(0xFF00FF00)
      ..style = .stroke
      ..strokeWidth = 1.0;

    final p1 = transform.transform2(object.start.position);
    final p2 = transform.transform2(object.end.position);
    context.canvas.drawLine(p1.offset, p2.offset, paint);
  }

  @override
  EdgeHitTestEntry? hitTestCell(Offset position) => hitTestEdge(this, position);

  @override
  EdgeHitTestEntry? hitTestCellRect(
    Rect rect, {
    ObjectHitTestRectMode mode = .normal,
  }) => rectHitTestEdge(this, rect, mode: mode);
}
