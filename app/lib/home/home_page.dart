import 'package:app/editor/editor_page.dart';
import 'package:app/imports.dart';
import 'package:editor/client/client.dart';
import 'package:flutter/services.dart';

class HomePage extends HookWidget {
  const new({super.key});

  Future<void> pushEditorTab(BuildContext context, String? id, {bool isRemote = false}) async {
    // ignore: avoid_print
    print('Pushing editor tab for document $id');

    if (isRemote) {
      final String resolvedId;

      if (id != null) {
        resolvedId = id;
      } else {
        resolvedId = await SceneConnection.create(env.serverUri, .empty());
      }

      await storage.persistRemoteScene(resolvedId);

      if (!context.mounted) return;
      App.of(context).push(
        .new(
          title: resolvedId,
          leading: Icons.document(),
          body: RemoteEditorPage(id: resolvedId),
        ),
      );
    } else {
      final String resolvedId;
      final Program program;

      if (id != null) {
        (resolvedId, program) = await storage.loadScene(id);
      } else {
        (resolvedId, program) = await storage.createScene();
      }

      App.of(context).push(
        .new(
          title: resolvedId,
          leading: Icons.document(),
          body: LocalEditorPage(id: resolvedId, program: program),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = useState<List<String>?>(null);
    final cloudDocuments = useState<List<String>?>(null);

    Future<void> loadDocuments() async {
      documents.value = await storage.listScenes();
      cloudDocuments.value = await storage.listRemoteScenes();
    }

    useEffect(() {
      loadDocuments();
      return null;
    }, []);

    final sections = <Widget>[
      SliverToBoxAdapter(
        child: Padding(
          padding: const .symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text('Local documents', style: context.typography.largeTitle),
              const SizedBox(height: 12.0),
              ButtonRow(
                buttons: [
                  Button(
                    onTap: () async {
                      final result = await context.pushDialog((_) => CreateDialog());
                      if (!context.mounted) return;

                      await switch (result) {
                        'local' => pushEditorTab(context, null),
                        'online' => pushEditorTab(context, null, isRemote: true),
                        _ => null,
                      };

                      await loadDocuments();
                    },
                    leading: Icons.add(),
                    child: Text('Create'),
                  ),
                  Button(
                    onTap: () async {
                      final result = await context.pushDialog((_) => JoinDialog());
                      if (!context.mounted) return;

                      if (result != null) {
                        await pushEditorTab(context, result, isRemote: true);
                      }
                    },
                    leading: Icons.link(),
                    child: Text('Join'),
                  ),
                  Button(
                    onTap: () => loadDocuments(),
                    leading: Icons.refresh(),
                    child: Text('Refresh'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      SliverSpacer(size: 24.0),
      SliverPadding(
        padding: const .symmetric(horizontal: 16.0),
        sliver: DocumentGrid(
          documents: documents.value,
          onTap: (id) => pushEditorTab(context, id),
          onDelete: (id) async {
            await storage.deleteScene(id);
            await loadDocuments();
          },
        ),
      ),
      SliverSpacer(size: 24.0),
      SliverToBoxAdapter(
        child: Padding(
          padding: const .symmetric(horizontal: 16.0),
          child: Text('Cloud documents', style: context.typography.largeTitle),
        ),
      ),
      SliverSpacer(size: 24.0),
      SliverPadding(
        padding: const .symmetric(horizontal: 16.0),
        sliver: DocumentGrid(
          documents: cloudDocuments.value,
          onTap: (id) => pushEditorTab(context, id, isRemote: true),
          onDelete: (id) async {
            await storage.deleteRemoteScene(id);
            await loadDocuments();
          },
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

class DocumentGrid extends StatelessWidget {
  const new({
    super.key,
    required this.documents,
    this.onTap,
    this.onDelete,
  });

  final List<String>? documents;
  final void Function(String id)? onTap;
  final void Function(String id)? onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: documents?.length ?? 0,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 192.0,
        mainAxisExtent: 240.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, i) {
        final id = documents![i];
        return Card(
          onTap: () => onTap?.call(id),
          trailing: ListItem(
            leading: Icons.document(),
            title: Text(id),
            trailing: Row(
              children: [
                IconButton.flat(
                  tooltip: .new('Copy ID'),
                  onTap: () => Clipboard.setData(ClipboardData(text: id)),
                  child: Icons.copy(),
                ),
                IconButton.flat(
                  tooltip: .new('Delete'),
                  onTap: () => onDelete?.call(id),
                  child: Icons.delete(),
                ),
              ],
            ),
            // subtitle: Text('3 hours ago'),
          ),
          child: Container(color: context.colors.surface.tertiary),
        );
      },
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
          options: .new(hintText: 'Room id'),
        ),
      ),
    );
  }
}
