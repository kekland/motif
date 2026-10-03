import 'package:sync_server/embedded.dart';

Future<EmbeddedServer> createEmbeddedServer() async {
  final embeddedServer = EmbeddedServer.create(canShareScenes: false);
  return embeddedServer;
}
