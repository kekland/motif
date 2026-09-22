part of '../_program.dart';

final class StyleTable {
  StyleTable(this._entries);
  StyleTable.empty() : _entries = {};

  final Map<CellRef, CellStylePartial> _entries;
  Iterable<MapEntry<CellRef, CellStylePartial>> get entries => _entries.entries;

  CellStylePartial? of(CellRef r) => _entries[r];
  void set(CellRef r, CellStylePartial? value) => value == null ? _entries.remove(r) : _entries[r] = value;

  StyleTable clone() => .new({..._entries});
}
