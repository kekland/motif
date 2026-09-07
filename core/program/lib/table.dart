part of 'program.dart';

final class CellTable<T> {
  final _entries = <CellRef, T>{};

  T? of(CellRef r) => _entries[r];
  void set(CellRef r, T? value) => value == null ? _entries.remove(r) : _entries[r] = value;
}
