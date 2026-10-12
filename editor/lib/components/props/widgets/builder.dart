import 'package:editor/imports.dart';

final class const PropListBuilder({
  super.key,
  required final List<Prop> props,
}) extends StatelessWidget {
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
      mainAxisSize: .min,
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
    final header = child.resolveHeader(context);
    final tooltip = prop.tooltip;

    return Tooltip(
      tooltip: tooltip,
      child: PropsSectionWidget(
        title: header != null ? Text(header) : null,
        trailing: buttons.toList(),
        child: child,
      ),
    );
  }
}

final class const PropsSectionWidget({
  super.key,
  required final Widget? title,
  required final Widget child,
  final List<Widget> trailing = const [],
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || trailing.isNotEmpty)
          ListItem(
            padding: .only(left: 12.0, right: 6.0),
            title: DefaultForegroundStyle(style: context.typography.caption.secondary, child: title!),
            trailing: ButtonRow(buttons: trailing),
          ),
        child,
      ],
    );
  }
}
