part of '../program.dart';

final class LayoutOverrides {
  final _map = <StatementId, LayoutResult>{};

  LayoutResult? of(StatementId id) => _map[id];

  bool get isEmpty => _map.isEmpty;

  void set(StatementId id, LayoutResult result) => _map[id] = result;
  void clear() => _map.clear();
}

extension type LayoutResult._((Vec2? offset, Size2? size) _) {
  LayoutResult({Vec2? offset, Size2? size}) : this._((offset, size));

  Vec2? get offset => _.$1;
  Size2? get size => _.$2;
}
