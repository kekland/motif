import 'dart:async';

import 'package:ui/ui.dart';

part 'tooltip_manager.dart';

class Tooltip extends HookWidget {
  const new({
    super.key,
    required this.tooltip,
    this.shortcut,
    required this.child,
  });

  final Widget tooltip;
  final SingleActivator? shortcut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final manager = TooltipManager.of(context);
    final timer = useRef<Timer?>(null);
    final suppressed = useRef(false);

    final portal = usePortalEntry(
      () => PortalEntry(
        builder: (context) => TooltipOverlay(
          tooltip: tooltip,
          shortcut: shortcut,
        ),
      ),
    );

    void show() {
      if (suppressed.value) return;
      portal.push(context, anchor: .compute(context, axis: .horizontal));
      manager.onShow();
    }

    void hide() {
      timer.value?.cancel();
      timer.value = null;
      if (portal.isActive) {
        portal.pop();
        manager.onHide();
      }
    }

    void schedule() {
      timer.value?.cancel();
      if (manager.isWarm) {
        show();
      } else {
        timer.value = manager.createTimer(show);
      }
    }

    return Listener(
      onPointerDown: (_) {
        suppressed.value = true;
        hide();
      },
      onPointerSignal: (_) {
        hide();
      },
      child: MouseRegion(
        onEnter: (_) {
          suppressed.value = false;
          schedule();
        },
        onHover: (_) => schedule(),
        onExit: (_) => hide(),
        child: child,
      ),
    );
  }
}

class TooltipOverlay extends StatelessWidget {
  const new({
    super.key,
    required this.tooltip,
    this.shortcut,
  });

  final SingleActivator? shortcut;
  final Widget tooltip;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Surface(
        color: context.colors.surface.secondary,
        shadows: context.shadows.window,
        borderRadius: .circular(8.0),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: .min,
          children: [
            if (shortcut != null) ...[
              SingleActivatorWidget(value: shortcut!),
              const SizedBox(width: 8.0),
            ],
            DefaultForegroundStyle(
              style: context.typography.body.primary,
              child: tooltip,
            ),
          ],
        ),
      ),
    );
  }
}
