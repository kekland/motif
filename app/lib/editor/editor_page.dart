import 'package:app/imports.dart';
import 'package:app/servers.dart';
import 'package:sync/client.dart' as sync;

class EditorPage extends HookWidget {
  const new({super.key, required this.client, required this.id});

  final sync.Client client;
  final String id;

  @override
  Widget build(BuildContext context) {
    final servers = useListenable(context.watch<AppServers>());

    final editorSync = useDisposable(
      () => EditorSync(
        client: client,
        sceneId: id,
        clientId: servers.ownUser.id,
        onSceneInfoUpdated: (info) {
          final tab = InheritedTab.of(context);
          if (tab == null) return;
          App.of(context).update(tab.index, tab.tab.copyWith(title: info.title));
        },
      ),
    );

    return EditorWidget(sync: editorSync);
  }
}
