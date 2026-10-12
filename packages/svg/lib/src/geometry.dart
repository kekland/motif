part of '../svg.dart';

sealed class const Geometry();

final class const Rect({
  required final double x,
  required final double y,
  required final double width,
  required final double height,
  final double rx = 0.0,
  final double ry = 0.0,
}) extends Geometry;

final class const Ellipse({
  required final double cx,
  required final double cy,
  required final double rx,
  required final double ry,
}) extends Geometry;

final class const Path(final List<PathSegment> segments) extends Geometry;

sealed class const PathSegment();

final class const MoveTo(final Point to) extends PathSegment;
final class const LineTo(final Point to) extends PathSegment;
final class const QuadraticTo(final Point control, final Point to) extends PathSegment;
final class const CubicTo(final Point c1, final Point c2, final Point to) extends PathSegment;
final class const ArcTo({
  required final double rx,
  required final double ry,
  required final double rotation,
  required final bool largeArc,
  required final bool sweep,
  required final Point to,
}) extends PathSegment;
final class const Close() extends PathSegment;
