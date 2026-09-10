import 'package:editor/imports.dart';

final _fillPaint = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

Paint? _primaryPaint;
Paint _resolvePrimaryPaint(Color color) {
  if (_primaryPaint == null || _primaryPaint!.color != color) {
    _primaryPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
  }
  return _primaryPaint!;
}

Paint? _secondaryPaint;
Paint _resolveSecondaryPaint(Color color) {
  if (_secondaryPaint == null || _secondaryPaint!.color != color) {
    _secondaryPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
  }
  return _secondaryPaint!;
}

void paintVertexHandle(
  Canvas canvas,
  Offset position,
  Color primaryColor,
  Color secondaryColor,
) {
  canvas.drawCircle(position, 4.0, _resolvePrimaryPaint(primaryColor));
  canvas.drawCircle(position, 4.0, _fillPaint);
}

const _diamondSize = 4.0;
Path? _diamondPath;

void paintCovertexTangent(Canvas canvas, Offset vertex, Offset covertex, Color color) {
  final secondaryPaint = _resolveSecondaryPaint(color);
  canvas.drawLine(vertex, covertex, secondaryPaint);
}

void paintCovertexHandle(
  Canvas canvas,
  Offset covertex,
  Color primaryColor,
  Color secondaryColor,
) {
  _diamondPath ??= Path()
    ..moveTo(0, -_diamondSize)
    ..lineTo(_diamondSize, 0)
    ..lineTo(0, _diamondSize)
    ..lineTo(-_diamondSize, 0)
    ..close();

  final secondaryPaint = _resolveSecondaryPaint(secondaryColor);
  final path = _diamondPath!.shift(covertex);
  canvas.drawPath(path, secondaryPaint);
  canvas.drawPath(path, _fillPaint);
}

void paintEdgeHandle(
  Canvas canvas,
  Cubic2 cubic,
  Color color,
) {
  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final path = _cubicPath(cubic);
  canvas.drawPath(path, paint);
}

Path _cubicPath(Cubic2 cubic) {
  final path = Path();
  path.moveTo(cubic.p0.x, cubic.p0.y);
  path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
  return path;
}
