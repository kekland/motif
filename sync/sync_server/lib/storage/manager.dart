import 'package:sync/sync.dart' as sync;

import 'manager/manager_io.dart' if (dart.library.js_interop) 'manager/manager_web.dart';

Future<sync.StorageManager> createStorageManager({
  String? rootDirectory,
}) {
  return createStorageManagerImpl(
    rootDirectory: rootDirectory,
    sqliteWasmUri: 'sqlite3.wasm',
    sqliteWorkerUri: 'sqlite3.worker.js',
  );
}
