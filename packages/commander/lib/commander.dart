import 'package:flutter/services.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class CommanderRoot extends HookWidget {
  const CommanderRoot({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = useOverlayPortalController();

    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == .escape && controller.isShowing) {
            controller.hide();
            return .handled;
          }
          if (event.logicalKey == .slash && !controller.isShowing) {
            controller.show();
            return .handled;
          }
        }

        return .ignored;
      },
      child: OverlayPortal(
        controller: controller,
        overlayChildBuilder: (context) => CommanderOverlay(),
        child: child,
      ),
    );
  }
}

class CommanderOverlay extends HookWidget {
  const CommanderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    useCallOncePostFrame(() => focusNode.requestFocus());

    return Center(
      child: Surface(
        width: 400.0,
        height: 64.0,
        borderRadius: .circular(4.0),
        color: context.colors.surface.secondary,
        shadows: context.shadows.window,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          options: .new(
            padding: .symmetric(horizontal: 16.0),
            leading: Text('/'),
            hintText: 'command',
          ),
        ),
      ),
    );
  }
}
