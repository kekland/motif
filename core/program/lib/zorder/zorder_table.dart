part of '../program.dart';

final class ZOrderTable<T> {
  ZOrderTable();

  final _entries = <CellRef, T>{};
  Iterable<MapEntry<CellRef, T>> get entries => _entries.entries;

  T? of(CellRef r) => _entries[r];
  void set(CellRef r, T? value) {
    _entries.remove(r);
    if (value != null) _entries[r] = value;
  }
}
