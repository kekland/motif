import 'package:app/editor/editor_page.dart';
import 'package:app/home/server_panel.dart';
import 'package:app/home/servers_panel.dart';
import 'package:app/imports.dart';
import 'package:app/servers.dart';
import 'package:sync/client.dart' as sync;
import 'package:sync_server/network.dart';

class HomePage extends HookWidget {
  const new({super.key});

  Future<void> pushEditorTab(BuildContext context, sync.Client client, String id, {String? title}) async {
    // ignore: avoid_print
    print('Pushing editor tab for document $id');

    App.of(context).push(
      .new(
        title: title ?? id,
        leading: Icons.document(),
        body: EditorPage(client: client, id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final servers = useListenable(context.watch<AppServers>());
    final selectedServer = useState<Uri?>(null);

    useOnListenableChange(servers, () {
      if (!servers.contains(selectedServer.value)) {
        selectedServer.value = null;
      }
    });

    return Scaffold(
      child: Panels(
        direction: .horizontal,
        panels: [
          Panel(
            key: #servers,
            constraints: .pixels(256.0, 384.0),
            child: ServersPanel(
              servers: servers.servers,
              selectedServer: selectedServer.value,
              onServerSelected: (uri) => selectedServer.value = uri,
              onAddServer: (url) {
                final uri = Uri.parse(url);
                servers.addServer(uri);
              },
              onConnect: (url) {
                // http://{ip}:{port}/{sceneId}?token={token}
                final uri = Uri.parse(url);
                final sceneId = uri.pathSegments.last;
                final token = uri.queryParameters['token'];

                final client = NetworkClient(
                  Uri(scheme: uri.scheme, host: uri.host, port: uri.port),
                  token: token,
                );

                pushEditorTab(context, client, sceneId, title: sceneId);
              },
            ),
          ),
          Panel(
            key: #main,
            constraints: .flex(1.0),
            child: ServerPanel(
              uri: selectedServer.value,
              pushEditorTab: pushEditorTab,
            ),
          ),
        ],
      ),
    );
  }
}
