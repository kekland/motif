import 'package:geometry/vector/vector.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/position_modeler.dart';
import 'package:ink_stroke_modeler/src/prediction/input_predictor.dart';
import 'package:ink_stroke_modeler/src/types.dart';

final class StrokeEndPredictor implements InputPredictor {
  StrokeEndPredictor(this._positionModelerParams, this._samplingParams);

  final PositionModelerParams _positionModelerParams;
  final SamplingParams _samplingParams;
  Vec2? _lastPosition;

  @override
  void reset() => _lastPosition = null;

  @override
  void update(Vec2 position, Time time) => _lastPosition = position;

  @override
  void constructPrediction(TipState lastState, List<TipState> prediction) {
    prediction.clear();
    final anchor = _lastPosition;
    if (anchor == null) return;

    final modeler = PositionModeler()..reset(lastState, _positionModelerParams);
    modeler.modelEndOfStroke(
      anchor,
      .new(1.0 / _samplingParams.minOutputRate),
      _samplingParams.endOfStrokeMaxIterations,
      _samplingParams.endOfStrokeStoppingDistance,
      prediction,
    );
  }

  @override
  InputPredictor clone() {
    final clone = StrokeEndPredictor(_positionModelerParams, _samplingParams);
    clone._lastPosition = _lastPosition;
    return clone;
  }
}
