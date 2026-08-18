import 'package:ui/ui.dart';
import 'package:ui/window/window.dart' as window;
import 'package:genie/genie.dart';

part 'window_transition.dart';

class WindowEntry<T> extends window.WindowEntry<T> {
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
    final anchor = window.WindowEntry.createAnchorForContext(context, padding: padding);
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

      child: ConstrainedBox(
        constraints: .new(minWidth: 200.0),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: .min,
            children: [
              DefaultForegroundStyle(
                color: context.colors.display.tertiary,
                child: Header(
                  leading: leading,
                  padding: const EdgeInsets.only(left: 8.0),
                  trailing: IconButton(
                    onTap: () => Navigator.of(context).maybePop(),
                    isFilled: false,
                    child: Icons.close(),
                  ),
                  title: title ?? const SizedBox.shrink(),
                ),
              ),
              Divider(),
              child,
            ],
          ),
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
