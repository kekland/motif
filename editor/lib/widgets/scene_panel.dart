import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/program_panel.dart';
import 'package:editor/widgets/tree_panel/tree_panel.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sync_server/embedded.dart' as sync;
import 'package:sync_server/embedded/shared_scene.dart';

enum ScenePanelMode {
  program,
  tree,
}

class ScenePanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = useState(ScenePanelMode.tree);
    return Column(
      mainAxisSize: .max,
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: ListItem(
                  leading: Icons.tree(),
                  title: Text('Tree'),
                  onTap: () => mode.value = .tree,
                  isSelected: mode.value == .tree,
                ),
              ),
              VerticalDivider(),
              Expanded(
                child: ListItem(
                  leading: Icons.program(),
                  title: Text('Program'),
                  onTap: () => mode.value = .program,
                  isSelected: mode.value == .program,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: switch (mode.value) {
            .tree => TreePanel(),
            .program => ProgramPanel(),
          },
        ),
        Divider(),
        SizedBox(
          height: 36.0,
          child: _SyncPanel(),
        ),
      ],
    );
  }
}

class _SyncPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final peers = useComputedValue(() => editor.sync.peers).values.toList();

    final isEmbedded = editor.sync.client is sync.EmbeddedClient;

    return Row(
      children: [
        Expanded(
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: 1 + peers.length,
            padding: const .symmetric(horizontal: 8.0),
            separatorBuilder: (context, i) => SizedBox(width: 2.0),
            itemBuilder: (context, i) {
              if (i == 0) {
                return SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: BoringAvatar(
                    name: context.editor.sync.self.id,
                    palette: .new(Colors.primaries),
                    shape: CircleBorder(),
                    type: .marble,
                  ),
                );
              }

              final peer = peers[i - 1];
              return SizedBox(
                width: 24.0,
                height: 24.0,
                child: BoringAvatar(
                  name: peer.id,
                  palette: .new(Colors.primaries),
                  shape: CircleBorder(),
                  type: .marble,
                ),
              );
            },
          ),
        ),
        if (isEmbedded) ...[
          _EmbeddedServerOptions(server: (editor.sync.client as sync.EmbeddedClient).server),
          const SizedBox(width: 2.0),
        ],
      ],
    );
  }
}

class _EmbeddedServerOptions extends HookWidget {
  const new({super.key, required this.server});

  final sync.EmbeddedServer server;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    useListenable(server);

    final isShared = server.sharedSceneIds.isNotEmpty;

    return Stack(
      children: [
        IconButton.flat(
          tooltip: .new('Server settings'),
          child: Icons.more(),
          onTap: () {
            context.pushDialog(
              (context) => _EmbeddedServerOptionsWindow(
                server: server,
                sceneId: editor.scene.id,
              ),
            );
          },
        ),
        if (isShared)
          Positioned(
            right: 2.0,
            top: 2.0,
            child: Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(color: context.colors.accent.primary, shape: .circle),
            ),
          ),
      ],
    );
  }
}

class _EmbeddedServerOptionsWindow extends HookWidget {
  const new({
    super.key,
    required this.server,
    required this.sceneId,
  });

  final sync.EmbeddedServer server;
  final String sceneId;

  @override
  Widget build(BuildContext context) {
    useListenable(server);

    return DialogScaffold(
      title: Text('Server'),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          if (server.sharedSceneIds.isNotEmpty) ...[
            _SharedSessionQRWidget(
              scene: server.sharedScenes[sceneId]!,
            ),
            Button(
              onTap: () async {
                final uri = await server.sharedScenes[sceneId]!.localUri;
                await Clipboard.set([.text(uri.toString())]);
              },
              child: Text('Copy to clipboard'),
            ),
            const SizedBox(height: 8.0),
            Button(
              onTap: () async {
                await server.stopSharedScene(sceneId);
              },
              child: Text('Stop sharing'),
            ),
          ] else ...[
            Button(
              onTap: () async {
                await server.shareScene(sceneId);
              },
              child: Text('Open to LAN'),
            ),
          ],
        ],
      ),
    );
  }
}

class _SharedSessionQRWidget extends HookWidget {
  const new({super.key, required this.scene});

  final SharedScene scene;

  @override
  Widget build(BuildContext context) {
    final uri = useState<Uri?>(null);

    useCallOnce(() async {
      uri.value = await scene.localUri;
    });

    final Widget body;

    if (uri.value != null) {
      body = PrettyQrView.data(
        data: uri.value.toString(),
        decoration: const .new(
          // ignore: experimental_member_use
          shape: PrettyQrShape.custom(
            PrettyQrSquaresSymbol(),
          ),
        ),
      );
    } else {
      body = const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Surface(
          width: 192.0,
          height: 192.0,
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          borderRadius: .circular(16.0),
          child: body,
        ),
      ),
    );
  }
}
