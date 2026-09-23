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
  });

  final Widget? leading;
  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Surface(
        color: context.colors.surface.primary,
        shadows: context.shadows.window,
        borderSide: BorderSide(color: context.colors.divider),
        borderRadius: BorderRadius.circular(4.0),
        child: ConstrainedBox(
          constraints: .new(minWidth: 200.0),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: .min,
              children: [
                DefaultForegroundStyle(
                  color: context.colors.display.tertiary,
                  child: Header(
                    leading: leading,
                    padding: const EdgeInsets.only(left: 8.0, right: 2.0),
                    trailing: IconButton.flat(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Icons.close(),
                    ),
                    title: title ?? const SizedBox.shrink(),
                  ),
                ),
                Divider(),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class WindowWidget<T> extends StatefulWidget {
//   const WindowWidget({
//     super.key,
//     required this.entry,
//     required this.builder,
//   });

//   final PortalEntry<T> entry;
//   final WidgetBuilder builder;

//   @override
//   State<WindowWidget<T>> createState() => WindowWidgetState<T>();
// }

// class WindowWidgetState<T> extends State<WindowWidget<T>> {
//   PortalEntry get entry => widget.entry;

//   AnimationStyle get animationStyle => widget.entry.animationStyle;
//   bool get isModal => widget.entry.isModal;

//   Rect? _rect;
//   Rect? get rect => _rect;

//   @override
//   Widget build(BuildContext context) {
//     Widget child = widget.builder(context);

//     return PortalPositioned(
//         rect: rect,
//         edgePadding: const EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0, bottom: 16.0),
//         onInitialRectComputed: (r) => _rect = r,
//         anchor: widget.entry.anchor,
//         // windowConstraints: BoxConstraints.loose(Size.square(400.0)),
//         child: Stack(
//           clipBehavior: .none,
//           children: [
//             WindowProxyNavigator<T>(
//               onPop: (result) {
//                 widget.entry._resolve(result);
//                 _animationController.reverse();
//               },
//               child: Material(
//                 type: .transparency,
//                 child: child,
//               ),
//             ),

//             // TODO: allow configurable draggable area.
//             Positioned(
//               left: 0.0,
//               right: 0.0,
//               top: 0.0,
//               height: 48.0,
//               child: DragActivityDetector(
//                 behavior: HitTestBehavior.translucent,
//                 activityFactory: (_) => WindowMoveActivity(
//                   initialRect: rect!,
//                   onChanged: (r) => setState(() => _rect = r),
//                 ),
//                 child: SizedBox.expand(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
