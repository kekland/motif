import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:sync_server/embedded.dart';

import 'package:sync/sync.dart' as sync;
import 'package:sync/schema.dart' as pb;

final class EmbeddedClient extends sync.Client {
  EmbeddedClient(this.server);
  final EmbeddedServer server;

  @override
  Future<sync.ClientConnection> connect(String id, pb.Client client) async {
    final scene = await server.openScene(id);
    if (scene == null) throw Exception('Scene not found');

    final connection = EmbeddedClientConnection.create();
    scene.join(connection.server, client);
    return connection;
  }

  @override
  Future<pb.ListScenesResponse> listScenes() async {
    final scenes = await server.indexStorage.listScenes();
    return .new(scenes: scenes);
  }

  @override
  Future<pb.CreateSceneResponse> createScene({pb.Program? program, String? title}) async {
    final (info, _program) = await server.createScene(program: program, title: title);
    return .new(info: info, program: _program);
  }

  @override
  Future<pb.GetSceneResponse> getScene(String id) async {
    final scene = await server.openScene(id);
    if (scene == null) throw sync.NotFound(id);
    return .new(info: scene.info, program: scene.program);
  }

  @override
  Future<Uint8List> loadAsset(String sceneId, Hash hash) async {
    final scene = await server.openScene(sceneId);
    if (scene == null) throw sync.NotFound(sceneId);

    final bytes = await scene.storage.readAsset(hash.value);
    if (bytes == null) throw sync.NotFound(hash.value);
    return bytes;
  }

  @override
  Future<void> saveAsset(String sceneId, Hash hash, Uint8List data) async {
    final scene = await server.openScene(sceneId);
    if (scene == null) throw sync.NotFound(sceneId);
    await scene.storage.writeAsset(hash.value, data);
  }

  @override
  Future<void> close() async {}
}
