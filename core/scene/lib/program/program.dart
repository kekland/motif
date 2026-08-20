import 'dart:math' as math;

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:color/color.dart';
import 'package:scene/scene.dart';

part 'builder.dart';
part 'context.dart';
part 'statement.dart';
part 'ref.dart';
part 'anchor.dart';
part 'utils.dart';
part 'evaluate.dart';
part 'delta.dart';

part 'partials/partials.dart';

part 'style/style.dart';
part 'style/edge_style.dart';
part 'style/face_style.dart';

part 'layout/insets.dart';
part 'layout/layout.dart';
part 'layout/overrides.dart';
part 'layout/shape.dart';
part 'layout/box.dart';
part 'layout/size.dart';
part 'layout/solver.dart';
part 'layout/layouts/flex.dart';
part 'layout/layouts/stack.dart';
part 'layout/shapes/circle_shape.dart';
part 'layout/shapes/rectangle_shape.dart';
part 'layout/shapes/triangle_shape.dart';

part 'router/dissolve_router.dart';
part 'router/transform_router.dart';

part 'statements/frame_statement.dart';
part 'statements/vertex_statement.dart';
part 'statements/edge_statement.dart';
part 'statements/face_statement.dart';
part 'statements/cut_edge_statement.dart';
part 'statements/glue_vertices_statement.dart';
part 'statements/rectangle_statement.dart';
part 'statements/container_statement.dart';
part 'statements/shape_statement.dart';
part 'statements/triangle_statement.dart';
part 'statements/circle_statement.dart';

final class Program {
  Program(List<Statement> statements) : _statements = [...statements];

  final List<Statement> _statements;

  Iterable<Statement> get statements => _statements;
  int get length => _statements.length;
  Statement operator [](int index) => _statements[index];

  int? indexOf(StatementId id) {
    final i = _statements.indexWhere((s) => s.id == id);
    if (i == -1) return null;
    return i;
  }

  T? byId<T extends Statement>(StatementId id) {
    final i = indexOf(id);
    if (i == null) return null;
    return _statements[i] as T;
  }

  void _insertAt(int index, Statement s) => _statements.insert(index, s);
  void _removeAt(int index) => _statements.removeAt(index);

  void replaceAll(Iterable<Statement> statements) {
    _statements
      ..clear()
      ..addAll(statements);
  }

  Iterable<LayoutBox> get layoutBoxes => _statements.whereType<LayoutBox>();
}
