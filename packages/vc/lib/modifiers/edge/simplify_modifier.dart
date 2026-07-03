import 'package:geometry/geometry.dart';
import 'package:vc/core/core.dart';

class SimplifyEdgeModifier extends EdgeModifier {
  SimplifyEdgeModifier({
    this.spatialTolerance = 2.0,
    this.weightTolerance = 2.0,
    this.velocityThreshold = 2.0,
    super.isEnabled,
  });

  final double spatialTolerance;
  final double weightTolerance;
  final double velocityThreshold;

  @override
  (Edge, List<Cell>) apply(VectorComplexContext context, Edge edge) {
    late final List<StrokePoint> strokePoints;

    if (edge.path.rawStrokePoints != null) {
      strokePoints = edge.path.rawStrokePoints!;
    } else {
      final spline = edge.path;
      final polyline = spline.flatten(tolerance: spatialTolerance).$1;
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
        path: .spline(newSpline),
        weights: .new(profile: newWeightsProfile),
      ),
      [],
    );
  }

  SimplifyEdgeModifier copyWith({
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
