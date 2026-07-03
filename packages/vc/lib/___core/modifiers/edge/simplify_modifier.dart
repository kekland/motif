part of '../../core.dart';

class SimplifyModifier extends EdgeModifier {
  SimplifyModifier({
    this.spatialTolerance = 2.0,
    this.weightTolerance = 2.0,
    this.velocityThreshold = 2.0,
    super.isEnabled,
  });

  final double spatialTolerance;
  final double weightTolerance;
  final double velocityThreshold;

  @override
  (ImmutableEdge, List<ImmutableCell>) apply(ImmutableEdge edge) {
    late final List<StrokePoint> strokePoints;

    if (edge.path.rawStrokePoints != null) {
      strokePoints = edge.path.rawStrokePoints!;
    } else {
      final spline = edge.path.spline;
      final polyline = spline.flatten(tolerance: spatialTolerance / 10.0).$1;
      strokePoints = List.generate(
        polyline.length,
        (i) => .new(position: polyline[i], pressure: 1.0, timestamp: .zero),
      );
    }

    final newSpline = fitPointsToSplineFfi(
      strokePoints,
      spatialTolerance: spatialTolerance,
      velocityThreshold: velocityThreshold,
    );

    final newWeights = StrokeWeightArcLengthProfile.fitFromFreehand(
      strokePoints,
      spatialTolerance: spatialTolerance,
      weightTolerance: weightTolerance,
    );

    final newWeightsProfile = newWeights.toParameterProfile(newSpline.tAtDistance);

    return (
      edge.copyWith(
        path: .immutable(knots: newSpline.knots),
        weights: .immutable(profile: newWeightsProfile),
      ),
      [],
    );
  }

  SimplifyModifier copyWith({
    double? spatialTolerance,
    double? weightTolerance,
    double? velocityThreshold,
    bool? isEnabled,
  }) {
    return .new(
      spatialTolerance: spatialTolerance ?? this.spatialTolerance,
      weightTolerance: weightTolerance ?? this.weightTolerance,
      velocityThreshold: velocityThreshold ?? this.velocityThreshold,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
