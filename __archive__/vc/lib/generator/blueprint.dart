import 'dart:math';

import 'package:blueprint/blueprint.dart' as bp;
import 'package:geometry/geometry.dart';
import '../vc.dart';

export 'blueprint.g.dart';

part 'nodes/_shared.dart';
part 'nodes/geometry_output_node.dart';
part 'nodes/join_geometry_node.dart';
part 'nodes/primitive_vertex_node.dart';
part 'nodes/random_vector_node.dart';
part 'nodes/shift_geometry_node.dart';
part 'nodes/connect_vertices_node.dart';
part 'nodes/instance_on_vertices_node.dart';
part 'nodes/instance_on_knots_node.dart';
part 'nodes/geometry_input_node.dart';
part 'nodes/symbol_node.dart';

class EvaluationContext extends bp.EvaluationContext {
  EvaluationContext._({this.index, this.element});

  EvaluationContext.empty() : this._();
  factory EvaluationContext.filled({required int index, required Object element}) = FilledEvaluationContext;

  final int? index;
  final Object? element;
}

class FilledEvaluationContext extends EvaluationContext {
  FilledEvaluationContext({
    required int super.index,
    required Object super.element,
  }) : super._();

  @override
  int get index => super.index!;

  @override
  Object get element => super.element!;

  int get seed => element.hashCode;
}

extension EnvironmentExtension on bp.Node {
  VectorComplexContext get context => getEnvironment<VectorComplexContext>();
  Cell get cell => getEnvironment<Cell>();
}
