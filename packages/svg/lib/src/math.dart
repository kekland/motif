part of '../svg.dart';

final class const Point(final double x, final double y);

final class const Transform(
  final double a,
  final double b,
  final double c,
  final double d,
  final double e,
  final double f,
) {
  static const identity = Transform(1, 0, 0, 1, 0, 0);
}
