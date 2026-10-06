import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

part 'context_menu_manager.dart';

final class ContextMenu(
  final List<ContextMenuEntry> entries, {
  final Object? selectedValue,
}) {
  late final length = entries.length;
  late final items = entries.whereType<ContextMenuItem>().toList();
  late final itemCount = items.length;

  static const double itemExtent = 32.0;
  static const double dividerExtent = 8.0;
  static const double maxHeight = 200.0;

  static ContextMenuRootState of(BuildContext context) => context.findAncestorStateOfType<ContextMenuRootState>()!;

  static Future<T?> push<T>(BuildContext context, ContextMenu menu, {PositionedGestureDetails? details}) {
    return of(context).push(context, menu, details: details);
  }

  ContextMenuItem? resolveSelectedItem() {
    if (selectedValue == null) return null;
    return items.firstWhereOrNull((item) => item.value == selectedValue);
  }

  int? resolveSelectedIndex() {
    final selectedItem = resolveSelectedItem();
    if (selectedItem == null) return null;
    return items.indexOf(selectedItem);
  }

  double _extentFor(ContextMenuEntry e) => switch (e) {
    ContextMenuItem() => ContextMenu.itemExtent,
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

  static const ContextMenuDivider divider = ContextMenuDivider();
}

final class const ContextMenuItem<T>(
  final T value, {
  required final String label,
  final Widget? icon,
  final SingleActivator? shortcut,
}) extends ContextMenuEntry;

final class const ContextMenuDivider() extends ContextMenuEntry;

class ContextMenuWidget extends HookWidget {
  const new({
    super.key,
    required this.menu,
  });

  final ContextMenu menu;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController(
      initialScrollOffset: menu.resolveOffsets().$1,
    );

    return ConstrainedBox(
      constraints: .new(maxHeight: ContextMenu.maxHeight),
      child: Surface(
        width: 160.0,
        color: context.colors.surface.secondary,
        borderSide: .new(color: context.colors.divider),
        borderRadius: .circular(4.0),
        shadows: context.shadows.window,
        child: SearchableSelectableList(
          focusNode: FocusScope.of(context),
          items: menu.items,
          selection: menu.resolveSelectedItem(),
          onSubmit: (item) => Navigator.pop(context, item?.value),
          builder: (context, _) => ListView.builder(
            controller: scrollController,
            itemCount: menu.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final entry = menu.entries[index];
              if (entry is ContextMenuDivider) return const Divider(height: ContextMenu.dividerExtent);

              final item = entry as ContextMenuItem;
              final result = SelectableListItem(
                value: item,
                builder: (context, isSelected) => ListItem(
                  onTap: () => Navigator.pop(context, item.value),
                  height: ContextMenu.itemExtent,
                  isSelected: isSelected,
                  leading: item.icon,
                  title: Text(item.label, style: context.typography.body),
                  trailing: item.shortcut != null ? SingleActivatorWidget(value: item.shortcut!) : null,
                ),
              );

              return result;
            },
          ),
        ),
      ),
    );
  }
}
