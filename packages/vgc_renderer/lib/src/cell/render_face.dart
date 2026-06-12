part of '../render_cell.dart';

final class RenderFace extends RenderCell<Face> {
  RenderFace({required Face face}) : super(cell: face);
  Face get face => cell;

  @override
  void performLayout() {
    final bbox = face.boundingBoxApproximate;
    size = constraints.constrain(Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // final path = face.getPath().shift(offset);
    // final paint = Paint()
    //   ..style = .fill
    //   ..color = getFaceColor(face);

    // context.canvas.drawPath(path, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return null;
  }
}
