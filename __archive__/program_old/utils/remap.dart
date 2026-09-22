part of '../program.dart';

enum RemapResult { unchanged, changed, refused }

final class Remap {
  Remap.refs(Map<CellRef, List<CellRef>> map) : _map = map, _namespaceMap = {};
  Remap.namespace(Map<StatementId, StatementId> map) : _map = {}, _namespaceMap = map;
  Remap.empty() : _map = {}, _namespaceMap = {};

  final Map<CellRef, List<CellRef>> _map;
  final Map<StatementId, StatementId> _namespaceMap;

  Iterable<CellRef> get keys => _map.keys;
  Iterable<List<CellRef>> get values => _map.values;

  List<CellRef>? operator [](CellRef ref) {
    final remapped = _map[ref];
    if (remapped != null) return remapped;

    final namespace = _namespaceMap[ref.statementId];
    if (namespace != null) return [ref.copyWith(namespace: namespace.value)];

    return null;
  }

  void operator []=(CellRef key, List<CellRef> value) => _map[key] = value;

  (RemapResult, CellRef<H>) one<H extends CellHandle>(CellRef<H> ref) => switch (this[ref]) {
    [final r] => (.changed, r as CellRef<H>),
    null => (.unchanged, ref),
    _ => (.refused, ref),
  };

  (RemapResult, List<CellRef<H>>) many<H extends CellHandle>(Iterable<CellRef<H>> refs, {CellKind? kind}) {
    final out = <CellRef<H>>[];
    var touched = false;

    for (final r in refs) {
      final remapped = this[r];
      if (remapped == null) {
        out.add(r);
      } else {
        touched = true;
        for (final r in remapped) {
          if (kind != null && r.kind != kind) return (.refused, refs.toList());
          out.add(r as CellRef<H>);
        }
      }
    }

    return touched ? (.changed, out) : (.unchanged, refs.toList());
  }

  StatementId? statement(StatementId id) => _namespaceMap[id];

  void add(Remap other) {
    _map.addAll(other._map);
  }
}
