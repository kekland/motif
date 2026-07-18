import 'dart:math' as math;

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';

double perpendicularDistance(Vector2 p, Vector2 a, Vector2 b) {
  final d = b - a;
  final len = d.length;
  if (len < 1e-9) return p.distanceTo(a);
  return ((p.x - a.x) * (-d.y) + (p.y - a.y) * d.x).abs() / len;
}

extension Aabb2Utils on Aabb2 {
  // double signedDistanceTo(Vector2 p) {
  //   final distance = distanceTo(p);
  //   if (containsVector2(p)) return -distance;
  //   return distance;
  // }

  double get width => max.x - min.x;
  double get height => max.y - min.y;
  double get aspectRatio => width / height;

  Vector2 get topLeft => min;
  Vector2 get topRight => Vector2(max.x, min.y);
  Vector2 get bottomLeft => Vector2(min.x, max.y);
  Vector2 get bottomRight => max;

  double distanceTo(Vector2 p) {
    final dx = math.max(0.0, math.max(min.x - p.x, p.x - max.x));
    final dy = math.max(0.0, math.max(min.y - p.y, p.y - max.y));
    return math.sqrt(dx * dx + dy * dy);
  }

  bool intersectsWithAabb2Tolerance(Aabb2 other, double tolerance) {
    final a = this, b = other;
    if (a.max.x + tolerance < b.min.x || b.max.x + tolerance < a.min.x) return false;
    if (a.max.y + tolerance < b.min.y || b.max.y + tolerance < a.min.y) return false;
    return true;
  }

  Aabb2 inflate(double amount) {
    final inflated = Aabb2.minMax(min - Vector2.all(amount), max + Vector2.all(amount));
    return inflated;
  }
}

extension GeometryVector2Utils on Vector2 {
  Vector2 pointReflect(Vector2 p) {
    return p * 2 - this;
  }

  Aabb2 aabb2(Vector2 other) {
    final min = Vector2.zero();
    final max = Vector2.zero();

    Vector2.min(this, other, min);
    Vector2.max(this, other, max);

    return .minMax(min, max);
  }
}

const double precisionErrorTolerance = 1e-10;

extension DecomposeMatrix4 on Matrix4 {
  (Vector3 translation, Quaternion rotation, Vector3 scale) getDecomposed() {
    final translation = Vector3.zero();
    final rotation = Quaternion.identity();
    final scale = Vector3.zero();
    decompose(translation, rotation, scale);
    return (translation, rotation, scale);
  }

  String describeDecomposed() {
    final (t, r, s) = getDecomposed();
    final (:x, :y, :z) = r.toEulerAngles();

    String _format(double value) {
      if (value % 1 < precisionErrorTolerance) {
        return value.toInt().toString();
      }

      final str = value.toStringAsFixed(3);
      return str;
    }

    final translation = '(${_format(t.x)}, ${_format(t.y)}, ${_format(t.z)})';
    final scale = '(${_format(s.x)}, ${_format(s.y)}, ${_format(s.z)})';
    final rotation = '(${_format(x)}, ${_format(y)}, ${_format(z)})';

    return '[translation: $translation, scale: $scale, rotation: $rotation]';
  }

  Vector3 get scale => Vector3(scaleX, scaleY, scaleZ);
  double get scaleX => math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
  double get scaleY => math.sqrt(this[4] * this[4] + this[5] * this[5] + this[6] * this[6]);
  double get scaleZ => math.sqrt(this[8] * this[8] + this[9] * this[9] + this[10] * this[10]);

  /// Returns this matrix with the scale normalized.
  Matrix4 getWithNormalizedScale() {
    final sx = scaleX;
    final sy = scaleY;
    final sz = scaleZ;
    final m = Matrix4.copy(this);

    // dart format off
    if (sx > 0) { m[0] /= sx; m[1] /= sx; m[2] /= sx; }
    if (sy > 0) { m[4] /= sy; m[5] /= sy; m[6] /= sy; }
    if (sz > 0) { m[8] /= sz; m[9] /= sz; m[10] /= sz; }
    // dart format on

    return m;
  }
}

extension QuaternionToMatrix4 on Quaternion {
  Matrix4 toMatrix4() {
    final m = Matrix4.identity();
    m.setRotation(asRotationMatrix());
    return m;
  }
}

typedef EulerAngles = ({double x, double y, double z});

extension QuaternionToEulerAngles on Quaternion {
  EulerAngles toEulerAngles() {
    // roll (x-axis rotation)
    final sinrCosp = 2 * (w * x + y * z);
    final cosrCosp = 1 - 2 * (x * x + y * y);
    final rx = math.atan2(sinrCosp, cosrCosp);

    // pitch (y-axis rotation)
    final sinp = math.sqrt(1 + 2 * (w * y - x * z));
    final cosp = math.sqrt(1 - 2 * (w * y - x * z));
    final ry = 2 * math.atan2(sinp, cosp) - math.pi / 2;

    // yaw (z-axis rotation)
    final sinyCosp = 2 * (w * z + x * y);
    final cosyCosp = 1 - 2 * (y * y + z * z);
    final rz = math.atan2(sinyCosp, cosyCosp);

    return (x: rx, y: ry, z: rz);
  }
}

extension RotationMatrix3Extension on Matrix3 {
  EulerAngles toEulerAngles() {
    final m = storage;
    double x, y, z;

    y = math.asin(m[6].clamp(-1.0, 1.0));

    if (y.abs() < (math.pi / 2 - 0.0001)) {
      x = math.atan2(-m[7], m[8]);
      z = math.atan2(-m[3], m[0]);
    } else {
      x = 0;
      z = math.atan2(m[1], m[4]);
    }

    return (x: x, y: y, z: z);
  }
}

extension Aabb2ToQuadExtension on Aabb2 {
  Quad transformToQuad(Matrix4 transform) {
    final topLeft = Vector3(min.x, min.y, 0.0);
    final topRight = Vector3(max.x, min.y, 0.0);
    final bottomRight = Vector3(max.x, max.y, 0.0);
    final bottomLeft = Vector3(min.x, max.y, 0.0);

    return Quad.points(
      transform.transform3(topLeft),
      transform.transform3(topRight),
      transform.transform3(bottomRight),
      transform.transform3(bottomLeft),
    );
  }
}

extension QuadExtensions on Quad {
  Iterable<Vector3> get points sync* {
    yield point0;
    yield point1;
    yield point2;
    yield point3;
  }

  Vector3 operator [](int i) => switch (i) {
    0 => point0,
    1 => point1,
    2 => point2,
    3 => point3,
    _ => throw ArgumentError.value(i, 'can be up to 4'),
  };

  Iterable<(Vector3, Vector3)> get edges sync* {
    yield (point0, point1);
    yield (point1, point2);
    yield (point2, point3);
    yield (point3, point0);
  }
}
