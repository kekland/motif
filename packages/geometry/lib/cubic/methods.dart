part of 'cubic.dart';

typedef FlattenResult = (
  List<Vector2> points,
  List<double> t,
);

FlattenResult _flattenCubicWithResult(Vector2 a, Vector2 c1, Vector2 c2, Vector2 b, double tolerance) {
  final points = <Vector2>[];
  final tValues = <double>[];

  _flattenCubic(a, c1, c2, b, tolerance, (point, t) {
    points.add(point);
    tValues.add(t);
  });

  return (points, tValues);
}

void _flattenCubic(
  Vector2 a,
  Vector2 c1,
  Vector2 c2,
  Vector2 b,
  double tolerance,
  void Function(Vector2, double) callback,
) {
  callback(a, 0.0);

  const _maxDepth = 24;
  void recurse(Vector2 a, Vector2 b, Vector2 c, Vector2 d, double t0, double t1, int depth) {
    if (depth >= _maxDepth || _isFlatEnough(a, b, c, d, tolerance)) {
      callback(d, t1);
      return;
    }

    final m01 = (a + b) * 0.5;
    final m12 = (b + c) * 0.5;
    final m23 = (c + d) * 0.5;
    final m012 = (m01 + m12) * 0.5;
    final m123 = (m12 + m23) * 0.5;
    final m0123 = (m012 + m123) * 0.5;
    final tm = (t0 + t1) * 0.5;
    recurse(a, m01, m012, m0123, t0, tm, depth + 1);
    recurse(m0123, m123, m23, d, tm, t1, depth + 1);
  }

  recurse(a, c1, c2, b, 0.0, 1.0, 0);
}

bool _isFlatEnough(Vector2 a, Vector2 b, Vector2 c, Vector2 d, double tolerance) {
  final chord = d - a;
  final length = chord.length;
  if (length < 1e-9) return b.distanceTo(a) <= tolerance && c.distanceTo(a) <= tolerance;

  final nx = -chord.y / length;
  final ny = chord.x / length;
  final db = ((b.x - a.x) * nx + (b.y - a.y) * ny).abs();
  final dc = ((c.x - a.x) * nx + (c.y - a.y) * ny).abs();
  return db <= tolerance && dc <= tolerance;
}

Vector2 _lerpVector2(Vector2 a, Vector2 b, double t) => .new(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
