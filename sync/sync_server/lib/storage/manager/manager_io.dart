import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqlite_async/sqlite_async.dart' as sqlite;
import 'package:sync/sync.dart' as sync;

Future<sync.StorageManager> createStorageManagerImpl({
  String? rootDirectory,
  required String sqliteWasmUri,
  required String sqliteWorkerUri,
}) async {
  final manager = IoStorageManager(rootDirectory: rootDirectory!);
  manager.initialize();
  return manager;
}

final class IoStorageManager implements sync.StorageManager {
  IoStorageManager({required this.rootDirectory});

  final String rootDirectory;

  @override
  Future<void> initialize() async {
    await Directory(rootDirectory).create(recursive: true);
  }

  @override
  String getManagedPath(String id) => path.join(rootDirectory, '$id.motif');

  @override
  Future<bool> exists(String filePath) async {
    return File(filePath).exists();
  }

  @override
  Future<void> move(String from, String to) async {
    await File(from).rename(to);
  }

  @override
  Future<void> delete(String filePath) async {
    await File(filePath).delete();
  }

  @override
  Future<sqlite.SqliteDatabase> openIndexDatabase() => openDatabase(
    path.join(rootDirectory, 'index.db'),
    journalMode: .wal,
  );

  @override
  Future<sqlite.SqliteDatabase> openDatabase(String path, {sqlite.SqliteJournalMode? journalMode}) async {
    return sqlite.SqliteDatabase(
      path: path,
      options: .new(journalMode: journalMode ?? .wal),
    );
  }
}
