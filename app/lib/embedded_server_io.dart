import 'package:path_provider/path_provider.dart';
import 'package:sync_server/embedded.dart';

Future<EmbeddedServer> createEmbeddedServer() async {
  final rootDirectory = await getApplicationDocumentsDirectory();
  print(rootDirectory.path);
  final embeddedServer = EmbeddedServer.create(rootDirectory: rootDirectory.path, canShareScenes: true);
  return embeddedServer;
}
