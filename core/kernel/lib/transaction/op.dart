part of '../kernel.dart';

sealed class Op<R> {
  void execute(Transaction t) => _execute(t, false);
  R result(Transaction t) => _execute(t, true)!;

  R? _execute(Transaction t, bool produceResult);
  bool topologyEquals(Op other) => false;
}

final class OpRecord<O extends Op> {
  OpRecord(this.def, this.tag);

  O def;
  final int tag;
  var _subCount = 0;

  final _created = <CellHandle>[];
  final _mutations = <Mutation>[];
  final _geometry = <CellRef, CellGeometry>{};
  // final _cache = <(CellRef, Object), (int, Object?)>{};

  void _reshape(O def) {
    this.def = def;
  }
}
