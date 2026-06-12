part of '../controller.dart';

class TransientStrokes with ChangeNotifier, ChangeNotifierDisposable {
  TransientStrokes(this.controller);

  final VectorController controller;

  final _strokes = <TransientStroke>[];
  Iterable<TransientStroke> get strokes => _strokes;

  TransientStroke create({Offset? point, Offset? rawGlobalPoint, Duration? timestamp, double? weight}) {
    final strokeProperties = controller.strokeProperties;

    final stroke = TransientStroke(width: strokeProperties.width, color: strokeProperties.color);
    if (point != null) {
      stroke.addPoint(
        point,
        timestamp: timestamp,
        rawGlobalPoint: rawGlobalPoint,
        weight: weight,
      );
    }

    _strokes.add(stroke);
    notifyListeners();

    return stroke;
  }

  void remove(TransientStroke stroke) {
    _strokes.remove(stroke);
    notifyListeners();
  }
}
