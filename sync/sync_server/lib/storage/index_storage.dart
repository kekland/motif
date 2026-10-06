import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:sync_server/storage.dart';
import 'package:sqlite_async/sqlite_async.dart' as sqlite;
import 'package:sync/server.dart' as sync;
import 'package:sync/schema.dart' as pb;

class SqliteIndexStorage implements sync.IndexStorage {
  SqliteIndexStorage(this.manager);

  final sync.StorageManager manager;
  late final sqlite.SqliteDatabase db;

  @override
  Future<void> initialize() async {
    await manager.initialize();
    db = await manager.openIndexDatabase();
    await db.execute('''
      CREATE TABLE IF NOT EXISTS scenes (
        id TEXT PRIMARY KEY,
        path TEXT NOT NULL UNIQUE,
        updated_at INTEGER NOT NULL,
        info BLOB NOT NULL
      )
    ''');
  }

  @override
  Future<List<pb.SceneInfo>> listScenes() async {
    final results = await db.getAll('SELECT info FROM scenes ORDER BY updated_at DESC');
    return results.map((r) => pb.SceneInfo.fromBuffer(r['info'] as Uint8List)).toList();
  }

  @override
  Future<pb.SceneInfo> create(pb.Program program, {String? path}) async {
    final isManaged = path == null;
    final info = pb.SceneInfo(
      id: uuid.v4(),
      title: program.settings.title,
      updatedAt: .new(DateTime.now().millisecondsSinceEpoch),
      managed: isManaged,
    );

    final resolvedPath = path ?? manager.getManagedPath(info.id);
    final sceneDb = await _openScene(resolvedPath, isManaged);
    final scene = await SqliteSceneStorage.create(sceneDb, info: info, program: program);
    await scene.close();

    await _upsertInfo(resolvedPath, info);
    return info;
  }

  @override
  Future<pb.SceneInfo> add(String path) async {
    final scene = await SqliteSceneStorage.open(await _openScene(path, false));

    try {
      var info = await scene.loadInfo();
      final existing = await db.getOptional('SELECT path FROM scenes WHERE id = ?', [info.id]);

      if (existing != null && existing['path'] != path) {
        final existingPath = existing['path'] as String;
        if (await manager.exists(existingPath)) {
          info = info.deepCopy()..id = uuid.v4();
          await scene.saveInfo(info);
        } else {
          await db.execute('DELETE FROM scenes WHERE id = ?', [info.id]);
        }
      }

      if (info.managed) await scene.saveInfo(info = info.deepCopy()..managed = false);
      await _upsertInfo(path, info);
      return info;
    } finally {
      await scene.close();
    }
  }

  @override
  Future<sync.SceneStorage?> open(String id) async {
    final row = await db.getOptional('SELECT path, info FROM scenes WHERE id = ?', [id]);
    if (row == null) return null;

    final path = row['path'] as String;
    final info = pb.SceneInfo.fromBuffer(row['info'] as Uint8List);
    if (!info.managed && !await manager.exists(path)) return null;
    return await SqliteSceneStorage.open(await _openScene(path, info.managed));
  }

  @override
  Future<void> close() => db.close();

  @override
  Future<void> updateInfo(pb.SceneInfo info) => db.execute(
    'UPDATE scenes SET info = ? WHERE id = ?',
    [info.writeToBuffer(), info.id],
  ); 

  Future<void> _upsertInfo(String path, pb.SceneInfo info) => db.execute(
    'INSERT INTO scenes (id, path, updated_at, info) VALUES (?, ?, ?, ?) '
    'ON CONFLICT(id) DO UPDATE SET path = excluded.path, updated_at = excluded.updated_at, info = excluded.info',
    [info.id, path, info.updatedAt.toInt(), info.writeToBuffer()],
  );

  Future<sqlite.SqliteDatabase> _openScene(String path, bool managed) {
    return manager.openDatabase(path, journalMode: managed ? .wal : .delete);
  }
}
