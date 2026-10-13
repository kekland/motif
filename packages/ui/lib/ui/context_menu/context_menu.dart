import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:ui/ui.dart';

import 'context_menu_controller.dart';

part 'context_menu_manager.dart';

final class ContextMenu(
  final List<ContextMenuEntry> entries, {
  final Object? selectedValue,
}) {
  late final length = entries.length;
  late final items = entries.whereType<ContextMenuItem>().toList();
  late final selectables = entries.where((e) => e is! ContextMenuDivider).toList();

  static const double itemExtent = 32.0;
  static const double dividerExtent = 8.0;
  static const double maxHeight = 240.0;

  static ContextMenuRootState of(BuildContext context) => context.findAncestorStateOfType<ContextMenuRootState>()!;

  static Future<T?> push<T>(BuildContext context, ContextMenu menu, {PositionedGestureDetails? details}) {
    return of(context).push(context, menu, details: details);
  }

  ContextMenuEntry? resolveSelectedItem() {
    if (selectedValue == null) return null;
    return items.firstWhereOrNull((item) => item.value == selectedValue);
  }

  int? resolveSelectedIndex() {
    final selectedItem = resolveSelectedItem();
    if (selectedItem == null) return null;
    return selectables.indexOf(selectedItem);
  }

  double _extentFor(ContextMenuEntry e) => switch (e) {
    ContextMenuItem() => ContextMenu.itemExtent,
    ContextMenuSubmenu() => ContextMenu.itemExtent,
    ContextMenuDivider() => ContextMenu.dividerExtent,
  };

  (double, double) resolveOffsets() {
    final selected = resolveSelectedIndex();
    if (selected == null) return (0.0, 0.0);

    final before = entries.take(selected).fold(0.0, (s, e) => s + _extentFor(e));
    final total = entries.fold(0.0, (s, e) => s + _extentFor(e));
    final viewport = min(total, maxHeight);
    final scrollOffset = (before + itemExtent / 2.0 - viewport / 2.0).clamp(0.0, max(0.0, total - viewport)).toDouble();
    final anchorOffset = before - scrollOffset + itemExtent / 2.0;
    return (scrollOffset, anchorOffset);
  }
}

sealed class const ContextMenuEntry() {
  static ContextMenuItem<T> item<T>(
    T value, {
    required String label,
    Widget? icon,
    SingleActivator? shortcut,
  }) => .new(value, label: label, icon: icon, shortcut: shortcut);

  static ContextMenuSubmenu submenu({
    required String label,
    required List<ContextMenuEntry> entries,
    Widget? icon,
  }) => .new(label: label, entries: entries, icon: icon);

  static const ContextMenuDivider divider = ContextMenuDivider();
}

final class const ContextMenuItem<T>(
  final T value, {
  required final String label,
  final Widget? icon,
  final SingleActivator? shortcut,
}) extends ContextMenuEntry;

final class const ContextMenuSubmenu({
  required final String label,
  required final List<ContextMenuEntry> entries,
  final Widget? icon,
}) extends ContextMenuEntry;

final class const ContextMenuDivider() extends ContextMenuEntry;

class ContextMenuWidget extends HookWidget {
  const new({
    super.key,
    required this.menu,
    this.controller,
    this.depth = 0,
    this.onSubmit,
  });

  final ContextMenu menu;
  final int depth;
  final ContextMenuController? controller;
  final ValueChanged<ContextMenuItem?>? onSubmit;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController(initialScrollOffset: menu.resolveOffsets().$1);
    final controller = useManagedResource(
      create: () => ContextMenuController(menu: menu, onExit: () => Navigator.pop(context)),
      dispose: (v) => v.dispose(),
      value: this.controller,
    );

    final currentActiveSubmenu = useRef<ContextMenuSubmenu?>(null);
    final submenuManager = usePortalEntryManager();

    void onSubmit(ContextMenuItem? item) {
      if (this.onSubmit != null) return this.onSubmit!(item);
      return Navigator.pop(context, item?.value);
    }

    useStaticListenerEffect(controller, () {
      final activeSubmenu = controller.activeSubmenus.elementAtOrNull(depth);
      if (currentActiveSubmenu.value != activeSubmenu?.$2) {
        currentActiveSubmenu.value = activeSubmenu?.$2;

        if (activeSubmenu != null) {
          final (context, entry) = activeSubmenu;
          submenuManager.push(
            context,
            .new(
              builder: (_) => ContextMenuWidget(
                menu: .new(entry.entries),
                depth: depth + 1,
                controller: controller,
                onSubmit: onSubmit,
              ),
            ),
            anchor: .compute(context, axis: .horizontal),
          );
        } else {
          submenuManager.pop();
        }
      }
    });

    final child = ConstrainedBox(
      constraints: .new(maxHeight: ContextMenu.maxHeight),
      child: Surface(
        width: 160.0,
        color: context.colors.surface.secondary,
        borderSide: .new(color: context.colors.divider),
        borderRadius: .circular(4.0),
        shadows: context.shadows.window,
        child: SearchableSelectableList(
          focusNode: FocusScope.of(context),
          items: menu.selectables,
          selection: menu.resolveSelectedItem(),
          onExpand: (item) {
            if (item is ContextMenuSubmenu) {
              controller.onSubmenuTap(context, item, depth);
              return true;
            }
            return false;
          },
          onCollapse: depth > 0 ? () => controller.onSubmenuPop(depth - 1) : null,
          onSubmit: (item) {
            if (item is ContextMenuItem) {
              onSubmit(item);
            } else if (item is ContextMenuSubmenu) {
              controller.onSubmenuTap(context, item, depth);
            }
          },
          builder: (context, _) => ListView.builder(
            controller: scrollController,
            itemCount: menu.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final entry = menu.entries[index];
              if (entry is ContextMenuDivider) return const Divider(height: ContextMenu.dividerExtent);

              final Widget child;

              if (entry is ContextMenuItem) {
                child = SelectableListItem(
                  value: entry,
                  builder: (context, isSelected) => ListItem(
                    onTap: () => onSubmit(entry),
                    height: ContextMenu.itemExtent,
                    isSelected: isSelected,
                    leading: entry.icon,
                    title: Text(entry.label, style: context.typography.body),
                    trailing: entry.shortcut != null ? SingleActivatorWidget(value: entry.shortcut!) : null,
                  ),
                );
              } else if (entry is ContextMenuSubmenu) {
                child = SelectableListItem(
                  value: entry,
                  builder: (context, isSelected) => ListItem(
                    onTap: () => controller.onSubmenuTap(context, entry, depth),
                    height: ContextMenu.itemExtent,
                    isSelected: isSelected,
                    leading: entry.icon,
                    title: Text(entry.label, style: context.typography.body),
                    trailing: Icons.chevronRight(),
                  ),
                );
              } else {
                unreachable();
              }

              return Builder(
                builder: (context) => MouseRegion(
                  hitTestBehavior: .translucent,
                  onEnter: (_) => controller.onItemHover(context, entry, depth),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );

    return MouseRegion(
      hitTestBehavior: .translucent,
      onExit: (_) => controller.onMenuExit(),
      child: child,
    );
  }
}
