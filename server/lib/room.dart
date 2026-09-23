import 'dart:async';

import 'package:server/imports.dart';
import 'package:schema/program.dart' as pb;
import 'package:program/program.dart';

final class Room {
  Room(this.id, pb.Program program, this._storage, {required this.onEmpty}) {
    _evaluation = Evaluation(Program.decode(program));
    _launchEmptyTimer();
  }

  final String id;
  final SceneStorage _storage;
  final void Function(Room room) onEmpty;
  late final Evaluation _evaluation;
  pb.Program get program => _evaluation.program.encode();

  final _clients = <WebSocketChannel, Client>{};
  final _presence = <String, ClientPresence>{};

  var _dirty = false;
  Timer? _saveTimer;
  Timer? _emptyTimer;

  bool get isEmpty => _clients.isEmpty;

  void join(WebSocketChannel channel, Client client) {
    _emptyTimer?.cancel();
    _clients[channel] = client;

    final snapshot = Snapshot(program: program, clients: _presence.values);
    channel.sink.add(ServerEvent(snapshot: snapshot).writeToBuffer());

    channel.stream.listen(
      (data) => _receive(channel, data),
      onDone: () => _handleClientLeave(channel),
      onError: (_) => _handleClientLeave(channel),
      cancelOnError: true,
    );
  }

  void _receive(WebSocketChannel from, Object? data) {
    if (data is! List<int>) return;
    final client = _clients[from];
    if (client == null) return;

    try {
      final event = ClientEvent.fromBuffer(data);
      final _ = switch (event.whichEvent()) {
        .delta => _handleClientDelta(client, event.delta),
        .presence => _handleClientPresence(client, event.presence),
        .notSet => null,
      };
    } catch (e, s) {
      logger.warning('room $id: dropped event from ${client.id}', e, s);
    }
  }

  void _handleClientDelta(Client client, ClientDelta delta) {
    _apply(delta.delta);
    _broadcast(
      .new(
        delta: .new(delta: delta.delta, client: client),
      ),
    );
  }

  void _handleClientPresence(Client client, ClientPresence presence) {
    _presence[client.id] = presence;
    _broadcast(.new(presence: presence), except: client);
  }

  void _launchEmptyTimer() {
    _emptyTimer = Timer(const Duration(seconds: 30), () => onEmpty(this));
  }

  void _handleClientLeave(WebSocketChannel channel) {
    final client = _clients.remove(channel);
    if (client == null) return;

    _presence.remove(client.id);
    _broadcast(.new(left: client));
    if (isEmpty) _launchEmptyTimer();
  }

  void _broadcast(ServerEvent event, {Client? except}) {
    final bytes = event.writeToBuffer();
    for (final entry in _clients.entries) {
      final channel = entry.key, client = entry.value;
      if (client == except) continue;
      channel.sink.add(bytes);
    }
  }

  void _apply(pb.ProgramDelta delta) {
    _applyDelta(_evaluation, delta);
    _dirty = true;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), save);
  }

  Future<void> save() async {
    _saveTimer?.cancel();
    if (!_dirty) return;
    await performSave();
  }

  Future<void> performSave() async {
    try {
      _dirty = false;
      await _storage.save(id, program);
      logger.finest('Saved room $id');
    } catch (e) {
      logger.severe('Failed to save room $id', e);
      _dirty = true;
    }
  }
}

void _applyDelta(Evaluation evaluation, pb.ProgramDelta delta) {
  final resolvedDelta = ProgramDelta.decode(delta);
  resolvedDelta.reapply(evaluation);
}
