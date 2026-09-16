// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:ink_stroke_modeler/src/types.dart';

const _MAX_END_OF_STROKE_MAX_ITERATIONS = 1000;
const _MAX_SAMPLING_WINDOW = TimeSpan(10000.0);

void _validateGreaterThanOrEqualToZero(num value, String name) {
  _validateIsFiniteNumber(value, name);
  if (value < 0) throw ArgumentError.value(value, name, 'must be greater than or equal to zero');
}

void _validateGreaterThanZero(num value, String name) {
  _validateIsFiniteNumber(value, name);
  if (value <= 0) throw ArgumentError.value(value, name, 'must be greater than zero');
}

void _validateLessThan(num value, num upperBound, String name, {String? boundName}) {
  _validateIsFiniteNumber(value, name);
  if (value >= upperBound) throw ArgumentError.value(value, name, 'must be less than ${boundName ?? upperBound}');
}

void _validateRange(Range range, String name, {num? lowerBound}) {
  final min = range.min, max = range.max;

  if (min.compareTo(max) > 0) throw ArgumentError.value(range, name, 'min <= max');
  if (lowerBound != null && min.compareTo(lowerBound) < 0) throw ArgumentError.value(range, name, 'min >= lowerBound');
}

void _validateIsFiniteNumber(num value, String name) {
  if (!value.isFinite) throw ArgumentError.value(value, name, 'must be a finite number');
}

extension type const Range<T extends Comparable>._((T, T) _) {
  const Range(T min, T max) : _ = ((min, max));

  T get min => _.$1;
  T get max => _.$2;
}

final class const LoopContractionMitigationParams({
  required final Range<double> speedBound,
  required final double interpolationStrengthAtSpeedLowerBound,
  required final double interpolationStrengthAtSpeedUpperBound,
  required final TimeSpan minSpeedSamplingWindow,
}) {
  void validate() {
    _validateRange(speedBound, 'speedBound', lowerBound: 0);

    if (interpolationStrengthAtSpeedLowerBound < interpolationStrengthAtSpeedUpperBound ||
        interpolationStrengthAtSpeedLowerBound > 1 ||
        interpolationStrengthAtSpeedUpperBound < 0)
      throw ArgumentError.value(
        interpolationStrengthAtSpeedLowerBound,
        'interpolationStrengthAtSpeedLowerBound',
        'must be >= interpolationStrengthAtSpeedUpperBound and in [0, 1]',
      );

    if (minSpeedSamplingWindow < 0 || minSpeedSamplingWindow > _MAX_SAMPLING_WINDOW) {
      throw ArgumentError.value(
        minSpeedSamplingWindow,
        'minSpeedSamplingWindow',
        'must be in [0, $_MAX_SAMPLING_WINDOW]',
      );
    }
  }
}

final class const PositionModelerParams({
  final double springMassConstant = 11.0 / 32400.0,
  final double dragConstant = 72.0,
  final LoopContractionMitigationParams? loopContractionMitigationParams,
}) {
  void validate() {
    loopContractionMitigationParams?.validate();
    _validateGreaterThanZero(springMassConstant, 'springMassConstant');
    _validateGreaterThanZero(dragConstant, 'dragConstant');
  }
}

final class const SamplingParams({
  final double minOutputRate = 180,
  final double endOfStrokeStoppingDistance = 0.001,
  final int endOfStrokeMaxIterations = 20,
  final int maxOutputsPerCall = 100000,
  final double? maxEstimatedAngleToTraversePerInput,
}) {
  void validate() {
    _validateGreaterThanZero(minOutputRate, 'minOutputRate');
    _validateGreaterThanZero(endOfStrokeStoppingDistance, 'endOfStrokeStoppingDistance');
    _validateGreaterThanZero(endOfStrokeMaxIterations, 'endOfStrokeMaxIterations');
    if (endOfStrokeMaxIterations > _MAX_END_OF_STROKE_MAX_ITERATIONS) {
      throw ArgumentError.value(
        endOfStrokeMaxIterations,
        'endOfStrokeMaxIterations',
        'must be <= $_MAX_END_OF_STROKE_MAX_ITERATIONS',
      );
    }

    _validateGreaterThanZero(maxOutputsPerCall, 'maxOutputsPerCall');
    if (maxEstimatedAngleToTraversePerInput != null) {
      _validateGreaterThanZero(maxEstimatedAngleToTraversePerInput!, 'maxEstimatedAngleToTraversePerInput');
      _validateLessThan(
        maxEstimatedAngleToTraversePerInput!,
        pi,
        'maxEstimatedAngleToTraversePerInput',
        boundName: 'pi',
      );
    }
  }
}

final class const StylusStateModelerParams({
  final bool useStrokeNormalProjection = false,
}) {
  void validate() {}
}

final class const WobbleSmootherParams({
  final TimeSpan timeout = const .new(0.04),
  final Range<double> speedRange = const Range(1.31, 1.44),
}) {
  void validate() {
    _validateGreaterThanOrEqualToZero(timeout, 'timeout');
    _validateRange(speedRange, 'speedRange', lowerBound: 0.0);
    _validateIsFiniteNumber(speedRange.max, 'speedRange.max');
  }
}

sealed class const PredictionParams() {
  void validate();
}

final class const DisabledPredictorParams() extends PredictionParams {
  @override
  void validate() {}
}

final class const StrokeEndPredictorParams() extends PredictionParams {
  @override
  void validate() {}
}

final class const ConfidenceParams({
  final int desiredNumberOfSamples = 20,
  final double maxEstimationDistance = 0.5,
  final Range<double> travelSpeedRange = const .new(1, 100),
  final double maxLinearDeviation = 3.0,
  final double baselineLinearityConfidence = 0.4,
}) {
  void validate() {
    _validateGreaterThanZero(desiredNumberOfSamples, 'desiredNumberOfSamples');
    _validateGreaterThanZero(maxEstimationDistance, 'maxEstimationDistance');
    _validateRange(travelSpeedRange, 'travelSpeedRange', lowerBound: 0.0);
    _validateIsFiniteNumber(travelSpeedRange.max, 'travelSpeedRange.max');
    _validateGreaterThanZero(maxLinearDeviation, 'maxLinearDeviation');
    if (baselineLinearityConfidence < 0 || baselineLinearityConfidence > 1) {
      throw ArgumentError.value(
        baselineLinearityConfidence,
        'baselineLinearityConfidence',
        'must be between 0 and 1',
      );
    }
  }
}

final class const KalmanPredictorParams({
  final double processNoise = 0.01,
  final double measurementNoise = 0.1,
  final int minStableIteration = 4,
  final int maxTimeSamples = 20,
  final double minCatchupVelocity = 0.1,
  final double accelerationWeight = 0.5,
  final double jerkWeight = 0.1,
  final TimeSpan predictionInterval = const .new(0.032),
  final ConfidenceParams confidenceParams = const .new(),
}) extends PredictionParams {
  @override
  void validate() {
    _validateGreaterThanZero(processNoise, 'processNoise');
    _validateGreaterThanZero(measurementNoise, 'measurementNoise');
    _validateGreaterThanZero(minStableIteration, 'minStableIteration');
    _validateGreaterThanZero(maxTimeSamples, 'maxTimeSamples');
    _validateGreaterThanZero(minCatchupVelocity, 'minCatchupVelocity');
    _validateIsFiniteNumber(accelerationWeight, 'accelerationWeight');
    _validateIsFiniteNumber(jerkWeight, 'jerkWeight');
    _validateGreaterThanZero(predictionInterval, 'predictionInterval');
    confidenceParams.validate();
  }
}

final class const ExperimentalParams() {
  void validate() {}
}

final class const StrokeModelParams({
  final WobbleSmootherParams? wobbleSmootherParams = const .new(),
  final PositionModelerParams positionModelerParams = const .new(),
  final SamplingParams samplingParams = const .new(),
  final StylusStateModelerParams stylusStateModelerParams = const .new(),
  final PredictionParams predictionParams = const StrokeEndPredictorParams(),
  final ExperimentalParams experimentalParams = const .new(),
}) {
  void validate() {
    if (positionModelerParams.loopContractionMitigationParams != null &&
        !stylusStateModelerParams.useStrokeNormalProjection) {
      throw ArgumentError(
        'StylusStateModelerParams.useStrokeNormalProjection must be true when loop contraction mitigation is enabled.',
      );
    }

    wobbleSmootherParams?.validate();
    positionModelerParams.validate();
    samplingParams.validate();
    stylusStateModelerParams.validate();
    predictionParams.validate();
    experimentalParams.validate();
  }
}
