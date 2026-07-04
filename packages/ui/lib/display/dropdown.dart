import 'package:flutter/widgets.dart';
import 'package:stack_window_manager/stack_window_manager.dart' as wm;
import 'package:ui/ui.dart';

class DropdownEntry<T> {
  const DropdownEntry({
    this.leading,
    required this.label,
    this.onTap,
    this.children,
  });

  final T? Function()? onTap;
  final Widget? leading;
  final Widget label;
  final List<DropdownEntry<T>>? children;
}

class _DropdownRoute<T> extends PopupRoute<T> {
  _DropdownRoute({
    required this.anchorContext,
    required this.entries,
  }) {
    _anchor = wm.WindowEntry.createAnchorForContext(anchorContext);
  }

  final BuildContext anchorContext;
  final List<DropdownEntry<T>> entries;
  late final wm.WindowAnchor _anchor;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Dropdown<T>(
      entries: entries,
      anchor: _anchor,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class Dropdown<T> extends StatelessWidget {
  const Dropdown({
    super.key,
    required this.entries,
    required this.anchor,
  });

  static Future<T?> push<T>(
    BuildContext context, {
    required List<DropdownEntry<T>> entries,
  }) {
    return Navigator.of(context).push<T>(
      _DropdownRoute<T>(anchorContext: context, entries: entries),
    );
  }

  final List<DropdownEntry<T>> entries;
  final wm.WindowAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: anchor.rect.bottom,
          left: anchor.rect.left,
          child: Surface(
            width: 100.0,
            height: 100.0,
            color: context.colors.surface.secondary,
            shadows: context.shadows.window,
          ),
        ),
      ],
    );
  }
}
