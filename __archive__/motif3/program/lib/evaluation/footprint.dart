part of '../program.dart';

final class FootprintIndex {
  final _readers = <CellKey, Set<StatementId>>{};
  final _writers = <CellKey, Set<StatementId>>{};

  void add(Commit c) {
    for (final k in c.reads) _readers.putIfAbsent(k, () => {}).add(c.statement.id);
    for (final k in c.writes) _writers.putIfAbsent(k, () => {}).add(c.statement.id);
  }

  void remove(Commit c) {
    for (final k in c.reads) _readers[k]?.remove(c.statement.id);
    for (final k in c.writes) _writers[k]?.remove(c.statement.id);
  }

  // Set<StatementId> touching({
  //   Set<CellKey> reads = const {},
  //   Set<CellKey> writes = const {},
  //   StatementId? except,
  // }) {
  //   final out = <StatementId>{};

  //   void take(Set<StatementId>? s) {
  //     if (s == null) return;
  //     for (final id in s) {
  //       if (id != except) out.add(id);
  //     }
  //   }

  //   for (final k in writes) {
  //     take(_readers[k]);
  //     take(_writers[k]);
  //   }

  //   for (final k in reads) {
  //     take(_writers[k]);
  //   }

  //   return out;
  // }
}
