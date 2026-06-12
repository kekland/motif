// Default
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:skia/geometry.dart' as bindings;
import 'package:skia/utils.dart';

// Native
// import 'package:skia/geometry/native.dart' as bindings;
// import 'package:skia/src/utils/utils_native.dart';

// Web
// import 'package:skia/geometry/web.dart' as bindings;
// import 'package:skia/src/utils/utils_web.dart';

Pointer<bindings.Cubic2> _cubic2(Cubic2? c, {Arena? arena}) {
  final ptr = (arena ?? malloc)<bindings.Cubic2>();
  if (c != null) {
    ptr.ref.p0.x = c.p0.x;
    ptr.ref.p0.y = c.p0.y;
    ptr.ref.p1.x = c.p1.x;
    ptr.ref.p1.y = c.p1.y;
    ptr.ref.p2.x = c.p2.x;
    ptr.ref.p2.y = c.p2.y;
    ptr.ref.p3.x = c.p3.x;
    ptr.ref.p3.y = c.p3.y;
  }
  return ptr;
}

Pointer<bindings.Circle2> _circle2(Circle2? c, {Arena? arena}) {
  final ptr = (arena ?? malloc)<bindings.Circle2>();
  if (c != null) {
    ptr.ref.center.x = c.center.x;
    ptr.ref.center.y = c.center.y;
    ptr.ref.radius = c.radius;
  }
  return ptr;
}

Pointer<bindings.Vector2> _vector2(Vector2? v, {Arena? arena}) {
  final ptr = (arena ?? malloc)<bindings.Vector2>();
  if (v != null) {
    ptr.ref.x = v.x;
    ptr.ref.y = v.y;
  }
  return ptr;
}

Pointer<bindings.Intersection> _intersection(Intersection? i, {Arena? arena, int? count}) {
  final ptr = (arena ?? malloc)<bindings.Intersection>(count ?? 1);
  if (i != null) {
    ptr.ref.pt.x = i.point.x;
    ptr.ref.pt.y = i.point.y;
    ptr.ref.tA = i.tA;
    ptr.ref.tB = i.tB;
  }
  return ptr;
}

Pointer<bindings.Aabb2> _aabb2(Aabb2? a, {Arena? arena}) {
  final ptr = (arena ?? malloc)<bindings.Aabb2>();
  if (a != null) {
    ptr.ref.min.x = a.min.x;
    ptr.ref.min.y = a.min.y;
    ptr.ref.max.x = a.max.x;
    ptr.ref.max.y = a.max.y;
  }
  return ptr;
}

Pointer<bindings.Quadratic2> _quadratic2(Quadratic2? q, {Arena? arena, int? count}) {
  final ptr = (arena ?? malloc)<bindings.Quadratic2>(count ?? 1);
  if (q != null) {
    ptr.ref.p0.x = q.p0.x;
    ptr.ref.p0.y = q.p0.y;
    ptr.ref.p1.x = q.p1.x;
    ptr.ref.p1.y = q.p1.y;
    ptr.ref.p2.x = q.p2.x;
    ptr.ref.p2.y = q.p2.y;
  }
  return ptr;
}

Vector2 _vector2ToDart(bindings.Vector2 v) => Vector2(v.x, v.y);

Cubic2 _cubic2ToDart(bindings.Cubic2 c) {
  return Cubic2(_vector2ToDart(c.p0), _vector2ToDart(c.p3), p1: _vector2ToDart(c.p1), p2: _vector2ToDart(c.p2));
}

Intersection _intersectionToDart(bindings.Intersection i) {
  return .new(_vector2ToDart(i.pt), i.tA, i.tB);
}

Aabb2 _aabb2ToDart(bindings.Aabb2 a) {
  return Aabb2.minMax(_vector2ToDart(a.min), _vector2ToDart(a.max));
}

Quadratic2 _quadratic2ToDart(bindings.Quadratic2 q) {
  return Quadratic2(_vector2ToDart(q.p0), _vector2ToDart(q.p2), p1: _vector2ToDart(q.p1));
}

final _intersectionScratch = malloc<bindings.Intersection>(256);

List<Intersection> cubicIntersect(Cubic2 a, Cubic2 b) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    final cb = _cubic2(b, arena: arena);

    final count = bindings.cubic_intersect(ca, cb, _intersectionScratch);
    final result = <Intersection>[];
    for (var i = 0; i < count; i++) {
      result.add(_intersectionToDart(_intersectionScratch[i]));
    }

    return result;
  });
}

List<Intersection> cubicCircleIntersect(Cubic2 a, Circle2 b) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    final cb = _circle2(b, arena: arena);

    final count = bindings.cubic_circle_intersect(ca, cb, _intersectionScratch);
    final result = <Intersection>[];
    for (var i = 0; i < count; i++) {
      result.add(_intersectionToDart(_intersectionScratch[i]));
    }

    return result;
  });
}

Intersection? cubicSelfIntersect(Cubic2 a) {
  return using((arena) {
    final intersection = _intersection(null, arena: arena);
    final ca = _cubic2(a, arena: arena);
    final count = bindings.cubic_self_intersect(ca, intersection);
    if (count == 0) return null;

    final inter = intersection[0];
    return _intersectionToDart(inter);
  });
}

Aabb2 cubicBboxTight(Cubic2 a) {
  return using((arena) {
    final out = _aabb2(null, arena: arena);
    final ca = _cubic2(a, arena: arena);
    bindings.cubic_bbox_tight(ca, out);
    return _aabb2ToDart(out.ref);
  });
}

double cubicArcLength(Cubic2 a) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    return bindings.cubic_arc_length(ca);
  });
}

(Vector2, Vector2) cubicPosTanAtDistance(Cubic2 a, double distance) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    final outPos = _vector2(null, arena: arena);
    final outTan = _vector2(null, arena: arena);
    bindings.cubic_pos_tan_at_distance(ca, distance, outPos, outTan);
    return (_vector2ToDart(outPos.ref), _vector2ToDart(outTan.ref));
  });
}

List<double> cubicFindInflections(Cubic2 a) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    final out = arena<Double>(3);
    final count = bindings.cubic_find_inflections(ca, out);

    final result = <double>[];
    for (var i = 0; i < count; i++) result.add(out[i]);
    return result;
  });
}

final _cubicToQuadraticScratch1 = malloc<bindings.Quadratic2>(1000);
final _cubicToQuadraticScratch2 = malloc<Double>(1000);
(List<Quadratic2>, List<double>) cubicToQuads(Cubic2 a, double tolerance, bool chopAtInflections) {
  return using((arena) {
    final ca = _cubic2(a, arena: arena);
    final out = _cubicToQuadraticScratch1;
    final outT = _cubicToQuadraticScratch2;
    final count = bindings.cubic_to_quads(ca, tolerance, out, outT, chopAtInflections);

    final result = <Quadratic2>[];
    final resultT = <double>[];
    for (var i = 0; i < count; i++) result.add(_quadratic2ToDart(out[i]));
    for (var i = 0; i < count - 1; i++) resultT.add(outT[i]);

    return (result, resultT);
  });
}

CubicSpline2 strokeToSpline(List<StrokePoint> points, double spatialTolerance, double velocityThreshold) {
  return using((arena) {
    final inputPoints = arena<bindings.InputPoint>(points.length);
    for (var i = 0; i < points.length; i++) {
      inputPoints[i].position.x = points[i].position.x;
      inputPoints[i].position.y = points[i].position.y;
      inputPoints[i].pressure = points[i].pressure;
      inputPoints[i].timestamp_ms = points[i].timestamp.inMilliseconds.toDouble();
    }

    final cleanPointCount = bindings.cull_noisy_points(inputPoints, points.length, spatialTolerance);
    final result = bindings.stroke_to_spline(inputPoints, cleanPointCount, spatialTolerance, velocityThreshold);
    arena.using(result.cubics, (_) => malloc.free(result.cubics));

    final cubics = List.generate(result.count, (i) => _cubic2ToDart(result.cubics[i]), growable: false);
    return CubicSpline2.cubics(cubics);
  });
}

List<StrokePoint> cullNoisyPoints(List<StrokePoint> points, double spatialTolerance) {
  return using((arena) {
    final inputPoints = arena<bindings.InputPoint>(points.length);
    for (var i = 0; i < points.length; i++) {
      inputPoints[i].position.x = points[i].position.x;
      inputPoints[i].position.y = points[i].position.y;
      inputPoints[i].pressure = points[i].pressure;
      inputPoints[i].timestamp_ms = points[i].timestamp.inMilliseconds.toDouble();
    }

    final cleanPointCount = bindings.cull_noisy_points(inputPoints, points.length, spatialTolerance);

    final result = List<StrokePoint>.generate(cleanPointCount, (i) {
      final p = inputPoints[i];
      return StrokePoint(
        position: Vector2(p.position.x, p.position.y),
        pressure: p.pressure,
        timestamp: Duration(milliseconds: p.timestamp_ms.toInt()),
      );
    }, growable: false);

    return result;
  });
}
