import 'dart:typed_data';

import 'package:schema/program.dart' as pb;
import 'package:sqlite3/sqlite3.dart';

final class SceneStorage {
  SceneStorage(String path) : _db = sqlite3.open(path) {
    _db.execute('PRAGMA journal_mode = WAL');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS scenes (
        id TEXT PRIMARY KEY,
        program BLOB NOT NULL,
        modified INTEGER NOT NULL
      ) STRICT
    ''');

    _select = _db.prepare('SELECT * FROM scenes WHERE id = ?');
    _upsert = _db.prepare('''
      INSERT INTO scenes (id, program, modified) VALUES (?, ?, ?)
      ON CONFLICT (id) DO UPDATE SET program = excluded.program, modified = excluded.modified
    ''');
  }

  final Database _db;
  late final PreparedStatement _select;
  late final PreparedStatement _upsert;

  Future<pb.Program?> load(String id) async {
    final rows = _select.select([id]);
    if (rows.isEmpty) return null;
    return pb.Program.fromBuffer(rows.first['program'] as Uint8List);
  }

  Future<void> save(String id, pb.Program program) async {
    final modified = DateTime.now().millisecondsSinceEpoch;
    _upsert.execute([id, program.writeToBuffer(), modified]);
  }

  void dispose() {
    _select.close();
    _upsert.close();
    _db.close();
  }
}
