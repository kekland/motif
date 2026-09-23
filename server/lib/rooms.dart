import 'package:schema/program.dart' as pb;
import 'package:server/imports.dart';

final _uuid = const Uuid();

final class Rooms {
  new(this._storage);

  final SceneStorage _storage;
  final _rooms = <String, Future<Room?>>{};

  Future<Room?> join(String id, WebSocketChannel channel, Client client) async {
    while (true) {
      final loading = load(id);
      final room = await loading;
      if (room == null) return null;
      if (_rooms[id] != loading) continue;
      room.join(channel, client);
      return room;
    }
  }

  Future<Room> create(pb.Program program) async {
    final id = _uuid.v4();
    await _storage.save(id, program);
    final room = Room(id, program, _storage, onEmpty: _unload);
    _rooms[id] = Future.value(room);
    return room;
  }

  Future<Room?> load(String id) {
    if (!Uuid.isValidUUID(fromString: id)) return Future.value(null);
    return _rooms[id] ??= _load(id);
  }

  Future<void> close() async {
    for (final loading in _rooms.values.toList()) {
      await (await loading)?.save();
    }
  }

  Future<Room?> _load(String id) async {
    pb.Program? program;
    try {
      program = await _storage.load(id);
    } finally {
      if (program == null) _rooms.remove(id);
    }
    return program == null ? null : Room(id, program, _storage, onEmpty: _unload);
  }

  Future<void> _unload(Room room) async {
    final loading = _rooms[room.id];
    await room.save();
    if (room.isEmpty && _rooms[room.id] == loading) _rooms.remove(room.id);
  }
}
