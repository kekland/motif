import 'dart:async';

import 'package:shared/shared.dart';
import 'package:sync_server/storage.dart';

import 'package:sync/schema.dart' as pb;
import 'package:sync/sync.dart' as sync;

import 'shared_scene.dart';
import 'client.dart';

final class EmbeddedServer extends sync.Server with ChangeNotifier {
  EmbeddedServer(super.indexStorage, {required this.canShareScenes});

  EmbeddedClient get client => .new(this);

  static Future<EmbeddedServer> create({String? rootDirectory, required bool canShareScenes}) async {
    final manager = await createStorageManager(rootDirectory: rootDirectory);
    final indexStorage = SqliteIndexStorage(manager);
    await indexStorage.initialize();
    return .new(indexStorage, canShareScenes: canShareScenes);
  }

  final sharedScenes = <String, SharedScene>{};
  Iterable<String> get sharedSceneIds => sharedScenes.keys;
  final bool canShareScenes;

  Future<SharedScene> shareScene(String sceneId) async {
    final sharedScene = await createSharedScene(this, sceneId);
    sharedScenes[sceneId] = sharedScene;
    notifyListeners();
    return sharedScene;
  }

  Future<void> stopSharedScene(String sceneId) async {
    final sharedScene = sharedScenes.remove(sceneId);
    if (sharedScene != null) await sharedScene.stop();
    notifyListeners();
  }
}

final class EmbeddedClientConnection extends sync.ClientConnection {
  EmbeddedClientConnection._(this._incoming, this._outgoing) : server = .new(_outgoing.stream, _incoming);

  factory create() {
    final incoming = StreamController<pb.ServerEvent>();
    final outgoing = StreamController<pb.ClientEvent>();
    return ._(incoming, outgoing);
  }

  final StreamController<pb.ServerEvent> _incoming;
  final StreamController<pb.ClientEvent> _outgoing;
  final EmbeddedServerConnection server;

  @override
  Stream<pb.ServerEvent> get events => _incoming.stream;

  @override
  void send(pb.ClientEvent event) => _outgoing.add(event);

  @override
  Future<void> close() => _outgoing.close();

  @override
  Object? get closeReason => null;
}

final class EmbeddedServerConnection extends sync.ServerConnection {
  EmbeddedServerConnection(this._incoming, this._outgoing);

  final Stream<pb.ClientEvent> _incoming;
  final StreamController<pb.ServerEvent> _outgoing;

  @override
  Stream<pb.ClientEvent> get events => _incoming;

  @override
  void send(pb.ServerEvent event) {
    if (!_outgoing.isClosed) _outgoing.add(event);
  }

  @override
  Future<void> close() => _outgoing.close();
}
