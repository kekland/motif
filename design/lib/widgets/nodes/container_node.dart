part of '_nodes.dart';

class ContainerNodeWidget extends StatelessWidget {
  const ContainerNodeWidget({
    super.key,
    required this.node,
  });

  final ContainerNode node;

  @override
  Widget build(BuildContext context) {
    return NodeBuilder(
      node: node,
      builder: (context, child) {
        // final fill = useComputedValue(() => node.fill);

        return Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorderNoPadding(
              side: BorderSide(
                color: context.colors.divider,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          child: child,
        );
      },
    );
  }
}
