import 'dart:math';

import 'package:geometry/geometry.dart';
import 'package:geometry/ffi/ffi.dart' as ffi;

double _hermiteEvaluate(List<RawProfileSample> k, List<double> m, double x) {
  final n = k.length;
  if (x <= k[0].x) return k[0].v;
  if (x >= k[n - 1].x) return k[n - 1].v;

  var lo = 0, hi = n - 1;
  while (lo + 1 < hi) {
    final m = (lo + hi) ~/ 2;
    if (k[m].x < x) {
      lo = m;
    } else {
      hi = m;
    }
  }

  final a = (x: k[lo].x, v: k[lo].v, dv: m[lo]);
  final b = (x: k[hi].x, v: k[hi].v, dv: m[hi]);
  if (a.x == b.x) return a.v;
  return hermiteInterpolate(a, b, (x - a.x) / (b.x - a.x)).v;
}

StrokeWeightArcLengthProfile _generateProfile(
  List<StrokePoint> rawPoints,
  double weightTolerance,
  double spatialTolerance,
) {
  final points = ffi.cullNoisyPoints(rawPoints, spatialTolerance);
  var n = points.length;

  late final List<RawProfileSample> rawSamples;

  if (n == 0) {
    rawSamples = [];
  } else if (n == 1) {
    rawSamples = [(x: 0.0, v: points[0].pressure)];
  } else {
    final dense = <RawProfileSample>[];
    var totalLength = 0.0;
    dense.add((x: 0.0, v: points[0].pressure));

    for (var i = 1; i < n; i++) {
      totalLength += (points[i].position - points[i - 1].position).length;
      dense.add((x: totalLength, v: points[i].pressure));
    }

    if (dense.length >= 3) {
      final med = List<RawProfileSample>.from(dense);
      for (var i = 1; i < dense.length - 1; i++) {
        final a = dense[i - 1].v, b = dense[i].v, c = dense[i + 1].v;
        med[i] = (x: dense[i].x, v: max(min(a, b), min(max(a, b), c)));
      }
      dense.setAll(0, med);
    }

    n = dense.length;
    if (n <= 2) {
      rawSamples = dense;
    } else {
      final keep = <int>[0, n - 1];

      while (true) {
        final knots = [for (final i in keep) dense[i]];
        final m = hermiteTangents(knots);

        var worst = weightTolerance;
        var worstIndex = -1;
        for (var i = 1; i < n - 1; i++) {
          final e = (dense[i].v - _hermiteEvaluate(knots, m, dense[i].x)).abs();
          if (e > worst) {
            worst = e;
            worstIndex = i;
          }
        }

        if (worstIndex == -1) break;
        var insertPos = keep.indexWhere((i) => i > worstIndex);
        if (insertPos == -1) insertPos = keep.length;
        keep.insert(insertPos, worstIndex);
      }

      rawSamples = [for (final i in keep) dense[i]];
    }
  }

  return StrokeWeightArcLengthProfile.from(
    rawSamples,
    rawSamples.isEmpty ? 0.0 : rawSamples.last.x,
  );
}

class StrokeWeightArcLengthProfile extends ArcLengthProfile<StrokeWeightArcLengthProfile> {
  StrokeWeightArcLengthProfile(super.totalLength) : super();
  StrokeWeightArcLengthProfile.from(super.samples, super.totalLength) : super.from();
  StrokeWeightArcLengthProfile.empty() : super(0.0);

  factory StrokeWeightArcLengthProfile.fitFromFreehand(
    List<StrokePoint> input, {
    required double weightTolerance,
    required double spatialTolerance,
  }) => _generateProfile(input, weightTolerance, spatialTolerance);

  @override
  StrokeWeightArcLengthProfile create(List<RawProfileSample> samples, double totalLength) =>
      .from(samples, totalLength);

  StrokeWeightParameterProfile toParameterProfile(double Function(double) distToT) =>
      .from(getParameterProfileSamples(distToT));
}

class StrokeWeightParameterProfile extends ParameterProfile<StrokeWeightParameterProfile> {
  StrokeWeightParameterProfile() : super();
  StrokeWeightParameterProfile.from(super.samples) : super.from();
  StrokeWeightParameterProfile.empty(): super.empty();

  @override
  StrokeWeightParameterProfile create(List<RawProfileSample> samples) => .from(samples);

  StrokeWeightArcLengthProfile toArcLengthProfile(double Function(double) tToDist, double totalLength) =>
      .from(getArcLengthProfileSamples(tToDist), totalLength);
}
