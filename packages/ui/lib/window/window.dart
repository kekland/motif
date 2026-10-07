import 'package:ui/ui.dart';

final class WindowEntry<T> extends PortalEntry<T> {
  new({
    required super.builder,
    super.isModal,
  }) : super(
         anchorBuilder: (context, anchor, child) => WindowPositioned(anchor: anchor, child: child),
       );
}

class WindowPositioned extends StatefulWidget {
  const new({
    super.key,
    this.anchor,
    required this.child,
  });

  final PortalAnchor? anchor;
  final Widget child;

  @override
  State<WindowPositioned> createState() => WindowPositionedState();
}

class WindowPositionedState extends State<WindowPositioned> {
  Rect? rect;

  @override
  Widget build(BuildContext context) {
    return PortalPositioned(
      onInitialRectComputed: (r) => rect = r,
      rect: rect,
      edgePadding: const EdgeInsets.all(8.0),
      anchor: widget.anchor,
      child: widget.child,
    );
  }
}

class WindowScaffold extends StatelessWidget {
  const WindowScaffold({
    super.key,
    required this.child,
    this.leading,
    this.title,
    this.largeHeader = false,
  });

  final Widget? leading;
  final Widget? title;
  final bool largeHeader;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final headerHeight = largeHeader ? 48.0 : 36.0;

    return Surface(
      color: context.colors.surface.primary,
      shadows: context.shadows.window,
      borderSide: BorderSide(color: context.colors.divider),
      borderRadius: BorderRadius.circular(4.0),
      child: ConstrainedBox(
        constraints: .new(minWidth: 200.0),
        child: Stack(
          children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              child: ListItem(
                color: context.colors.surface.secondary,
                leading: leading,
                height: headerHeight,
                padding: largeHeader ? const .only(left: 8.0, right: 8.0) : const .only(left: 8.0, right: 6.0),
                trailing: IconButton.flat(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Icons.close(),
                ),
                title: title ?? const SizedBox.shrink(),
                dividerBelow: true,
              ),
            ),
            Padding(
              padding: .only(top: headerHeight),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
