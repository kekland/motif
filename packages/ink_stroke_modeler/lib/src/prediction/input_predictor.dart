import 'package:geometry/geometry.dart';
import 'package:ink_stroke_modeler/src/types.dart';

abstract interface class InputPredictor {
  void reset();
  void update(Vec2 position, Time time);
  void constructPrediction(TipState lastState, List<TipState> prediction);
  InputPredictor clone();
}
