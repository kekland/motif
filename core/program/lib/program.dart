import 'dart:collection';
import 'dart:math' as math;

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:listen/listen.dart';

part 'TEMP.dart';

part 'selector.dart';
part 'statement.dart';
part 'evaluation.dart';
part 'errors.dart';
part 'delta.dart';

part 'delta/anchor.dart';
part 'delta/op.dart';

part 'style/style.dart';
part 'style/vertex_style.dart';
part 'style/edge_style.dart';
part 'style/face_style.dart';

part 'selectors/cell_selector.dart';
part 'selectors/chain_selector.dart';
part 'selectors/incident_edge_selector.dart';
part 'selectors/corners_selector.dart';
part 'selectors/products_selector.dart';
part 'selectors/parent_selector.dart';

part 'evaluation/commit.dart';
part 'evaluation/context.dart';
part 'evaluation/graph.dart';
part 'evaluation/lineage.dart';
part 'evaluation/pass.dart';

part 'routers/dissolve_router.dart';
part 'routers/transform_router.dart';

part 'layout/shape.dart';
part 'layout/size.dart';
part 'layout/insets.dart';
part 'layout/align.dart';
part 'layout/layout.dart';
part 'layout/tree.dart';
part 'layout/layouts/stack.dart';
part 'layout/layouts/flex.dart';

part 'statements/base/placed_statement.dart';
part 'statements/base/layout_box_statement.dart';
part 'statements/base/shape_statement.dart';

part 'statements/frame_statement.dart';
part 'statements/vertex_statement.dart';
part 'statements/edge_statement.dart';
part 'statements/face_statement.dart';
part 'statements/cut_edge_statement.dart';
part 'statements/fillet_face_statement.dart';
part 'statements/dissolve_statement.dart';
part 'statements/rectangle_statement.dart';
part 'statements/container_statement.dart';

part 'utils/partial.dart';

final class Program {
  Program(this._statements) {
    _reindex(0, _statements.length);
  }

  Program.empty(): this([]);

  final List<Statement> _statements;
  Iterable<Statement> get statements => _statements;
  final _statementIndex = <StatementId, int>{};

  int get length => _statements.length;
  Statement operator [](int index) => _statements[index];
  int? indexOf(StatementId id) => _statementIndex[id];
  Statement? statement(StatementId id) {
    final index = _statementIndex[id];
    if (index == null) return null;
    return _statements[index];
  }

  void _reindex(int from, int to) {
    for (var i = from; i < to; i++) {
      _statementIndex[_statements[i].id] = i;
    }
  }

  void _replace(int index, List<Statement> removed, List<Statement> inserted) {
    _statements.replaceRange(index, index + removed.length, inserted);

    if (inserted.length == removed.length) {
      _reindex(index, index + inserted.length);
    } else {
      _reindex(index, _statements.length);
    }
  }
}
