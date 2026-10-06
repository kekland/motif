import 'package:app/home/server_section_widget.dart';
import 'package:app/servers.dart';
import 'package:sync/client.dart' as sync;
import 'package:ui/ui.dart';

class ServerPanel extends HookWidget {
  const new({
    super.key,
    required this.pushEditorTab,
    this.uri,
  });

  final Uri? uri;
  final void Function(BuildContext context, sync.Client client, String sceneId, {String? title}) pushEditorTab;

  @override
  Widget build(BuildContext context) {
    final servers = useListenable(context.watch<AppServers>());
    final client = servers.clientFor(uri);

    final sections = <Widget>[
      SliverPadding(
        padding: const .symmetric(horizontal: 16.0),
        sliver: ServerSection(
          key: ValueKey(client),
          title: uri == null ? 'Local documents' : uri.toString().split('://').last,
          subtitle: uri != null
              ? 'Warning: in the current demo version, all scenes are public! Make sure not to store sensitive information.'
              : null,
          client: client,
          onPushEditor: (id, {info}) => pushEditorTab(context, client, id, title: info?.title),
          onRefresh: () {
            if (uri != null) servers.refreshServerStatus(uri!);
          },
        ),
      ),
    ];

    return CustomScrollView(
      slivers: [
        SliverSpacer(size: 24.0),
        ...sections,
        SliverSpacer(size: 24.0),
      ],
    );
  }
}
