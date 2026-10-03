import 'dart:js_interop';

import 'package:sqlite_async/sqlite_async.dart' as sqlite;
import 'package:sync/sync.dart' as sync;
import 'package:web/web.dart' as web;

Future<sync.StorageManager> createStorageManagerImpl({
  String? rootDirectory,
  required String sqliteWasmUri,
  required String sqliteWorkerUri,
}) async {
  final manager = WebStorageManager(
    sqliteWasmUri: sqliteWasmUri,
    sqliteWorkerUri: sqliteWorkerUri,
  );

  await manager.initialize();
  return manager;
}

final class WebStorageManager implements sync.StorageManager {
  WebStorageManager({
    this.sqliteWasmUri = 'sqlite3.wasm',
    this.sqliteWorkerUri = 'sqlite3.worker.js',
  });

  final String sqliteWasmUri;
  final String sqliteWorkerUri;
  late final web.FileSystemDirectoryHandle rootDirectory;
  var _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    rootDirectory = await web.window.navigator.storage.getDirectory().toDart;
    _initialized = true;
  }

  @override
  String getManagedPath(String id) => '$id.motif';

  @override
  Future<bool> exists(String path) async {
    try {
      await rootDirectory.getFileHandle(path).toDart;
      return true;
    } catch (e) {
      if (e.isA<web.DOMException>()) {
        if ((e as web.DOMException).name == 'NotFoundError') return false;
      }

      rethrow;
    }
  }

  @override
  Future<void> move(String from, String to) async {
    final src = await (await rootDirectory.getFileHandle(from).toDart).getFile().toDart;
    final dst = await (await rootDirectory.getFileHandle(to, .new(create: true)).toDart).createWritable().toDart;
    await dst.write(src).toDart;
    await dst.close().toDart;
    await delete(from);
  }

  @override
  Future<void> delete(String path) async {
    await rootDirectory.removeEntry(path).toDart;
  }

  @override
  Future<sqlite.SqliteDatabase> openIndexDatabase() => openDatabase('index.db');

  @override
  Future<sqlite.SqliteDatabase> openDatabase(String path, {sqlite.SqliteJournalMode? journalMode}) async {
    return sqlite.SqliteDatabase(
      path: path,
      options: .new(
        webSqliteOptions: .new(wasmUri: sqliteWasmUri, workerUri: sqliteWorkerUri),
      ),
    );
  }
}
