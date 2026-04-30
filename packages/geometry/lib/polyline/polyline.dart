import 'package:vector_math/vector_math_64.dart';

part 'methods.dart';
part 'segment.dart';

class Polyline2 {
  Polyline2(this.points);

  Polyline2 copy() => Polyline2(List.from(points.map((p) => Vector2.copy(p))));
  Polyline2 reversed() => Polyline2(points.reversed.map((p) => Vector2.copy(p)).toList());

  final List<Vector2> points;

  int get length => points.length;

  bool get isEmpty => points.isEmpty;
  bool get isNotEmpty => points.isNotEmpty;

  Vector2 operator [](int index) => points[index];
  Vector2 get first => points.first;
  Vector2 get last => points.last;

  Aabb2 get bbox => _polylineBbox(this);
  Iterable<LineSegment2> get segments => _polylineSegments(this);
  Iterable<LineSegment2> get closedSegments => _polylineClosedSegments(this);

  double get area => signedArea.abs();
  double get signedArea => _polylineSignedArea(this);

  bool contains(Vector2 point) => _polylineContains(this, point);
  double get totalLength => _polylineLength(this);
  ClosestPointResult closestTo(Vector2 point) => _polylineClosestTo(this, point);

  Vector2 get leftmostPoint => _polylineLeftmost(this);

}
