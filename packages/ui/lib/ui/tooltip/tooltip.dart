import 'dart:async';

import 'package:ui/ui.dart';

part 'tooltip_manager.dart';

extension type const TooltipData._((String label, SingleActivator? shortcut) _) {
  const TooltipData(String label, {SingleActivator? shortcut}) : this._((label, shortcut));

  String get label => _.$1;
  SingleActivator? get shortcut => _.$2;
}

class Tooltip extends HookWidget {
  const new({
    super.key,
    required this.tooltip,
    required this.child,
  });

  final TooltipData? tooltip;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final manager = TooltipManager.of(context);
    final timer = useRef<Timer?>(null);
    final suppressed = useRef(false);
    final enabled = tooltip != null;

    final portal = usePortalEntry(
      () => PortalEntry(
        builder: (context) => TooltipOverlay(tooltip: tooltip!),
      ),
      [tooltip],
    );

    void show() {
      if (!enabled) return;
      if (suppressed.value) return;
      portal.push(context, anchor: .compute(context, axis: .horizontal));
      manager.onShow();
    }

    void hide() {
      if (!enabled) return;
      timer.value?.cancel();
      timer.value = null;
      if (portal.isActive) {
        portal.pop();
        manager.onHide();
      }
    }

    void schedule() {
      if (!enabled) return;
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
  });

  final TooltipData tooltip;

  @override
  Widget build(BuildContext context) {
    final label = tooltip.label;
    final shortcut = tooltip.shortcut;

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
              SingleActivatorWidget(value: shortcut),
              const SizedBox(width: 8.0),
            ],
            DefaultForegroundStyle(
              style: context.typography.body.primary,
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
