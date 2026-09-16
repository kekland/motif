import 'package:geometry/geometry.dart';

enum EventType { down, move, up }

extension type const Time(double seconds) implements double {
  static const Time zero = .new(0.0);

  TimeSpan operator -(Time other) => .new(seconds - other.seconds);
  Time add(TimeSpan duration) => .new(seconds + duration.seconds);
  Time subtract(TimeSpan duration) => .new(seconds - duration.seconds);
}

extension type const TimeSpan(double seconds) implements double {
  static const TimeSpan zero = .new(0.0);

  bool get isZero => seconds == 0.0;
  TimeSpan operator +(TimeSpan other) => .new(seconds + other.seconds);
  TimeSpan operator -(TimeSpan other) => .new(seconds - other.seconds);
}

final class Input {
  const new({
    required this.eventType,
    required this.position,
    required this.time,
    this.pressure,
    this.tilt,
    this.orientation,
  });

  final EventType eventType;
  final Vec2 position;
  final Time time;
  final double? pressure;
  final double? tilt;
  final double? orientation;

  @override
  int get hashCode => Object.hash(eventType, position.x, position.y, time, pressure, tilt, orientation);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Input) return false;
    return eventType == other.eventType &&
        position.x == other.position.x &&
        position.y == other.position.y &&
        time == other.time &&
        pressure == other.pressure &&
        tilt == other.tilt &&
        orientation == other.orientation;
  }
}

final class Result {
  new({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.time,
    this.pressure,
    this.tilt,
    this.orientation,
  });

  final Vec2 position;
  final Vec2 velocity;
  final Vec2 acceleration;
  final Time time;
  final double? pressure;
  final double? tilt;
  final double? orientation;

  Result copyWith({
    Vec2? position,
    Vec2? velocity,
    Vec2? acceleration,
    Time? time,
    double? pressure,
    double? tilt,
    double? orientation,
    bool unknownPressure = false,
    bool unknownTilt = false,
    bool unknownOrientation = false,
  }) => .new(
    position: position ?? this.position,
    velocity: velocity ?? this.velocity,
    acceleration: acceleration ?? this.acceleration,
    time: time ?? this.time,
    pressure: unknownPressure ? null : (pressure ?? this.pressure),
    tilt: unknownTilt ? null : (tilt ?? this.tilt),
    orientation: unknownOrientation ? null : (orientation ?? this.orientation),
  );
}

final class TipState {
  new({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.time,
  });

  final Vec2 position;
  final Vec2 velocity;
  final Vec2 acceleration;
  final Time time;
}

final class StylusState {
  const new({
    this.pressure,
    this.tilt,
    this.orientation,
  });

  final double? pressure;
  final double? tilt;
  final double? orientation;
}
