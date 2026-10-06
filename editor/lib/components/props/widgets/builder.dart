import 'package:editor/imports.dart';

final class PropListBuilder extends StatelessWidget {
  const new({
    super.key,
    required this.scene,
    required this.props,
  });

  final Scene scene;
  final List<Prop> props;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final prop in props) {
      final PropWidget? widget = prop.buildWidget(context);

      if (widget != null) {
        children.add(
          PropsSection(
            prop: prop,
            child: widget,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.interleave(Divider()).toList(),
    );
  }
}

class PropsBody extends StatelessWidget {
  const new({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.interleave(Divider()).toList(),
    );
  }
}

class PropsSection extends StatelessWidget {
  const new({
    super.key,
    required this.prop,
    required this.child,
  });

  final Prop prop;
  final PropWidget child;

  @override
  Widget build(BuildContext context) {
    final buttons = prop.buildHeaderButtons(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        ListItem(
          padding: .only(left: 12.0, right: 6.0),
          title: Text(child.resolveHeader(context), style: context.typography.caption.secondary),
          trailing: ButtonRow(buttons: buttons.toList()),
        ),
        child,
      ],
    );
  }
}
