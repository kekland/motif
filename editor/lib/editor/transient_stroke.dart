part of '../editor.dart';

final class TransientStrokes with ChangeNotifier, ChangeNotifierDisposable {
  TransientStrokes(this.editor);
  final Editor editor;

  final _instances = <TransientStroke>[];
  Iterable<TransientStroke> get instances => _instances;

  TransientStroke create() {
    final stroke = TransientStroke();
    _instances.add(stroke);
    notifyListeners();
    return stroke;
  }

  void remove(TransientStroke stroke) {
    _instances.remove(stroke);
    notifyListeners();
  }
}

final class TransientStroke extends ChangeNotifier {
  TransientStroke({
    this.style = .default_,
  }) : data = .new(),
       predictions = .new();

  final EdgeStyle style;
  final StrokeData data;
  final StrokeData predictions;

  void onChanged() => notifyListeners();
}

final class StrokeData {
  StrokeData();

  static const int _baseSize = 8;

  var _length = 0;
  int get length => _length;

  bool get isEmpty => _length == 0;
  bool get isNotEmpty => _length > 0;

  Vec2List _point = .new(_baseSize);
  Float64List _timestamp = .new(_baseSize);
  Float64List _pressure = .new(_baseSize);
  Float64List _tilt = .new(_baseSize);
  Float64List _orientation = .new(_baseSize);

  Vec2 point(int i) => _point[i];
  double timestamp(int i) => _timestamp[i];
  double pressure(int i) => _pressure[i];
  double tilt(int i) => _tilt[i];
  double orientation(int i) => _orientation[i];

  void add({
    required Vec2 point,
    required double timestamp,
    double? pressure,
    double? tilt,
    double? orientation,
  }) {
    _grow(_length + 1);
    _point[_length] = point;
    _timestamp[_length] = timestamp;
    _pressure[_length] = pressure ?? -1;
    _tilt[_length] = tilt ?? -1;
    _orientation[_length] = orientation ?? -1;
    _length++;
  }

  void clear() {
    _length = 0;
  }

  void _grow(int atLeast) {
    if (_point.length >= atLeast) return;
    _point = _point.grow(atLeast);
    _timestamp = _timestamp.grow(atLeast);
    _pressure = _pressure.grow(atLeast);
    _tilt = _tilt.grow(atLeast);
    _orientation = _orientation.grow(atLeast);
  }
}
