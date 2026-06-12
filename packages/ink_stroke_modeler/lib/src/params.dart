/// These structs contain parameters for tuning the behavior of the stroke
/// modeler.
///
/// The stroke modeler is unit-agnostic, in both time and space. That is, the
/// stroke modeler does not know or care whether the inputs and parameters are
/// specified in feet and minutes, meters and seconds, or millimeters and years.
/// As such, instead of referring to specific units, we refer to "unit distance"
/// and "unit time".
///
/// These parameters will need to be "tuned" to your use case. Because of this,
/// and because of the modeler's unit-agnosticism, it's impossible to define
/// "reasonable" default values for many of the parameters -- these parameters
/// instead default to -1, which will cause the validation functions to return an
/// error.
///
/// Where possible, we've indicated what a good starting point for tuning might
/// be, but you'll likely need to adjust these for best results.
class StrokeModelerParams {
  const StrokeModelerParams({
    this.wobbleSmootherParams = const .new(),
    this.positionModelerParams = const .new(),
    this.samplingParams = const .new(),
    this.stylusStateModelerParams = const .new(),
    this.predictionParams = const DisabledPredictorParams(),
  });

  final WobbleSmootherParams wobbleSmootherParams;
  final PositionModelerParams positionModelerParams;
  final SamplingParams samplingParams;
  final StylusStateModelerParams stylusStateModelerParams;
  final PredictorParams predictionParams;
}

/// These parameters are used for applying smoothing to the input to reduce
/// wobble in the prediction.
class WobbleSmootherParams {
  const WobbleSmootherParams({
    this.isEnabled = true,
    this.timeout = const Duration(seconds: -1),
    this.speedRange = (-1, -1),
  });

  /// If true, the wobble smoothing will be applied to the stroke. If false, the
  /// wobble smoothing step will be skipped, and the remainder of the parameters
  /// in the struct will be ignored.
  final bool isEnabled;

  /// The length of the window over which the moving average of speed and
  /// position are calculated.
  ///
  /// A good starting point is 2.5 divided by the expected number of inputs per
  /// unit time.
  final Duration timeout;

  /// The range of speeds considered for wobble smoothing. At speed_floor, the
  /// maximum amount of smoothing is applied. At speed_ceiling, no smoothing is
  /// applied.
  ///
  /// Good starting points are 2% and 3% of the expected speed of the inputs.
  final (double, double) speedRange;
}

class LoopContractionMitigationParams {
  const LoopContractionMitigationParams({
    this.isEnabled = false,
    this.speedRange = (-1, -1),
    this.interpolationStrengthAtSpeedRange = (-1, -1),
    this.minSpeedSamplingWindow = const Duration(seconds: -1),
  });

  /// 'is_enabled' turns loop mitigation on or off. If 'is_enabled' is false,
  /// all other params are being ignored. If 'is_enabled' is true, the other
  /// params must be set to valid values and
  /// `StylusStateModelerParams::project_to_segment_along_normal_is_enabled`
  /// must be set to true.
  /// We recommend enabling this in order to get increased accuracy on loops;
  /// however, this defaults to false to preserve behavior for existing uses.
  final bool isEnabled;

  /// The slowest speed at which to start applying the mitigation. At this
  /// speed, the interpolation value will be equal to
  /// `interpolation_strength_at_speed_lower_bound`.
  /// When `is_enabled` is true, this must be <= `speed_upper_bound` and >= 0.
  final (double, double) speedRange;

  /// The interpolation value to use when the speed is equal to
  /// `speed_lower_bound`. A value of 1 results in no mitigation, using the
  /// unaltered result of the spring model. A value of 0 uses the value from
  /// the raw input polyline, with no influence from the spring model.
  /// When `is_enabled` is true, this must be >=
  /// `interpolation_strength_at_speed_upper_bound` and <= 1.
  final (double, double) interpolationStrengthAtSpeedRange;

  /// These parameters determine the window of samples to use when calculating
  /// a moving average of the speed. If we have not yet received a longer
  /// duration of inputs, then the moving average will be calculated using all
  /// available inputs. A higher number results in a smoother transition
  /// between low and high speeds (which can reduce artifacts from noisy
  /// inputs) at the cost of adding latency to the mitigation response. This
  /// value must be >= 0.
  final Duration minSpeedSamplingWindow;
}

/// These parameters are used for modeling the position of the pen.
class PositionModelerParams {
  const PositionModelerParams({
    this.springMassConstant = 11.0 / 32400,
    this.dragConstant = 72.0,
    this.loopContractionMitigation = const .new(),
  });

  /// The mass of the "weight" being pulled along the path, divided by the
  /// spring constant. The displacement between the stroke tip and the input is
  /// divided by this value to get the acceleration of the stroke tip towards
  /// the input position due to the simulated spring.
  final double springMassConstant;

  /// The ratio of the pen's velocity that is subtracted from the pen's
  /// acceleration per unit time, to simulate drag.
  final double dragConstant;

  /// These parameters control the behavior of the loop contraction mitigation.
  /// The mitigation corrects for loop contraction by interpolating between the
  /// result from the spring model, and the nearest point on the raw input
  /// polyline, based on the a moving average of the speed of the raw inputs.
  final LoopContractionMitigationParams loopContractionMitigation;
}

/// These parameters are used for sampling.
class SamplingParams {
  const SamplingParams({
    this.minOutputRate = -1,
    this.endOfStrokeStoppingDistance = -1,
    this.endOfStrokeMaxIterations = 20,
    this.maxOutputsPerCall = 100000,
    this.maxEstimatedAngleToTraversePerInput = -1,
  });

  /// The minimum number of modeled inputs to output per unit time. If inputs are
  /// received at a lower rate, they will be upsampled to produce output of at
  /// least min_output_rate. If inputs are received at a higher rate, the
  /// output rate will match the input rate.
  final double minOutputRate;

  /// This determines stop condition for end-of-stroke modeling; if the position
  /// is within this distance of the final raw input, or if the last update
  /// iteration moved less than this distance, it stop iterating.
  ///
  /// This should be a small distance; a good starting point is 2-3 orders of
  /// magnitude smaller than the expected distance between input points.
  final double endOfStrokeStoppingDistance;

  /// The maximum number of iterations to perform at the end of the stroke, if it
  /// does not stop due to the constraints of end_of_stroke_stopping_distance.
  final int endOfStrokeMaxIterations;

  /// Maximum number of outputs to generate per call to Update or Predict.
  /// This limit avoids crashes if input events are received with too long of
  /// a time between, possibly because a client was suspended and resumed.
  final int maxOutputsPerCall;

  /// Max absolute value of estimated angle to traverse in a single upsampled
  /// input step in radians (0, PI). The traversed angle is estimated by
  /// considering the change in the angle of the tip state that would happen due
  /// to the input without any upsampling. If set to -1 (the default), input is
  /// not upsampled for this reason.
  final double maxEstimatedAngleToTraversePerInput;
}

/// These parameters are used for modeling the non-positional state of the stylus
/// (i.e. pressure, tilt, and orientation) once the position has been modeled.
///
/// To calculate the non-positional state, we project the modeled position of the
/// tip, to a polyline made up of the most recent raw inputs, and then
/// interpolate pressure, tilt, and orientation along that raw input polyline.
/// These parameters determine the projection method, and how many raw input
/// samples to include in the polyline.
class StylusStateModelerParams {
  const StylusStateModelerParams({
    this.useStrokeNormalProjection = false,
  });

  /// This determines the method used to project to the raw input polyline.
  /// * If false, we take the point on the polyline closest to the modeled tip
  ///   position.
  /// * If true, we cast a pair of rays in opposite directions normal to the
  ///   stroke direction from the modeled tip point and find the intersection
  ///   with the raw input polyline. If multiple intersections are found, we use
  ///   a heuristic to determine the best choice.
  /// We recommend enabling this in order to get increased accuracy for pressure,
  /// tilt, and orientation; however, this defaults to false to preserve behavior
  /// for existing uses.
  final bool useStrokeNormalProjection;
}

sealed class PredictorParams {
  const PredictorParams();

  static const disabled = DisabledPredictorParams();
  static const strokeEnd = StrokeEndPredictorParams();
  const factory PredictorParams.kalman({
    double processNoise,
    double measurementNoise,
    int minStableIteration,
    int maxTimeSamples,
    double minCatchupVelocity,
    double accelerationWeight,
    double jerkWeight,
    Duration predictionInterval,
    KalmanPredictorConfidenceParams confidenceParams,
  }) = KalmanPredictorParams;
}

/// Type used to indicate that no prediction strategy should be used. Attempting
/// to construct a prediction in combination with this setting results in error.
final class DisabledPredictorParams extends PredictorParams {
  const DisabledPredictorParams();
}

/// This struct indicates the "stroke end" prediction strategy should be used,
/// which models a prediction as though the last seen input was the
/// end-of-stroke. There aren't actually any tunable parameters for this; it uses
/// the same PositionModelerParams and SamplingParams as the overall model. Note
/// that this "prediction" doesn't actually predict substantially into the
/// future, it only allows for very quickly "catching up" to the position of the
/// raw input.
final class StrokeEndPredictorParams extends PredictorParams {
  const StrokeEndPredictorParams();
}

/// The Kalman predictor uses several heuristics to evaluate confidence in the
/// prediction. Each heuristic produces a confidence value between 0 and 1, and
/// then we take their product as the total confidence.
/// These parameters may be used to tune those heuristics.
class KalmanPredictorConfidenceParams {
  const KalmanPredictorConfidenceParams({
    this.desiredNumberOfSamples = 20,
    this.maxEstimationDistance = -1,
    this.travelSpeedRange = (-1, -1),
    this.maxLinearDeviation = -1,
    this.baselineLinearityConfidence = 0.4,
  });

  /// The first heuristic simply increases confidence as we receive more sample
  /// (i.e. input points). It evaluates to 0 at no samples, and 1 at
  /// desired_number_of_samples.
  final int desiredNumberOfSamples;

  /// The second heuristic is based on the distance between the last sample
  /// and the current estimate. If the distance is 0, it evaluates to 1, and if
  /// the distance is greater than or equal to max_estimation_distance, it
  /// evaluates to 0.
  ///
  /// A good starting point is 1.5 times measurement_noise.
  final double maxEstimationDistance;

  /// The third heuristic is based on the speed of the prediction, which is
  /// approximated by measuring the from the start of the prediction to the
  /// projected endpoint (if it were extended for the full
  /// prediction_interval). It evaluates to 0 at min_travel_speed, and 1
  /// at max_travel_speed.
  ///
  /// Good starting points are 5% and 25% of the expected speed of the inputs.
  final (double, double) travelSpeedRange;

  /// The fourth heuristic is based on the linearity of the prediction, which
  /// is approximated by comparing the endpoint of the prediction with the
  /// endpoint of a linear prediction (again, extended for the full
  /// prediction_interval). It evaluates to 1 at zero distance, and
  /// baseline_linearity_confidence at a distance of max_linear_deviation.
  ///
  /// A good starting point is an 10 times the measurement_noise.
  final double maxLinearDeviation;

  final double baselineLinearityConfidence;
}

/// This struct indicates that the Kalman filter-based prediction strategy should
/// be used, and provides the parameters for tuning it.
///
/// Unlike the "stroke end" predictor, this strategy can predict an extension
/// of the stroke beyond the last Input position, in addition to the "catch up"
/// step.
final class KalmanPredictorParams extends PredictorParams {
  const KalmanPredictorParams({
    this.processNoise = -1,
    this.measurementNoise = -1,
    this.minStableIteration = 4,
    this.maxTimeSamples = 20,
    this.minCatchupVelocity = -1,
    this.accelerationWeight = 0.5,
    this.jerkWeight = 0.1,
    this.predictionInterval = const Duration(seconds: -1),
    this.confidenceParams = const .new(),
  });

  /// The variance of the noise inherent to the stroke itself.
  final double processNoise;

  /// The variance of the noise that rises from errors in measurement of the
  /// stroke.
  final double measurementNoise;

  /// The minimum number of inputs received before the Kalman predictor is
  /// considered stable enough to make a prediction.
  final int minStableIteration;

  /// The Kalman filter assumes that input is received in uniform time steps, but
  /// this is not always the case. We hold on to the most recent input timestamps
  /// for use in calculating the correction for this. This determines the maximum
  /// number of timestamps to save.
  final int maxTimeSamples;

  /// The minimum allowed velocity of the "catch up" portion of the prediction,
  /// which covers the distance between the last Result (the last corrected
  /// position) and the
  ///
  /// A good starting point is 3 orders of magnitude smaller than the expected
  /// speed of the inputs.
  final double minCatchupVelocity;

  /// These weights are applied to the acceleration (x²) and jerk (x³) terms of
  /// the cubic prediction polynomial. The closer they are to zero, the more
  /// linear the prediction will be.
  final double accelerationWeight;

  /// These weights are applied to the acceleration (x²) and jerk (x³) terms of
  /// the cubic prediction polynomial. The closer they are to zero, the more
  /// linear the prediction will be.
  final double jerkWeight;

  /// This value is a hint to the predictor, indicating the desired duration of
  /// of the portion of the prediction extending beyond the position of the last
  /// input. The actual duration of that portion of the prediction may be less
  /// than this, based on the predictor's confidence, but it will never be
  /// greater.
  final Duration predictionInterval;

  // The Kalman predictor uses several heuristics to evaluate confidence in the
  // prediction. Each heuristic produces a confidence value between 0 and 1, and
  // then we take their product as the total confidence.
  // These parameters may be used to tune those heuristics.
  final KalmanPredictorConfidenceParams confidenceParams;
}
