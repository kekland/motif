part of '_program.dart';

enum RemapResult { unchanged, changed, refused }

/// A [Remap] represents a mapping from a set of references to another set of references.
///
/// This can be used to update the references that statements point at when there's a destructive change in the program.
final class Remap {
  Remap._(this._cells, this._statements);
  Remap.cells(Map<CellRef, List<CellRef>> map) : this._(map, {});
  Remap.statements(Map<StatementId, StatementId> map) : this._({}, map);
  Remap.empty() : this._({}, {});

  final Map<CellRef, List<CellRef>> _cells;
  final Map<StatementId, StatementId> _statements;

  /// Cells that are renamed by this remap.
  Iterable<CellRef> get cells => _cells.keys;

  /// Statements that are renamed by this remap.
  Iterable<StatementId> get statements => _statements.keys;

  /// Returns the new [StatementId] for the given [id], or `null` if it is not renamed.
  StatementId? statement(StatementId id) => _statements[id];

  /// Returns a list of new [CellRef]s for the given [ref], or `null` if it is not renamed.
  List<CellRef>? cell(CellRef ref) {
    final remapped = _cells[ref];
    if (remapped != null) return remapped;

    final statement = _statements[ref.statementId];
    if (statement != null) return [ref.copyWith(namespace: statement.value)];

    return null;
  }

  /// Returns the result of remapping the given [ref] - with a condition that only one new [CellRef] is expected.
  (RemapResult, CellRef<H>) one<H extends CellHandle>(CellRef<H> ref) => switch (cell(ref)) {
    [final r] => (.changed, r as CellRef<H>),
    null => (.unchanged, ref),
    _ => (.refused, ref),
  };

  /// Returns the results of remapping the given [refs] - multiple [CellRef]s are expected.
  ///
  /// [kind] can be passed to ensure that the remap does not change the kind of any cell.
  (RemapResult, List<CellRef<H>>) many<H extends CellHandle>(Iterable<CellRef<H>> refs, {CellKind? kind}) {
    final out = <CellRef<H>>[];
    var touched = false;

    for (final r in refs) {
      final remapped = cell(r);
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

  void operator []=(CellRef key, List<CellRef> value) => _cells[key] = value;

  /// Appends the mappings from [other] to this remap.
  void add(Remap other) {
    _cells.addAll(other._cells);
    _statements.addAll(other._statements);
  }
}
