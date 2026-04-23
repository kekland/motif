part of '../controller.dart';

class TransientStroke with ChangeNotifier {
  TransientStroke();

  var _storage = Float32List(2);
  var _rawGlobalStorage = Float32List(2);
  var _timestampStorage = Float32List(1);

  Float32List get points => Float32List.sublistView(_storage, 0, length * 2);
  Float32List get rawGlobalPoints => Float32List.sublistView(_rawGlobalStorage, 0, length * 2);
  Float32List get timestamps => Float32List.sublistView(_timestampStorage, 0, length);

  int _length = 0;
  Duration? _startTime;

  int get length => _length;
  int get capacity => _storage.length ~/ 2;

  void _extend() {
    _storage = _storage.extended();
    _rawGlobalStorage = _rawGlobalStorage.extended();
    _timestampStorage = _timestampStorage.extended();
  }

  Offset getPoint(int index) {
    assert(index < length);

    final offset = index * 2;
    return Offset(_storage[offset], _storage[offset + 1]);
  }

  Offset getRawPoint(int index) {
    assert(index < length);

    final offset = index * 2;
    return Offset(_rawGlobalStorage[offset], _rawGlobalStorage[offset + 1]);
  }

  double getTimestamp(int index) {
    assert(index < length);
    return _timestampStorage[index];
  }

  void addPoint(Offset point, {Offset? rawGlobalPoint, Duration? timestamp}) {
    if (_length == capacity) _extend();

    _startTime ??= timestamp;
    final double t;
    if (_startTime != null && timestamp != null) {
      t = (timestamp - _startTime!).inMicroseconds / 1000.0;
    } else {
      t = _length == 0 ? 0.0 : _timestampStorage[_length - 1];
    }

    final offset = _length * 2;

    _storage[offset] = point.dx;
    _storage[offset + 1] = point.dy;
    _rawGlobalStorage[offset] = rawGlobalPoint?.dx ?? point.dx;
    _rawGlobalStorage[offset + 1] = rawGlobalPoint?.dy ?? point.dy;

    _timestampStorage[_length] = t;
    _length++;

    notifyListeners();
  }

  void setPoint(int index, Offset point) {
    assert(index < length);

    final offset = index * 2;
    _storage[offset] = point.dx;
    _storage[offset + 1] = point.dy;

    notifyListeners();
  }
}

class TransientStrokes with ChangeNotifier, ChangeNotifierDisposable {
  final _strokes = <TransientStroke>[];
  Iterable<TransientStroke> get strokes => _strokes;

  TransientStroke create({Offset? point, Offset? rawGlobalPoint, Duration? timestamp}) {
    final stroke = TransientStroke();
    if (point != null) stroke.addPoint(point, timestamp: timestamp, rawGlobalPoint: rawGlobalPoint);

    _strokes.add(stroke);
    notifyListeners();

    return stroke;
  }

  void remove(TransientStroke stroke) {
    _strokes.remove(stroke);
    notifyListeners();
  }
}

extension _Float32ListExtend on Float32List {
  Float32List extended() {
    final newList = Float32List(length * 2);
    newList.setAll(0, this);
    return newList;
  }
}
