part of '../vector_complex.dart';

class StrokeWeightArcLengthProfile extends ArcLengthProfile<double, StrokeWeightArcLengthProfile> {
  StrokeWeightArcLengthProfile(super._samples, super.totalLength);

  factory StrokeWeightArcLengthProfile.fitFromFreehand(
    List<(Vector2, double)> input,
    CubicSpline2 spline,
  ) {
    final totalLength = spline.arcLength;
    final samples = <ArcLengthSample<double>>[];

    for (final (p, weight) in input) {
      final closest = spline.closestTo(p);
      final s = spline.distanceAtT(closest.t);
      samples.add(ArcLengthSample(s, weight));
    }

    samples.sort((a, b) => a.dist.compareTo(b.dist));
    return StrokeWeightArcLengthProfile(samples, totalLength);
  }

  @override
  StrokeWeightArcLengthProfile create(List<ArcLengthSample<double>> samples, double totalLength) =>
      .new(samples, totalLength);

  @override
  double lerp(double a, double b, double t) => a + t * (b - a);

  StrokeWeightParameterProfile toParameterProfile(double Function(double) distToT) {
    final samples = this.samples.map((s) => ParameterSample(distToT(s.dist), at(s.dist))).toList();
    return .new(samples);
  }

  double get max => samples.map((s) => s.value).reduce(math.max);
  double get min => samples.map((s) => s.value).reduce(math.min);
}

class StrokeWeightParameterProfile extends ParameterProfile<double, StrokeWeightParameterProfile> {
  StrokeWeightParameterProfile(super._samples);

  @override
  StrokeWeightParameterProfile create(List<ParameterSample<double>> samples) => .new(samples);

  @override
  double lerp(double a, double b, double t) => a + t * (b - a);

  StrokeWeightArcLengthProfile toArcLengthProfile(double Function(double) tToDist, double totalLength) {
    final samples = this.samples.map((s) => ArcLengthSample(tToDist(s.t), at(s.t))).toList();
    return .new(samples, totalLength);
  }

  double get max => samples.map((s) => s.value).reduce(math.max);
  double get min => samples.map((s) => s.value).reduce(math.min);
}
