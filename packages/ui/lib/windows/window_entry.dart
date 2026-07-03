import 'package:genie/genie.dart';
import 'package:ui/ui.dart';
import 'package:stack_window_manager/stack_window_manager.dart' as window_manager;

part 'window_transition.dart';

class WindowEntry<T> extends window_manager.WindowEntry<T> {
  WindowEntry._({
    required super.builder,
    super.anchor,
    super.isModal,
    super.animationStyle,
    super.transitionBuilder,
  });

  factory WindowEntry.withContextAnchor(
    BuildContext context, {
    required WidgetBuilder builder,
    EdgeInsets padding = const .all(16.0),
    bool isModal = false,
  }) {
    final anchor = window_manager.WindowEntry.createAnchorForContext(context, padding: padding);
    final genieRect = anchor.rect.center & Size.zero;

    return WindowEntry._(
      builder: builder,
      anchor: anchor,
      animationStyle: context.animations.window,
      transitionBuilder: windowTransitionBuilder(genieRect),
    );
  }
}

class WindowScaffold extends StatelessWidget {
  const WindowScaffold({
    super.key,
    required this.child,
    this.leading,
    this.title,
  });

  final Widget? leading;
  final Widget? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Surface(
      color: context.colors.surface.primary,
      shadows: context.shadows.window,
      borderSide: BorderSide(color: context.colors.divider),
      borderRadius: BorderRadius.circular(4.0),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: .min,
          children: [
            DefaultForegroundStyle(
              color: context.colors.display.tertiary,
              child: Subtitle(
                leading: leading,
                trailing: IconButton(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Icons.close(),
                ),
                child: title ?? const SizedBox.shrink(),
              ),
            ),
            Divider(height: 1.0, color: context.colors.divider),
            child,
          ],
        ),
      ),
    );
  }
}

(void Function(BuildContext), bool) useCreateWindowEntry(WindowEntry Function(BuildContext) createEntry) {
  final entry = useState<WindowEntry?>(null);

  useOnDispose(() {
    entry.value?.remove();
    entry.value?.dispose();
  });

  void callback(BuildContext context) {
    if (entry.value != null && entry.value!.isActive) {
      entry.value!.remove();
      entry.value = null;
      return;
    }

    entry.value?.dispose();

    final newEntry = createEntry(context);
    newEntry.insert(context);
    newEntry.addRemovedListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => newEntry.dispose());
      entry.value = null;
    });

    entry.value = newEntry;
  }

  return (callback, entry.value != null && entry.value!.isActive);
}
