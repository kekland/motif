part of '../program.dart';

enum RemapResult { unchanged, changed, refused }

extension type const Remap._(Map<CellRef, List<CellRef>> map) implements Object {
  Remap.empty() : this._({});

  Iterable<CellRef> get keys => map.keys;
  Iterable<List<CellRef>> get values => map.values;

  List<CellRef>? operator [](CellRef key) => map[key];
  void operator []=(CellRef key, List<CellRef> value) => map[key] = value;

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

  void add(Remap other) {
    map.addAll(other.map);
  }
}
