import 'package:app/home/scene_grid_widget.dart';
import 'package:app/imports.dart';
import 'package:sync/client.dart';
import 'package:sync/schema.dart' as pb;

class ServerSection extends HookWidget {
  const new({
    super.key,
    required this.client,
    required this.onPushEditor,
    this.actions = const [],
  });

  final Client client;
  final void Function(String id, {pb.SceneInfo? info}) onPushEditor;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final documents = useState<List<pb.SceneInfo>?>(null);

    Future<void> loadDocuments() async {
      documents.value = (await client.listScenes()).scenes;
    }

    useEffect(() {
      loadDocuments();
      return null;
    }, []);

    final header = Column(
      crossAxisAlignment: .start,
      children: [
        Text('Documents ($client)', style: context.typography.largeTitle),
        const SizedBox(height: 12.0),
        ButtonRow(
          buttons: [
            Button(
              onTap: () async {
                final backgroundColor = context.colors.surface.canvas.background;
                final program = Program.empty(
                  settings: .new(
                    backgroundColor: .fromCss(
                      .rgb(r: backgroundColor.r, g: backgroundColor.g, b: backgroundColor.b),
                    ),
                  ),
                );

                final info = (await client.createScene(program: program.encode())).info;
                onPushEditor(info.id, info: info);
                await loadDocuments();
              },
              leading: Icons.add(),
              child: Text('Create'),
            ),
            Button(
              onTap: loadDocuments,
              leading: Icons.refresh(),
              child: Text('Refresh'),
            ),
            ...actions,
          ],
        ),
      ],
    );

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: header),
        SliverSpacer(size: 24.0),
        SceneGrid(
          scenes: documents.value,
          onTap: (scene) => onPushEditor(scene.id, info: scene),
          onDelete: (id) async {
            // TODO
            // await storage.deleteScene(id);
            await loadDocuments();
          },
        ),
      ],
    );
  }
}
