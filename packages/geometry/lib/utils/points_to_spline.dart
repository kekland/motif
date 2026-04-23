import 'dart:math' as math;

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';

/// A function that converts a list of points into a cubic spline.
CubicSpline2 pointsToSpline(
  List<Vector2> points, {
  List<Vector2>? rawPoints,
  List<double>? timestamps,
  // Visvalingam–Whyatt epsilon for decimation
  double vwEpsilon = 1.5,
  // Ramer-Douglas-Peucker threshold for fitting
  double schneiderErrorThreshold = 1.0,
  // Window size for tangent estimation at chunk edges
  double chunkTangentWindow = 6.0,
  // Corner detection parameters
  double cornerWindowArcLength = 10.0,
  double cornerStrictAngle = 1.0,
  double cornerRelaxedAngle = 0.5,
  double cornerSpeedRadius = 15.0,
  double cornerSuppressionRadius = 12.0,
}) {
  if (points.length < 2) return .empty();

  // Detect corners
  final corners = _detectCorners(
    rawPoints ?? points,
    timestamps: timestamps,
    windowArcLength: cornerWindowArcLength,
    strictMinAngle: cornerStrictAngle,
    relaxedMinAngle: cornerRelaxedAngle,
    speedMinimumRadius: cornerSpeedRadius,
    suppressionRadius: cornerSuppressionRadius,
  );

  // Split into chunks at corners
  final chunks = <List<Vector2>>[];
  final rawChunks = <List<Vector2>>[];
  var start = 0;
  for (final idx in corners) {
    chunks.add(points.sublist(start, idx + 1));
    rawChunks.add((rawPoints ?? points).sublist(start, idx + 1));
    start = idx;
  }
  chunks.add(points.sublist(start));
  rawChunks.add((rawPoints ?? points).sublist(start));

  // Decimate corners and fit into splines
  final cubics = <Cubic2>[];
  for (final (i, chunk) in chunks.indexed) {
    if (chunk.length < 2) continue;
    final rawChunk = rawChunks[i];

    var chunkArcLength = 0.0;
    for (var j = 1; j < rawChunk.length; j++) {
      chunkArcLength += rawChunk[j].distanceTo(rawChunk[j - 1]);
    }

    final tangentWindow = math.min(chunkTangentWindow, chunkArcLength * 0.2);
    final startTangent = _windowedEdgeTangent(rawChunk, fromStart: true, window: tangentWindow);
    final endTangent = _windowedEdgeTangent(rawChunk, fromStart: false, window: tangentWindow);

    final simplified = visvalingamWhyatt(chunk, epsilon: vwEpsilon);
    if (simplified.length < 2) continue;

    final fitted = schneiderRaw(
      simplified,
      startTangent: startTangent,
      endTangent: endTangent,
      errorThreshold: schneiderErrorThreshold,
    );

    cubics.addAll(fitted);
  }

  return .cubics(cubics);
}

/// Detects potential corners in the raw point list and returns their indices.
List<int> _detectCorners(
  List<Vector2> points, {
  List<double>? timestamps,
  required double windowArcLength,
  required double strictMinAngle,
  required double relaxedMinAngle,
  required double speedMinimumRadius,
  required double suppressionRadius,
}) {
  final length = points.length;
  if (length < 3) return [];

  final arcLen = List.filled(length, 0.0);
  for (var i = 1; i < length; i++) {
    arcLen[i] = arcLen[i - 1] + points[i].distanceTo(points[i - 1]);
  }

  final angles = List.filled(length, 0.0);
  for (var i = 1; i < length - 1; i++) {
    var jBack = i;
    while (jBack > 0 && arcLen[i] - arcLen[jBack] < windowArcLength) jBack--;

    var jForward = i;
    while (jForward < length - 1 && arcLen[jForward] - arcLen[i] < windowArcLength) jForward++;
    if (jBack == i || jForward == i) continue;

    final startTangent = points[i] - points[jBack];
    final endTangent = points[jForward] - points[i];

    if (startTangent.length < 1e-6 || endTangent.length < 1e-6) continue;

    startTangent.normalize();
    endTangent.normalize();
    angles[i] = math.acos(startTangent.dot(endTangent).clamp(-1.0, 1.0));
  }

  final speedMinima = <int>{};
  if (timestamps != null && timestamps.length == length) {
    final speeds = List.filled(length, 0.0);
    for (var i = 1; i < length - 1; i++) {
      final dt = timestamps[i + 1] - timestamps[i - 1];
      if (dt > 1e-3) {
        speeds[i] = points[i + 1].distanceTo(points[i - 1]) / dt;
      }
    }

    final smoothedSpeeds = List.filled(length, 0.0);
    for (var i = 1; i < length - 1; i++) {
      smoothedSpeeds[i] = (speeds[i - 1] + 2 * speeds[i] + speeds[i + 1]) / 4.0;
    }

    for (var i = 2; i < length - 2; i++) {
      if (smoothedSpeeds[i] < smoothedSpeeds[i - 1] && smoothedSpeeds[i] < smoothedSpeeds[i + 1]) {
        speedMinima.add(i);
      }
    }
  }

  final candidates = <int>[];
  for (var i = 1; i < length - 1; i++) {
    if (angles[i] < relaxedMinAngle) continue;
    if (angles[i] < angles[i - 1] || angles[i] < angles[i + 1]) continue;

    final passesStrict = angles[i] >= strictMinAngle;
    final passesSpeed = speedMinima.any((j) => (arcLen[i] - arcLen[j]).abs() < speedMinimumRadius);
    if (passesStrict || passesSpeed) candidates.add(i);
  }

  candidates.sort((a, b) => angles[b].compareTo(angles[a]));
  final survivors = <int>[];
  for (final c in candidates) {
    final clash = survivors.any((s) => (arcLen[c] - arcLen[s]).abs() < suppressionRadius);
    if (!clash) survivors.add(c);
  }

  survivors.sort();
  return survivors;
}

/// Returns the tangent at the start/end of a given point list and a window of arc length around it.
Vector2 _windowedEdgeTangent(
  List<Vector2> points, {
  required bool fromStart,
  required double window,
}) {
  final length = points.length;
  if (length < 2) return .zero();

  var acc = 0.0;
  if (fromStart) {
    var outIndex = 0;

    for (var i = 1; i < length; i++) {
      acc += points[i].distanceTo(points[i - 1]);
      outIndex = i;
      if (acc >= window) break;
    }
    return points[outIndex] - points[0];
  } else {
    var outIndex = length - 1;

    for (var i = length - 2; i >= 0; i--) {
      acc += points[i + 1].distanceTo(points[i]);
      outIndex = i;
      if (acc >= window) break;
    }

    return points[outIndex] - points[length - 1];
  }
}
