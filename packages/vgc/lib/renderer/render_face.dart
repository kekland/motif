part of 'render.dart';

final _faceColors = Colors.primaries;
Color getFaceColor(Face face) {
  final index = face.hashCode.abs() % _faceColors.length;
  return _faceColors[index].withValues(alpha: 0.25);
}

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
    final path = face.getPath().shift(offset);
    final paint = Paint()
      ..style = .fill
      ..color = getFaceColor(face);

    context.canvas.drawPath(path, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return null;
  }
}
