import 'package:editor/imports.dart';
import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';
import 'package:schema/program.dart' as pb;

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

  static final _remote = stringMapStoreFactory.store('remote');

  Future<void> _persistProgram(String id, pb.Program program) {
    return _db.transaction((txn) async {
      final bytes = program.writeToBuffer();
      final now = DateTime.now().millisecondsSinceEpoch;

      await _data.record(id).put(txn, Blob(bytes));
      await _info.record(id).put(txn, {'modified': now});
    });
  }

  Future<void> saveScene(String id, Program program) {
    return _persistProgram(id, program.encode());
  }

  final _queue = <pb.ProgramDelta>[];
  var _processing = false;
  Future<void> applyDelta(String id, pb.ProgramDelta delta) async {
    _queue.add(delta);
    if (_processing) return;
    _processing = true;

    var program = pb.Program.fromBuffer((await _data.record(id).get(_db))!.bytes);
    while (_queue.isNotEmpty) {
      final delta = _queue.removeAt(0);
      program = _applyDelta(program, delta);
    }
    await _persistProgram(id, program);
    _processing = false;

    if (_queue.isNotEmpty) await applyDelta(id, _queue.removeAt(0));
  }

  Future<(String, Program)> createScene() async {
    final id = _uuid.v4();
    final scene = Scene(id: id, program: .empty());
    await _persistProgram(id, scene.program.encode());
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

  Future<void> persistRemoteScene(String id) {
    return _db.transaction((txn) async {
      await _remote.record(id).put(txn, {});
    });
  }

  Future<List<String>> listRemoteScenes() async {
    final records = await _remote.find(_db);
    return records.map((record) => record.key).toList();
  }

  Future<void> deleteRemoteScene(String id) {
    return _db.transaction((txn) async {
      await _remote.record(id).delete(txn);
    });
  }
}

pb.Program _applyDelta(pb.Program program, pb.ProgramDelta delta) {
  final copy = program.deepCopy();

  void applyStatement(pb.StatementChange change) {
    final anchor = change.anchor;
    final index = switch (anchor.whichValue()) {
      .start => 0,
      .end => copy.statements.length,
      .at => copy.statements.indexWhere((s) => s.id == anchor.at),
      .after => copy.statements.indexWhere((s) => s.id == anchor.after) + 1,
      .notSet => -1,
    };

    if (index < 0 || index + change.removed.length > copy.statements.length) {
      throw StateError('invalid statement anchor: $anchor');
    }

    if (anchor.whichValue() == .after && index == 0) throw StateError('invalid statement anchor: $anchor');

    for (var i = 0; i < change.removed.length; i++) {
      if (copy.statements[index + i].id != change.removed[i].id) {
        throw StateError('mismatched removed statement: ${change.removed[i].id} at index $i');
      }
    }

    copy.statements.replaceRange(index, index + change.removed.length, change.inserted);
  }

  void applyStyle(pb.StyleChange change) {
    if (!change.hasAfter()) {
      copy.style.entries.removeWhere((e) => e.ref == change.ref);
      return;
    }

    final entry = copy.style.entries.firstWhereOrNull((e) => e.ref == change.ref);
    if (entry == null) {
      copy.style.entries.add(.new(ref: change.ref, value: change.after));
    } else {
      entry.value = change.after;
    }
  }

  for (final change in delta.changes) {
    final _ = switch (change.whichValue()) {
      .statement => applyStatement(change.statement),
      .style => applyStyle(change.style),
      .empty => null,
      .notSet => throw StateError('invalid change: $change'),
    };
  }

  return copy;
}
