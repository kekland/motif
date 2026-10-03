import 'dart:io';

import 'package:shared/shared.dart';
import 'package:sync/server.dart' as sync;
import 'package:sync_server/network.dart';

import '../shared_scene.dart';

Future<SharedScene> createSharedSceneImpl(sync.Server server, String sceneId) async {
  final token = uuid.v4();
  final gateway = ServerHttpGateway(
    server,
    admit: (sid, t) => sid == sceneId && t == token,
    allowCreate: false,
  );

  final port = await gateway.listen(.anyIPv4, 0);
  return SharedSceneIo(sceneId: sceneId, port: port, token: token, gateway: gateway);
}

final class SharedSceneIo implements SharedScene {
  SharedSceneIo({
    required this.sceneId,
    required this.port,
    required this.token,
    required this.gateway,
  });

  final String sceneId;
  final int port;
  final String token;
  final ServerHttpGateway gateway;

  @override
  Future<Uri?> get localUri async {
    final interfaces = await NetworkInterface.list(includeLinkLocal: false, type: .IPv4);
    final localMasks = ['192.168.', '10.', '172.'];

    for (final i in interfaces) {
      for (final addr in i.addresses) {
        final host = addr.address;
        if (localMasks.any((mask) => host.startsWith(mask))) {
          return uri(host);
        }
      }
    }
    
    return null;
  }

  @override
  Uri uri(String host) => Uri(
    scheme: 'http',
    host: InternetAddress(host).address,
    port: port,
    path: '/$sceneId',
    queryParameters: {'token': token},
  );

  @override
  Future<void> stop() async {
    await gateway.close();
  }
}
