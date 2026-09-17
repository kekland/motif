part of 'context_menu.dart';

class ContextMenuRoot extends StatefulWidget {
  const new({super.key, required this.child});

  final Widget child;

  @override
  State<ContextMenuRoot> createState() => ContextMenuRootState();
}

class ContextMenuRootState extends State<ContextMenuRoot> {
  late final _manager = PortalEntryManager();

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  Future<T?> push<T>(BuildContext context, ContextMenu menu, {PositionedGestureDetails? details}) {
    final Rect? rect;
    if (details != null) {
      rect = details.localPosition & .zero;
    } else {
      rect = null;
    }

    return _manager.push(
      context,
      PortalEntry(
        builder: (context) => ContextMenuWidget(menu: menu),
        isModal: true,
      ),
      anchor: .compute(
        context,
        rect: rect,
        alignment: .bottomRight,
        padding: const .all(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
