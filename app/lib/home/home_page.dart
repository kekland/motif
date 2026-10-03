import 'package:app/editor/editor_page.dart';
import 'package:app/home/server_section_widget.dart';
import 'package:app/imports.dart';
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
    final embeddedServer = context.embeddedServer;

    final sections = <Widget>[
      SliverPadding(
        padding: const .symmetric(horizontal: 16.0),
        sliver: ServerSection(
          client: embeddedServer.client,
          onPushEditor: (id, {info}) => pushEditorTab(context, embeddedServer.client, id, title: info?.title),
          actions: [
            Button(
              onTap: () async {
                final result = await context.pushDialog<String>((_) => JoinDialog());
                if (!context.mounted || result == null) return;

                // http://{ip}:{port}/{sceneId}?token={token}
                final uri = Uri.parse(result);
                final sceneId = uri.pathSegments.last;
                final token = uri.queryParameters['token'];

                final client = NetworkClient(
                  Uri(scheme: uri.scheme, host: uri.host, port: uri.port),
                  token: token,
                );

                pushEditorTab(context, client, sceneId, title: sceneId);
              },
              leading: Icons.link(),
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      child: CustomScrollView(
        slivers: [
          SliverSpacer(size: 24.0),
          ...sections,
          SliverSpacer(size: 24.0),
        ],
      ),
    );
  }
}

class CreateDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: Text('Create'),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ButtonRow(
          buttons: [
            Expanded(
              child: Button(
                onTap: () => Navigator.pop(context, 'local'),
                height: 40.0,
                leading: Icons.folder(),
                child: Text('Local'),
              ),
            ),
            Expanded(
              child: Button(
                onTap: () => Navigator.pop(context, 'online'),
                height: 40.0,
                leading: Icons.cloud(),
                child: Text('Online'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinDialog extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return DialogScaffold(
      title: Text('Join'),
      actions: [
        Button(
          onTap: () => Navigator.pop(context, controller.text),
          child: Text('Join'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          options: .new(hintText: 'Room URL'),
        ),
      ),
    );
  }
}
