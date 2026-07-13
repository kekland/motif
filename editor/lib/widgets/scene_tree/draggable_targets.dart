part of 'scene_tree_panel.dart';

class _ObjectSubtreeDragTarget extends StatelessWidget {
  const _ObjectSubtreeDragTarget({super.key, required this.object, required this.child});

  final Object object;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: .translucent,
      onWillAcceptWithDetails: (details) {
        // final draggedNode = details.data as Node;
        // if (draggedNode == object || draggedNode.isAncestorOf(object)) return false;
        // return true;
        return false;
      },
      onAcceptWithDetails: (details) {
        // final draggedNode = (details.data as MutableNode)..detach();
        // final mutableNode = object as MutableNode;
        // mutableNode.addChild(draggedNode);
      },
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isEmpty) return child;

        return Container(
          foregroundDecoration: candidateData.isNotEmpty
              ? BoxDecoration(
                  border: Border.all(color: context.colors.accent.primary, width: 2.0),
                )
              : null,
          child: child,
        );
      },
    );
  }
}

class _ObjectGapDragTarget extends StatelessWidget {
  const _ObjectGapDragTarget({
    super.key,
    required this.parent,
    required this.index,
  });

  final int index;
  final Object parent;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: .translucent,
      onWillAcceptWithDetails: (details) {
        // final draggedNode = details.data as Node;
        // if (draggedNode.isAncestorOf(parent)) return false;
        // return true;
        return false;
      },
      onAcceptWithDetails: (details) {
        // final draggedNode = (details.data as MutableNode)..detach();
        // final mutableParent = parent as MutableNode;
        // mutableParent.insertChild(index, draggedNode);
      },
      builder: (context, candidateData, rejectedData) {
        if (candidateData.isEmpty) return SizedBox();

        return Container(
          color: context.colors.accent.primary,
        );
      },
    );
  }
}
