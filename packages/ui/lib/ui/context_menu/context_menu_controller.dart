import 'dart:async';

import 'package:ui/ui.dart';

typedef ActiveSubmenu = (BuildContext, ContextMenuSubmenu);

const _kInteractionDelay = Duration(milliseconds: 200);

final class ContextMenuController with ChangeNotifier, ChangeNotifierDisposable {
  new({required this.menu, required this.onExit});

  final ContextMenu menu;
  final VoidCallback onExit;
  ContextMenu submenu(ContextMenuSubmenu entry) => .new(entry.entries);

  final _activeSubmenus = <ActiveSubmenu>[];
  List<ActiveSubmenu> get activeSubmenus => _activeSubmenus;

  Timer? _transitionTimer;

  void onItemHover(BuildContext context, ContextMenuEntry entry, int depth) {
    if (isDisposed) return;
    _transitionTimer?.cancel();

    if (entry is ContextMenuSubmenu) {
      _transitionTimer = Timer(_kInteractionDelay, () {
        _openSubmenu(context, entry, depth);
      });
    } else if (entry is ContextMenuItem) {
      _transitionTimer = Timer(_kInteractionDelay, () {
        _closeSubmenus(depth);
      });
    }
  }

  void onSubmenuPanelHover() {
    _transitionTimer?.cancel();
  }

  void onSubmenuTap(BuildContext context, ContextMenuSubmenu submenu, int depth) {
    if (isDisposed) return;
    _transitionTimer?.cancel();

    if (_activeSubmenus.length > depth && _activeSubmenus[depth].$2 == submenu) {
      _closeSubmenus(depth);
    } else {
      _openSubmenu(context, submenu, depth);
    }
  }

  void onSubmenuPop(int depth) {
    if (isDisposed) return;
    _transitionTimer?.cancel();
    _closeSubmenus(depth);
  }

  void _openSubmenu(BuildContext context, ContextMenuSubmenu submenu, int depth) {
    if (_activeSubmenus.length > depth) {
      _activeSubmenus.removeRange(depth, _activeSubmenus.length);
    }

    if (_activeSubmenus.any((e) => e.$2 == submenu)) return;
    _activeSubmenus.add((context, submenu));
    notifyListeners();
  }

  void _closeSubmenus(int depth) {
    if (_activeSubmenus.length > depth) {
      _activeSubmenus.removeRange(depth, _activeSubmenus.length);
      notifyListeners();
    }
  }

  void onMenuExit() {
    if (isDisposed) return;
    _transitionTimer?.cancel();
    _transitionTimer = Timer(_kInteractionDelay, onExit);
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }
}
