import 'dart:async';

import 'package:ui/ui.dart';

part 'tooltip_manager.dart';

extension type const TooltipData._((String label, SingleActivator? shortcut) _) {
  const TooltipData(String label, {SingleActivator? shortcut}) : this._((label, shortcut));

  String get label => _.$1;
  SingleActivator? get shortcut => _.$2;
}

class Tooltip extends StatefulHookWidget {
  const new({
    super.key,
    required this.tooltip,
    required this.child,
  });

  final TooltipData? tooltip;
  final Widget child;

  @override
  State<Tooltip> createState() => TooltipState();
}

class TooltipState extends State<Tooltip> {
  TooltipState? parent;
  Timer? timer;
  var suppressed = false;
  var suppressedByChild = false;
  late PortalEntry portal;

  bool get enabled => widget.tooltip != null;
  TooltipManagerState get manager => TooltipManager.of(context);

  @override
  void initState() {
    super.initState();
    parent = context.findAncestorStateOfType<TooltipState>();
  }

  @override
  void dispose() {
    timer?.cancel();
    parent = null;
    super.dispose();
  }

  void show() {
    if (!enabled) return;
    if (suppressed || suppressedByChild) return;
    portal.push(context, anchor: .compute(context, axis: .horizontal));
    manager.onShow();
  }

  void hide() {
    parent?.hide();

    if (!enabled) return;
    timer?.cancel();
    timer = null;
    if (portal.isActive) {
      portal.pop();
      manager.onHide();
    }
  }

  void schedule() {
    parent?.hide();

    if (!enabled) return;
    timer?.cancel();
    if (manager.isWarm) {
      show();
    } else {
      timer = manager.createTimer(show);
    }
  }

  void _suppressParent() {
    if (parent?.suppressedByChild == true) return;
    parent?.suppressedByChild = true;
    parent?._suppressParent();
  }

  void _unsuppressParent() {
    if (parent?.suppressedByChild == false) return;
    parent?.suppressedByChild = false;
    parent?._unsuppressParent();
  }

  @override
  Widget build(BuildContext context) {
    portal = usePortalEntry(
      () => PortalEntry(
        builder: (context) => TooltipOverlay(tooltip: widget.tooltip!),
      ),
      [widget.tooltip],
    );

    return Listener(
      onPointerDown: (_) {
        suppressed = true;
        hide();
      },
      onPointerSignal: (_) {
        hide();
      },
      child: MouseRegion(
        onEnter: (_) {
          suppressed = false;
          _suppressParent();
          schedule();
        },
        onHover: (_) {
          _suppressParent();
          schedule();
        },
        onExit: (_) {
          _unsuppressParent();
          hide();
        },
        child: widget.child,
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
        child: ConstrainedBox(
          constraints: .new(maxWidth: 160.0),
          child: Row(
            mainAxisSize: .min,
            children: [
              if (shortcut != null) ...[
                SingleActivatorWidget(value: shortcut),
                const SizedBox(width: 8.0),
              ],
              Flexible(
                child: DefaultForegroundStyle(
                  style: context.typography.body.primary,
                  child: Text(label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
