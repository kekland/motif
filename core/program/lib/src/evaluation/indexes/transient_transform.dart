part of '../../_program.dart';

final class TransientTransforms {
  final _local = <StatementId, Mat4>{};
  final _global = <StatementId, Mat4>{};

  Mat4? localOf(StatementId id) => _local[id];
  Mat4? globalOf(StatementId id) => _global[id];

  bool hasLocal(StatementId id) => _local.containsKey(id);
  bool hasGlobal(StatementId id) => _global.containsKey(id);

  bool setLocalTransient(StatementId id, Mat4? m) => _setTransient(_local, id, m);
  bool setGlobalTransient(StatementId id, Mat4? m) => _setTransient(_global, id, m);

  bool _setTransient(Map<StatementId, Mat4> map, StatementId id, Mat4? m) {
    final before = map[id];
    if (before == null && m == null) return false;
    if (before != null && m != null && before.equals(m)) return false;
    if (m == null) {
      map.remove(id);
      return true;
    }

    map[id] = m;
    return true;
  }
}
