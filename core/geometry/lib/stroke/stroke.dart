import 'dart:math' as math;
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:geometry/geometry.dart';
import 'package:shared/shared.dart';

part 'fitter.dart';

final class StrokeData {
  StrokeData();

  static const int _baseSize = storageBaseSize;

  var _length = 0;
  int get length => _length;

  bool get isEmpty => _length == 0;
  bool get isNotEmpty => _length > 0;

  double get totalLength => _length > 0 ? _arcLength[_length - 1] : 0;

  Vec2List _point = .new(_baseSize);
  Float64List _timestamp = .new(_baseSize);
  Float64List _arcLength = .new(_baseSize);
  Float64List _pressure = .new(_baseSize);
  Float64List _tilt = .new(_baseSize);
  Float64List _orientation = .new(_baseSize);

  Vec2 point(int i) => _point[i];
  double arcLength(int i) => _arcLength[i];
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
    _arcLength[_length] = _length == 0 ? 0 : _arcLength[_length - 1] + point.distanceTo(_point[_length - 1]);
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
    _arcLength = _arcLength.grow(atLeast);
    _timestamp = _timestamp.grow(atLeast);
    _pressure = _pressure.grow(atLeast);
    _tilt = _tilt.grow(atLeast);
    _orientation = _orientation.grow(atLeast);
  }

  StrokeData copy() {
    final copy = StrokeData();
    copy._length = _length;
    copy._point = .fromList(_point);
    copy._timestamp = .fromList(_timestamp);
    copy._arcLength = .fromList(_arcLength);
    copy._pressure = .fromList(_pressure);
    copy._tilt = .fromList(_tilt);
    copy._orientation = .fromList(_orientation);
    return copy;
  }

  Float64List curvature({int window = 2}) {
    final k = Float64List(_length);
    if (_length <= 2 * window) return k;
    for (var i = window; i < _length - window; i++) {
      final a = _point[i] - _point[i - window], b = _point[i + window] - _point[i];
      final len = (a.length + b.length) / 2;
      k[i] = len == 0 ? 0 : math.atan2(a.cross(b), a.dot(b)) / len;
    }
    for (var i = 0; i < window; i++) k[i] = k[window];
    for (var i = _length - window; i < _length; i++) k[i] = k[_length - window - 1];
    return k;
  }

  StrokeData resampled(double spacing) {
    if (length < 2 || totalLength == 0) return copy();

    final total = totalLength;
    final n = math.max(1, (total / spacing).round());
    final step = total / n;
    final out = StrokeData();

    var k = 0;
    for (var m = 0; m <= n; m++) {
      final target = m == n ? total : m * step;
      while (k < length - 2 && arcLength(k + 1) < target) k++;
      final span = arcLength(k + 1) - arcLength(k);
      final t = span == 0.0 ? 0.0 : (target - arcLength(k)) / span;
      out.add(
        point: Vec2.lerp(point(k), point(k + 1), t),
        timestamp: lerp(timestamp(k), timestamp(k + 1), t),
        pressure: _lerpSafe(pressure(k), pressure(k + 1), t),
        tilt: _lerpSafe(tilt(k), tilt(k + 1), t),
        orientation: _lerpSafe(orientation(k), orientation(k + 1), t),
      );
    }

    return out;
  }

  double _lerpSafe(double a, double b, double t) {
    if (a == -1 || b == -1) return -1;
    return lerp(a, b, t);
  }
}
