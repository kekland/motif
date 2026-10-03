import 'dart:typed_data';

import 'package:sqlite_async/sqlite_async.dart' as sqlite;
import 'package:sync/server.dart' as sync;
import 'package:sync/schema.dart' as pb;

const _applicationId = 0x4D4F5446; // MOTF
const _schemaVersion = 1;

class SqliteSceneStorage implements sync.SceneStorage {
  SqliteSceneStorage._(this.db);

  final sqlite.SqliteDatabase db;

  static Future<SqliteSceneStorage> create(
    sqlite.SqliteDatabase db, {
    required pb.SceneInfo info,
    required pb.Program program,
  }) async {
    await db.writeTransaction((txn) async {
      await txn.execute('PRAGMA application_id = $_applicationId');
      await txn.execute('PRAGMA user_version = $_schemaVersion');
      await txn.execute('CREATE TABLE info (id INTEGER PRIMARY KEY CHECK (id = 1), bytes BLOB NOT NULL)');
      await txn.execute('CREATE TABLE program (id INTEGER PRIMARY KEY CHECK (id = 1), bytes BLOB NOT NULL)');
      await txn.execute('CREATE TABLE assets (hash TEXT PRIMARY KEY, bytes BLOB NOT NULL)');
      await txn.execute('INSERT INTO info (id, bytes) VALUES (1, ?)', [info.writeToBuffer()]);
      await txn.execute('INSERT INTO program (id, bytes) VALUES (1, ?)', [program.writeToBuffer()]);
    });

    return ._(db);
  }

  static Future<SqliteSceneStorage> open(sqlite.SqliteDatabase db) async {
    final id = (await db.get('PRAGMA application_id'))['application_id'] as int;
    if (id != _applicationId) {
      await db.close();
      throw FormatException('not a MOTF database');
    }

    final version = (await db.get('PRAGMA user_version'))['user_version'] as int;
    if (version > _schemaVersion) {
      await db.close();
      throw FormatException('unsupported schema version');
    }

    return ._(db);
  }

  @override
  Future<pb.SceneInfo> loadInfo() async => .fromBuffer(await _readBytes('info'));

  @override
  Future<void> saveInfo(pb.SceneInfo info) => db.execute(
    'UPDATE info SET bytes = ? WHERE id = 1',
    [info.writeToBuffer()],
  );

  @override
  Future<pb.Program> loadProgram() async => pb.Program.fromBuffer(await _readBytes('program'));

  @override
  Future<void> saveProgram(pb.Program program) => db.execute(
    'UPDATE program SET bytes = ? WHERE id = 1',
    [program.writeToBuffer()],
  );

  @override
  Future<Uint8List?> readAsset(pb.Hash hash) async {
    final row = await db.getOptional('SELECT bytes FROM assets WHERE hash = ?', [hash.value]);
    return row?['bytes'] as Uint8List?;
  }

  @override
  Future<void> writeAsset(pb.Hash hash, Uint8List bytes) => db.execute(
    'INSERT OR IGNORE INTO assets (hash, bytes) VALUES (?, ?)',
    [hash.value, bytes],
  );

  @override
  Future<void> close() => db.close();

  Future<Uint8List> _readBytes(String table) async {
    final row = await db.get('SELECT bytes FROM $table WHERE id = 1');
    return row['bytes'] as Uint8List;
  }
}
