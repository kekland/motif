import 'dart:async';

import 'package:shared/shared.dart';
import 'package:sync/schema.dart' as pb;
import 'package:sync/server.dart';

final class ServerScene {
  ServerScene({
    required this.info,
    required this.storage,
    required this.program,
    required this.onEmpty,
  }) : logger = .new('scene/${info.id}') {
    _launchEmptyTimer();
  }

  final pb.SceneInfo info;
  final SceneStorage storage;
  final void Function() onEmpty;
  final Logger logger;
  pb.Program program;

  final _connections = <ServerConnection, pb.Client>{};
  final _presences = <String, pb.ClientPresence>{};

  bool get hasConnections => _connections.isNotEmpty;
  bool get hasNoConnections => _connections.isEmpty;

  bool get canBeClosed => hasNoConnections;

  var _dirty = false;
  Timer? _saveTimer;
  Timer? _emptyTimer;

  pb.Snapshot _createSnapshot() => .new(program: program, clients: _presences.values);

  void _launchEmptyTimer() {
    _emptyTimer = Timer(const Duration(seconds: 30), () => onEmpty());
  }

  void join(ServerConnection connection, pb.Client client) {
    _emptyTimer?.cancel();

    _connections[connection] = client;
    connection.send(pb.ServerEvent(snapshot: _createSnapshot()));

    connection.events.listen(
      (event) => _handleClientEvent(connection, event),
      onDone: () => _handleClientLeave(connection),
      onError: (_) => _handleClientLeave(connection),
      cancelOnError: true,
    );
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Event handling
  // -------------------------------------------------------------------------------------------------------------------

  void _handleClientEvent(ServerConnection connection, pb.ClientEvent event) {
    final client = _connections[connection];
    if (client == null) return;

    return switch (event.whichEvent()) {
      .delta => _handleClientDelta(connection, client, event.delta),
      .presence => _handleClientPresence(connection, client, event.presence),
      .notSet => null,
    };
  }

  void _handleClientDelta(ServerConnection connection, pb.Client client, pb.ClientDelta delta) {
    try {
      _applyDelta(delta.delta);
      _broadcast(
        .new(
          delta: .new(delta: delta.delta, client: client),
        ),
      );
    } catch (e, st) {
      logger.warning('failed to apply delta from ${client.id}', e, st);
      connection.send(.new(snapshot: _createSnapshot()));
    }
  }

  void _handleClientPresence(ServerConnection connection, pb.Client client, pb.ClientPresence presence) {
    _presences[client.id] = presence;
    _broadcast(.new(presence: presence), except: client);
  }

  void _handleClientLeave(ServerConnection connection) {
    final client = _connections.remove(connection);
    if (client == null) return;

    _presences.remove(client.id);
    _broadcast(.new(left: client));

    if (hasNoConnections) _launchEmptyTimer();
    connection.close();
  }

  void _broadcast(pb.ServerEvent event, {pb.Client? except}) {
    for (final entry in _connections.entries) {
      final connection = entry.key, client = entry.value;
      if (client == except) continue;
      connection.send(event);
    }
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Data manipulation
  // -------------------------------------------------------------------------------------------------------------------

  void _markDirty() {
    _dirty = true;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), save);
  }

  void _applyDelta(pb.ProgramDelta delta) {
    program = _applyDeltaImpl(program, delta);
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
      await storage.saveProgram(program);
      logger.finest('saved');
    } catch (e, st) {
      logger.severe('failed to save', e, st);
      _markDirty();
    }
  }

  Future<void> close() async {
    _emptyTimer?.cancel();
    await save();
    for (final connection in _connections.keys.toList()) await connection.close();
    _connections.clear();
    await storage.close();
  }
}

// ---------------------------------------------------------------------------------------------------------------------
// Delta application
// ---------------------------------------------------------------------------------------------------------------------

pb.Program _applyDeltaImpl(pb.Program program, pb.ProgramDelta delta) {
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
    final entries = copy.ensureStyle().entries;

    if (!change.hasAfter()) {
      entries.removeWhere((e) => e.ref == change.ref);
      return;
    }

    final entry = entries.firstWhereOrNull((e) => e.ref == change.ref);
    if (entry == null) {
      entries.add(.new(ref: change.ref, value: change.after));
    } else {
      entry.value = change.after;
    }
  }

  void applyAsset(pb.AssetChange change) {
    final entries = copy.ensureAssetManifest().entries;

    for (final removed in change.removed) {
      entries.removeWhere((k, v) => k == removed.hash);
    }

    for (final inserted in change.inserted) {
      entries[inserted.hash] = inserted;
    }
  }

  for (final change in delta.changes) {
    final _ = switch (change.whichValue()) {
      .statement => applyStatement(change.statement),
      .style => applyStyle(change.style),
      .asset => applyAsset(change.asset),
      .empty => null,
      .notSet => throw StateError('invalid change: $change'),
    };
  }

  return copy;
}
