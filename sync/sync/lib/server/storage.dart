import 'dart:typed_data';

import 'package:sqlite_async/sqlite_async.dart' as sqlite;
import 'package:sync/schema.dart' as pb;

/// An interface for working with storage locations managed by the system.
/// On web, this will use OPFS, and on all other platforms, it'll use `dart:io`.
abstract class StorageManager {
  Future<void> initialize();
  String getManagedPath(String id);
  Future<bool> exists(String path);
  Future<void> move(String from, String to);
  Future<void> delete(String path);

  Future<sqlite.SqliteDatabase> openIndexDatabase();
  Future<sqlite.SqliteDatabase> openDatabase(String path, {sqlite.SqliteJournalMode? journalMode});
}

abstract class IndexStorage {
  Future<void> initialize();
  Future<List<pb.SceneInfo>> listScenes();
  Future<pb.SceneInfo> create(pb.Program program, {String? title, String? path});
  Future<pb.SceneInfo> add(String path);
  Future<SceneStorage?> open(String id);
  Future<void> close();
}

abstract class SceneStorage {
  Future<pb.SceneInfo> loadInfo();
  Future<void> saveInfo(pb.SceneInfo info);

  Future<pb.Program> loadProgram();
  Future<void> saveProgram(pb.Program program);

  Future<Uint8List?> readAsset(String hash);
  Future<void> writeAsset(String hash, Uint8List data);
  Future<void> close();
}
