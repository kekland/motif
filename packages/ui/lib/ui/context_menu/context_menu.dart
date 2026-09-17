import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:ui/ui.dart';

part 'context_menu_manager.dart';

final class ContextMenu(
  final List<ContextMenuEntry> entries,
) {
  late final length = entries.length;
  late final items = entries.whereType<ContextMenuItem>().toList();
  late final itemCount = items.length;

  static ContextMenuRootState of(BuildContext context) => context.findAncestorStateOfType<ContextMenuRootState>()!;

  static Future<T?> push<T>(BuildContext context, ContextMenu menu, {PositionedGestureDetails? details}) {
    return of(context).push(context, menu, details: details);
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
    final selected = useState<(int, ContextMenuItem)?>(null);
    final selectedIndex = selected.value?.$1;
    final selectedItem = selected.value?.$2;

    void selectIndex(int i) {
      final index = i.clamp(0, menu.itemCount - 1);
      selected.value = (index, menu.items[index]);
    }

    void next() => selectIndex(selectedIndex != null ? selectedIndex + 1 : 0);
    void previous() => selectIndex(selectedIndex != null ? selectedIndex - 1 : 0);

    var itemIndex = 0;
    debugPaintFocusBoxes = false;

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == .arrowUp) {
            previous();
            return .handled;
          } else if (event.logicalKey == .arrowDown) {
            next();
            return .handled;
          }

          if (event.logicalKey == .enter) {
            if (selectedItem != null) {
              Navigator.pop(context, selectedItem.value);
              return .handled;
            }
          }
        }

        return .ignored;
      },
      child: ConstrainedBox(
        constraints: .new(maxHeight: 200.0),
        child: Surface(
          width: 160.0,
          color: context.colors.surface.secondary,
          borderSide: .new(color: context.colors.divider),
          borderRadius: .circular(4.0),
          shadows: context.shadows.window,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: menu.length,
            itemBuilder: (context, index) {
              final entry = menu.entries[index];
              if (entry is ContextMenuDivider) return const Divider();

              final item = entry as ContextMenuItem;
              final result = ListItem(
                isSelected: selectedIndex == itemIndex,
                height: 32.0,
                onTap: () => Navigator.pop(context, item.value),
                leading: item.icon,
                title: Text(item.label, style: context.typography.body),
                trailing: item.shortcut != null ? SingleActivatorWidget(value: item.shortcut!) : null,
              );

              itemIndex++;
              return result;
            },
          ),
        ),
      ),
    );
  }
}
