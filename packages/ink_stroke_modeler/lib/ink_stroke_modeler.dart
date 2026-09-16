export 'stroke_modeler.dart';
export 'src/params.dart';
export 'src/types.dart';

import 'package:ink_stroke_modeler/stroke_modeler.dart';
import 'package:ink_stroke_modeler/src/params.dart';
import 'package:ink_stroke_modeler/src/types.dart';

List<Result> modelStroke(List<Input> inputs, StrokeModelParams params) {
  final modeler = StrokeModeler()..reset(params);
  return [for (final input in inputs) ...modeler.update(input)];
}
