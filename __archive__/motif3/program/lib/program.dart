import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:color/color.dart';

part 'selector.dart';
part 'statement.dart';
part 'evaluation.dart';
part 'delta.dart';
part 'slice.dart';

part 'evaluation/lineage.dart';
part 'evaluation/footprint.dart';
part 'evaluation/context.dart';
part 'evaluation/dependency_graph.dart';

part 'resolvers/rebase.dart';
part 'resolvers/edit.dart';
part 'resolvers/embedding.dart';

part 'delta/anchor.dart';
part 'delta/op.dart';

part 'style/style.dart';
part 'style/vertex_style.dart';
part 'style/edge_style.dart';
part 'style/face_style.dart';

part 'utils/partial.dart';

part 'statements/base/placed_statement.dart';
part 'statements/frame_statement.dart';
part 'statements/vertex_statement.dart';
part 'statements/edge_statement.dart';
part 'statements/face_statement.dart';
part 'statements/cut_edge_statement.dart';
part 'statements/fillet_face_statement.dart';

final class Program {
  Program(this._statements, this._styleOverrides) {
    _reindex(0);
  }

  final List<Statement> _statements;
  Iterable<Statement> get statements => _statements;
  final _statementIndex = <StatementId, int>{};

  final StyleOverrides _styleOverrides;
  StyleOverrides get styleOverrides => _styleOverrides;

  int get length => _statements.length;
  bool get isEmpty => _statements.isEmpty;

  Statement operator [](int index) => _statements[index];
  int? indexOf(StatementId id) => _statementIndex[id];
  Statement? statement(StatementId id) {
    final index = _statementIndex[id];
    if (index == null) return null;
    return _statements[index];
  }

  void _reindex(int from) {
    for (var i = from; i < _statements.length; i++) {
      _statementIndex[_statements[i].id] = i;
    }
  }

  void _replaceRange(int start, int end, List<Statement> with_) {
    for (var i = start; i < end; i++) _statementIndex.remove(_statements[i].id);
    _statements.replaceRange(start, end, with_);
    _reindex(start);
  }
}
