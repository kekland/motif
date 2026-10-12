import 'package:editor/imports.dart';
import 'package:renderer/slice_widget.dart';

final class const PrefabsTab({
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scene = context.editor.scene;
    final prefabIndex = scene.evaluation.prefabs;
    final prefabs = useListenableSelector(scene, () => prefabIndex.origins.toList());

    void showOnScreen(StatementId id) {
      context.editor.selection.setStatement(id);
      context.editor.canvasUtils.showOnScreen([id]);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 192.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: prefabs.length,
      itemBuilder: (context, index) {
        final prefabId = prefabs[index];
        final statement = scene.statement(prefabId) as PrefabOriginStatement;

        return Card(
          onTap: () => showOnScreen(prefabId),
          trailing: ListItem(
            title: Text(statement.name ?? 'unnamed'),
            trailing: Row(
              children: [
                IconButton.flat(
                  onTap: () => performCopy(prefabIndex.sliceOf(prefabId)),
                  child: Icons.copy(),
                ),
                IconButton.flat(
                  onTap: () => showOnScreen(prefabId),
                  child: Icons.visibility(),
                ),
              ],
            ),
          ),
          child: SizedBox(
            width: .infinity,
            child: ColoredBox(
              color: context.colors.surface.tertiary,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FrameWidget(
                  scene: scene,
                  ref: statement.frame,
                  fit: .contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
