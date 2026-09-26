import 'dart:async';

import 'package:collection/collection.dart';

import 'package:server/imports.dart';
import 'package:schema/program.dart' as pb;

final class Room {
  Room(this.id, this.program, this._storage, {required this.onEmpty}) {
    _launchEmptyTimer();
  }

  final String id;
  final SceneStorage _storage;
  final void Function(Room room) onEmpty;
  pb.Program program;

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
        .delta => _handleClientDelta(from, client, event.delta),
        .presence => _handleClientPresence(client, event.presence),
        .notSet => null,
      };
    } catch (e, s) {
      logger.warning('room $id: dropped event from ${client.id}', e, s);
    }
  }

  void _handleClientDelta(WebSocketChannel from, Client client, ClientDelta delta) {
    try {
      _apply(delta.delta);
      _broadcast(
        .new(
          delta: .new(delta: delta.delta, client: client),
        ),
      );
    } catch (e, st) {
      logger.warning('room $id: failed to apply delta from ${client.id}', e, st);
      from.sink.add(ServerEvent(snapshot: Snapshot(program: program, clients: _presence.values)).writeToBuffer());
    }
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
    program = _applyDelta(program, delta);
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

  void applyZOrder(pb.ZOrderChange change) {
    if (!change.hasAfter()) {
      copy.zOrder.entries.removeWhere((e) => e.ref == change.ref);
      return;
    }

    final entry = copy.zOrder.entries.firstWhereOrNull((e) => e.ref == change.ref);
    if (entry == null) {
      copy.zOrder.entries.add(.new(ref: change.ref, value: change.after));
    } else {
      entry.value = change.after;
    }
  }

  for (final change in delta.changes) {
    final _ = switch (change.whichValue()) {
      .statement => applyStatement(change.statement),
      .style => applyStyle(change.style),
      .zOrder => applyZOrder(change.zOrder),
      .empty => null,
      .notSet => throw StateError('invalid change: $change'),
    };
  }

  return copy;
}
