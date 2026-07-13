import 'dart:ui';

import 'package:color/color.dart';
import 'package:flutter/foundation.dart';

class TransientStroke with ChangeNotifier {
  TransientStroke({
    this.color = .white,
    this.width = 1.0,
  });

  final ColorData color;
  final double width;

  var _length = 0;
  final _points = <Offset>[];
  final _rawPoints = <Offset>[];
  final _timestamps = <double>[];
  final _weights = <double>[];

  final _predictedPoints = <Offset>[];
  final _predictedWeights = <double>[];

  int get length => _length;
  List<Offset> get points => _points;
  List<Offset> get rawPoints => _rawPoints;
  List<double> get timestamps => _timestamps;
  List<double> get weights => _weights;

  Duration? _startTime;

  void addPoint(Offset point, {Offset? rawGlobalPoint, Duration? timestamp, double? weight}) {
    _startTime ??= timestamp;
    final double t;
    if (_startTime != null && timestamp != null) {
      t = (timestamp - _startTime!).inMicroseconds / 1000.0;
    } else {
      t = _length == 0 ? 0.0 : _timestamps[_length - 1];
    }

    _points.add(point);
    _rawPoints.add(rawGlobalPoint ?? point);
    _timestamps.add(t);
    _weights.add(weight ?? 1.0);
    _length++;

    notifyListeners();
  }

  void setPredictions(List<Offset> predictedPoints, List<double> predictedWeights) {
    _predictedPoints
      ..clear()
      ..addAll(predictedPoints);
    _predictedWeights
      ..clear()
      ..addAll(predictedWeights);

    notifyListeners();
  }

  Offset getPoint(int index) {
    if (index < _length) {
      return _points[index];
    } else {
      return _predictedPoints[index - _length];
    }
  }

  double getWeight(int index) {
    if (index < _length) {
      return _weights[index];
    } else {
      return _predictedWeights[index - _length];
    }
  }

  int get lengthWithPredictions => _length + _predictedPoints.length;
  List<Offset> get allPoints => [..._points, ..._predictedPoints];
  List<double> get allWeights => [..._weights, ..._predictedWeights];

  // void setPoint(int index, Offset point) {
  //   assert(index < length);

  //   final offset = index * 2;
  //   _storage[offset] = point.dx;
  //   _storage[offset + 1] = point.dy;

  //   notifyListeners();
  // }

  // void setWeight(int index, double weight) {
  //   assert(index < length);
  //   _weightsStorage[index] = weight;
  //   notifyListeners();
  // }
}
