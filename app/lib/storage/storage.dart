import 'package:editor/imports.dart';
import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

import 'database_factory_io.dart' if (dart.library.js_interop) 'database_factory_web.dart';

final _uuid = Uuid();

final storage = SceneStorage.instance;

final class SceneStorage {
  SceneStorage(this._db);

  static Future<void> initialize() async {
    final db = await openDatabase('scene_storage');
    _instance = SceneStorage(db);
  }

  static SceneStorage? _instance;
  static SceneStorage get instance => _instance!;

  final Database _db;

  static final _info = stringMapStoreFactory.store('info');
  static final _data = StoreRef<String, Blob>('data');

  Future<void> _persistProgram(String id, Program program) {
    return _db.transaction((txn) async {
      final bytes = program.encode().writeToBuffer();
      final now = DateTime.now().millisecondsSinceEpoch;

      await _data.record(id).put(txn, Blob(bytes));
      await _info.record(id).put(txn, {'modified': now});
    });
  }

  Future<void> saveScene(String id, Program program) {
    return _persistProgram(id, program);
  }

  Future<(String, Program)> createScene() async {
    final id = _uuid.v4();
    final scene = Scene(id: id, program: .empty());
    await _persistProgram(id, scene.program);
    return (id, scene.program);
  }

  Future<(String, Program)> loadScene(String id) async {
    final record = await _data.record(id).get(_db);
    if (record == null) throw Exception('Scene not found');
    final program = Program.decodeRaw(record.bytes)!;
    return (id, program);
  }

  Future<void> deleteScene(String id) {
    return _db.transaction((txn) async {
      await _data.record(id).delete(txn);
      await _info.record(id).delete(txn);
    });
  }

  Future<List<String>> listScenes() async {
    final records = await _info.find(_db);
    return records.map((record) => record.key).toList();
  }
}
