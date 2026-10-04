import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final class const InheritedCallbackShortcuts({
  super.key,
  required final Widget child,
}) extends StatefulWidget {
  static InheritedCallbackShortcutsState of(BuildContext context) =>
      context.findAncestorStateOfType<InheritedCallbackShortcutsState>()!;

  @override
  State<InheritedCallbackShortcuts> createState() => InheritedCallbackShortcutsState();
}

class InheritedCallbackShortcutsState extends State<InheritedCallbackShortcuts> {
  final _attached = <ProxyCallbackShortcuts>[];

  void attach(ProxyCallbackShortcuts shortcuts) {
    _attached.add(shortcuts);
  }

  void detach(ProxyCallbackShortcuts shortcuts) {
    _attached.remove(shortcuts);
  }

  @override
  void dispose() {
    _attached.clear();
    super.dispose();
  }

  bool _applyKeyEventBinding(ShortcutActivator activator, VoidCallback callback, KeyEvent event) {
    if (activator.accepts(event, HardwareKeyboard.instance)) {
      callback();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        KeyEventResult result = .ignored;

        for (final shortcuts in _attached) {
          for (final binding in shortcuts.bindings.entries) {
            final activator = binding.key;
            final callback = binding.value;
            result = _applyKeyEventBinding(activator, callback, event) ? .handled : result;
          }
        }

        return result;
      },
      child: widget.child,
    );
  }
}

final class const ProxyCallbackShortcuts({
  super.key,
  required final Map<ShortcutActivator, VoidCallback> bindings,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProxyCallbackShortcutsState();
}

class ProxyCallbackShortcutsState extends State<ProxyCallbackShortcuts> {
  InheritedCallbackShortcutsState? _parent;

  @override
  void initState() {
    super.initState();
    _parent = InheritedCallbackShortcuts.of(context);
    _parent?.attach(widget);
  }

  @override
  void didUpdateWidget(covariant ProxyCallbackShortcuts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_parent != null) {
      _parent!.detach(oldWidget);
      _parent!.attach(widget);
    }
  }

  @override
  void dispose() {
    _parent?.detach(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
