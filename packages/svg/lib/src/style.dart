part of '../svg.dart';

final class Style({
  final Paint? fill = const ColorPaint(color: .black),
  final FillRule fillRule = .nonZero,
  final Stroke? stroke,
});

enum FillRule { nonZero, evenOdd }

sealed class const Paint();

final class const ColorPaint({
  required final css.ColorData color,
}) extends Paint;

final class LinearGradientPaint({
  required final Point start,
  required final Point end,
  required final List<GradientStop> stops,
  final GradientUnits units = .objectBoundingBox,
  final Spread spread = .pad,
  final Transform transform = .identity,
}) extends Paint;

final class const RadialGradientPaint({
  required final Point center,
  required final double radius,
  required final Point focus,
  required final List<GradientStop> stops,
  final GradientUnits units = .objectBoundingBox,
  final Spread spread = .pad,
  final Transform transform = .identity,
}) extends Paint;

final class const GradientStop({
  required final css.ColorData color,
  required final double offset,
});

enum GradientUnits { userSpaceOnUse, objectBoundingBox }

enum Spread { pad, reflect, repeat }

final class const Stroke({
  required final Paint paint,
  final double width = 1.0,
  final LineCap lineCap = .butt,
  final LineJoin lineJoin = .miter,
  final double miterLimit = 4.0,
  final List<double> dashes = const [],
  final double dashOffset = 0.0,
});

enum LineCap { butt, round, square }

enum LineJoin { miter, round, bevel }
