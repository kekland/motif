import 'package:vector_math/vector_math_64.dart';

class StrokePoint {
  StrokePoint({
    required this.position,
    required this.pressure,
    required this.timestamp,
  });

  final Vector2 position;
  final double pressure;
  final Duration timestamp;
}
