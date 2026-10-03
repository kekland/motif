import 'dart:typed_data';

import 'package:sync/schema.dart' as pb;

abstract class Client {
  Future<pb.ListScenesResponse> listScenes();
  Future<pb.GetSceneResponse> getScene(String id);
  Future<pb.CreateSceneResponse> createScene({pb.Program? program, String? title});
  Future<ClientConnection> connect(String id, pb.Client client);

  Future<Uint8List> loadAsset(String sceneId, pb.Hash hash);
  Future<void> saveAsset(String sceneId, pb.Hash hash, Uint8List data);

  Future<void> close();
}

abstract class ClientConnection {
  void send(pb.ClientEvent event);
  Stream<pb.ServerEvent> get events;
  Future<void> close();

  Object? get closeReason;
}
