part of '../_program.dart';

final class ZOrderTable {
  ZOrderTable(this._entries);
  ZOrderTable.empty() : _entries = {};

  final Map<CellRef, ZAnchor> _entries;
  Iterable<MapEntry<CellRef, ZAnchor>> get entries => _entries.entries;

  ZAnchor? of(CellRef r) => _entries[r];
  void set(CellRef r, ZAnchor? value) {
    _entries.remove(r);
    if (value != null) _entries[r] = value;
  }

  ZOrderTable clone() => .new({..._entries});
}
