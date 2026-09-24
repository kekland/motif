import 'package:app/imports.dart';
import 'package:editor/client/client.dart';

class LocalEditorPage extends HookWidget {
  const new({
    super.key,
    required this.id,
    required this.program,
  });

  final String id;
  final Program program;

  @override
  Widget build(BuildContext context) {
    final scene = useDisposable(() => Scene(id: id, program: program));
    final editor = useDisposable(() => Editor(scene: scene));

    useListenerEffect(scene, () {
      final program = scene.program;
      storage.saveScene(id, program);
    });

    return Scaffold(child: EditorWidget(editor: editor));
  }
}

class RemoteEditorPage extends HookWidget {
  const new({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final connection = useDisposable(() => SceneConnection(server: env.serverUri, id: id));
    final status = useListenable(connection.status);
    final scene = useListenable(connection.scene).value;

    final Widget body = switch (status.value) {
      .closed => Center(child: Text('Connection closed')),
      .notFound => Center(child: Text('Document not found')),
      .connecting => Center(child: CircularProgressIndicator()),
      .connected => _EditorWidget(
        connection: connection,
        scene: scene,
      ),
    };

    return Scaffold(child: body);
  }
}

class _EditorWidget extends HookWidget {
  const new({
    super.key,
    required this.connection,
    required this.scene,
  });

  final SceneConnection connection;
  final Scene? scene;

  @override
  Widget build(BuildContext context) {
    final editor = useMaybeDisposable(
      () {
        if (scene == null) return null;
        final editor = Editor(
          scene: scene!,
          onPointerChanged: connection.updatePointer,
        );

        editor.clients.ownId = connection.ownId;
        return editor;
      },
      [scene],
    );

    useOnListenableChange(connection.peers, () {
      final peers = connection.peers.value;
      final clients = <SceneClient>[
        for (final p in peers.values)
          .new(
            id: p.client.id,
            pointerPosition: p.hasPointerPosition() ? .new(p.pointerPosition.x, p.pointerPosition.y) : null,
            pointerType: p.hasPointerType() ? p.pointerType : null,
          ),
      ];

      editor?.clients.ownId = connection.ownId;
      editor?.clients.setClients(clients);
    });

    if (editor != null) return EditorWidget(editor: editor);
    return Center(child: CircularProgressIndicator());
  }
}
