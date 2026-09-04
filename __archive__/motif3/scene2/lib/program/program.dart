import 'package:color/color.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';

part 'ref.dart';
part 'arg.dart';
part 'error.dart';
part 'statement.dart';
part 'context/resolver.dart';
part 'context/bindings.dart';
part 'context/style.dart';
part 'context/cell_graph.dart';
part 'context.dart';
part 'validation.dart';
part 'evaluation.dart';
part 'graph.dart';
part 'slice.dart';

part 'shape/corner_radius.dart';
part 'shape/shape.dart';

part 'layout/size.dart';

part 'resolvers/absorption.dart';
part 'resolvers/dissolution.dart';
part 'resolvers/embedding.dart';
part 'resolvers/transformation.dart';

part 'statements/base/placed_statement.dart';
part 'statements/base/shape_statement.dart';
part 'statements/base/layout_box_statement.dart';

part 'statements/frame_statement.dart';
part 'statements/vertex_statement.dart';
part 'statements/edge_statement.dart';
part 'statements/face_statement.dart';
part 'statements/fillet_statement.dart';
part 'statements/rectangle_statement.dart';

part 'delta/anchor.dart';
part 'delta/op.dart';
part 'delta.dart';

part 'style/vertex_style.dart';
part 'style/edge_style.dart';
part 'style/face_style.dart';
part 'style/style.dart';

part 'utils/partial.dart';

final class Program {
  Program(
    List<Statement> statements, {
    StyleOverrides? styleOverrides,
  }) : _statements = [],
       _styleOverrides = styleOverrides ?? .empty() {
    _replaceAll(statements);
  }

  final List<Statement> _statements;
  Iterable<Statement> get statements => _statements;
  Statement operator [](int index) => _statements[index];
  int get length => _statements.length;

  final StyleOverrides _styleOverrides;
  StyleOverrides get styleOverrides => _styleOverrides;

  final _statementIndex = <StatementId, int>{};
  final _graph = ProgramGraph();

  ProgramGraph get graph => _graph;

  int? indexOf(StatementId id) => _statementIndex[id];
  T? statement<T extends Statement>(StatementId id) {
    final i = indexOf(id);
    if (i == null) return null;
    return _statements[i] as T;
  }

  // --
  // Update
  // --

  void _reindexFrom(int index) {
    for (var i = index; i < _statements.length; i++) {
      _statementIndex[_statements[i].id] = i;
    }
  }

  void _insertAt(int index, Statement s) {
    _statements.insert(index, s);
    _reindexFrom(index);
    _graph._add(s);
    _assertValidate();
  }

  void _removeAt(int index) {
    final s = _statements.removeAt(index);
    _statementIndex.remove(s.id);
    _reindexFrom(index);
    _graph._remove(s);
    _assertValidate();
  }

  void _replaceAll(Iterable<Statement> statements) {
    _statements.clear();
    _statements.addAll(statements);
    _statementIndex.clear();
    _graph._clear();
    for (var i = 0; i < _statements.length; i++) {
      final s = _statements[i];
      _statementIndex[s.id] = i;
      _graph._add(s);
    }

    _assertValidate();
  }
}
