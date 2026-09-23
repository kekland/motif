import 'package:app/editor/editor_page.dart';
import 'package:app/imports.dart';

class HomePage extends HookWidget {
  const new({super.key});

  Future<void> pushEditorTab(BuildContext context, String? id) async {
    // ignore: avoid_print
    print('Pushing editor tab for document $id');

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
        body: EditorPage(id: resolvedId, program: program),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final documents = useState<List<String>?>(null);
    Future<void> loadDocuments() async {
      documents.value = await storage.listScenes();
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
              Text('Your documents', style: context.typography.largeTitle),
              const SizedBox(height: 12.0),
              ButtonRow(
                buttons: [
                  Button(
                    onTap: () async {
                      final result = await context.pushDialog((_) => CreateDialog());
                      if (!context.mounted) return;

                      return switch (result) {
                        'local' => pushEditorTab(context, null),
                        'online' => pushEditorTab(context, null),
                        _ => null,
                      };
                    },
                    leading: Icons.add(),
                    child: Text('Create'),
                  ),
                  Button(
                    onTap: () {},
                    leading: Icons.join(),
                    child: Text('Join'),
                  ),
                  // Button(
                  //   onTap: () {},
                  //   leading: Icons.open(),
                  //   child: Text('Open'),
                  // ),
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
        sliver: SliverGrid.builder(
          itemCount: documents.value?.length ?? 0,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 192.0,
            mainAxisExtent: 240.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemBuilder: (context, i) {
            final id = documents.value![i];
            return Card(
              onTap: () => pushEditorTab(context, id),
              trailing: ListItem(
                leading: Icons.document(),
                title: Text(id),
                trailing: IconButton.flat(
                  onTap: () async {
                    await storage.deleteScene(id);
                    await loadDocuments();
                  },
                  child: Icons.delete(),
                ),
                // subtitle: Text('3 hours ago'),
              ),
              child: Container(color: context.colors.surface.tertiary),
            );
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
