part of 'polyline.dart';

extension type LineSegment2._((Vector2 start, Vector2 end) _) {
  LineSegment2(Vector2 a, Vector2 b) : this._((a, b));

  (Vector2, Vector2) get points => (start, end);

  Vector2 get start => _.$1;
  Vector2 get end => _.$2;

  Vector2 get direction => end - start;
  double get length => direction.length;

  SegmentClosestPointResult closestTo(Vector2 target) => _segmentClosestTo(start, end, target);
}
