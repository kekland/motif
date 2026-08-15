import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

const _kFrictionCoefficient = 0.0000235;

// Extracted from interactive_viewer.dart
double _getFinalTime(double velocity, double drag, {double effectivelyMotionless = 10}) {
  return math.log(effectivelyMotionless / velocity) / math.log(drag / 100);
}

class Fling {
  static (Animatable<Offset>, Duration) twoD(
    Offset position,
    Velocity velocity, {
    double frictionCoefficient = _kFrictionCoefficient,
  }) {
    final x = FrictionSimulation(frictionCoefficient, position.dx, velocity.pixelsPerSecond.dx);
    final y = FrictionSimulation(frictionCoefficient, position.dy, velocity.pixelsPerSecond.dy);

    final time = _getFinalTime(velocity.pixelsPerSecond.distance, frictionCoefficient);
    final duration = Duration(milliseconds: (time * 1000).round());

    final tween = Tween(begin: position, end: Offset(x.x(time), y.x(time))).chain(CurveTween(curve: Curves.decelerate));
    return (tween, duration);
  }

  static (Animatable<double>, Duration) oneD(
    double position,
    double velocity, {
    double frictionCoefficient = _kFrictionCoefficient,
  }) {
    final simulation = FrictionSimulation(frictionCoefficient, position, velocity);

    final time = _getFinalTime(velocity.abs(), frictionCoefficient, effectivelyMotionless: 0.1);
    final duration = Duration(milliseconds: (time * 1000).round());

    final tween = Tween(begin: position, end: simulation.x(time)).chain(CurveTween(curve: Curves.decelerate));
    return (tween, duration);
  }
}
