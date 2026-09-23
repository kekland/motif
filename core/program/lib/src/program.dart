part of '_program.dart';

/// A [Program] is a representation of a design document in a non-destructive form.
///
/// Programs consist of [Statement]s that will execute in a linear order, each producing kernel operations and affecting
/// the resulting document.
///
/// To evaluate a program, an [Evaluation] is used.
final class Program {
  Program(this._statements, {StyleTable? styles, ZOrderTable? zOrders})
    : styles = styles ?? .empty(),
      zOrders = zOrders ?? .empty() {
    _reindex(0, length);
  }

  factory Program.decode(gen.Program program) => ProgramCodec.decodeProgram(program);
  static Program? decodeRaw(Uint8List data) => ProgramCodec.decodeRaw(() => .decode(.fromBuffer(data)));

  Program.empty() : _statements = [], styles = .empty(), zOrders = .empty();

  final List<Statement> _statements;
  Iterable<Statement> get statements => _statements;
  final _statementIndex = <StatementId, int>{};

  final StyleTable styles;
  final ZOrderTable zOrders;

  int get length => _statements.length;
  Statement operator [](int index) => _statements[index];
  int? indexOf(StatementId id) => _statementIndex[id];
  bool contains(StatementId id) => _statementIndex.containsKey(id);
  S? statement<S extends Statement>(StatementId id) {
    final index = _statementIndex[id];
    if (index == null) return null;
    return _statements[index] as S;
  }

  /// Reindexes the statements in the internal index.
  void _reindex(int from, int to) {
    for (var i = from; i < to; i++) {
      _statementIndex[_statements[i].id] = i;
    }
  }

  /// Replaces a range of statements and updates the index. Only called by the evaluation.
  void _replace(int index, List<Statement> removed, List<Statement> inserted) {
    _statements.replaceRange(index, index + removed.length, inserted);

    if (inserted.length == removed.length) {
      _reindex(index, index + inserted.length);
    } else {
      _reindex(index, _statements.length);
    }
  }

  Program clone() => .new(
    _statements.toList(),
    styles: styles.clone(),
    zOrders: zOrders.clone(),
  );
}
