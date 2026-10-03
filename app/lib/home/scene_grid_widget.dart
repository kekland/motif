import 'package:app/imports.dart';
import 'package:flutter/services.dart';
import 'package:sync/schema.dart' as pb;

class SceneGrid extends StatelessWidget {
  const new({
    super.key,
    required this.scenes,
    this.onTap,
    this.onDelete,
  });

  final List<pb.SceneInfo>? scenes;
  final void Function(pb.SceneInfo)? onTap;
  final void Function(String id)? onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: scenes?.length ?? 0,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 192.0,
        mainAxisExtent: 240.0,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, i) {
        final scene = scenes![i];
        final id = scene.id;

        return Card(
          onTap: () => onTap?.call(scene),
          trailing: ListItem(
            leading: Icons.document(),
            title: Text(scene.title),
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
