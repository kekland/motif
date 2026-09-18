part of 'command.dart';

class CommanderRoot extends StatefulWidget {
  const CommanderRoot({super.key, required this.child});

  static CommanderRootState? maybeOf(BuildContext context) => context.findAncestorStateOfType<CommanderRootState>();
  static CommanderRootState of(BuildContext context) => context.findAncestorStateOfType<CommanderRootState>()!;

  final Widget child;

  @override
  State<CommanderRoot> createState() => CommanderRootState();
}

class CommanderRootState extends State<CommanderRoot> {
  late final isVisible = signal(false);
  late final _entry = PortalEntry(
    builder: (_) => CommanderOverlay(outerContext: context),
    isModal: true,
  );

  void push(BuildContext context) {
    _entry.push(context).then((_) => isVisible.value = false);
    isVisible.value = true;
  }

  void pop() {
    isVisible.value = false;
    _entry.pop();
  }

  void toggle() {
    if (isVisible.value) {
      pop();
    } else {
      push(context);
    }
  }

  @override
  void dispose() {
    _entry.pop(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == .slash && !_entry.isActive) {
            push(context);
            return .handled;
          }
        }

        return .ignored;
      },
      child: widget.child,
    );
  }
}

class CommanderOverlay extends HookWidget {
  const CommanderOverlay({
    super.key,
    required this.outerContext,
  });

  final BuildContext outerContext;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final focusScopeNode = useFocusScopeNode();

    final commands = useRef(
      queryActions(outerContext).whereType<CommandAction>().toList(),
    ).value;

    final sorted = useState(commands);
    final selected = useState<CommandAction?>(commands.first);
    final selectedIndex = useState<int?>(0);
    // commands.map((c) => (c, score: searchScore(controller.text, c.command))).where((e) => e.score != null).toList()
    //   ..sort((a, b) => b.score!.compareTo(a.score!));

    useControllerTextEffect(
      controller,
      (query) {
        if (query.isEmpty) {
          sorted.value = commands;
          selected.value = commands.first;
          selectedIndex.value = 0;
          return;
        }

        final result =
            commands
                .map((c) => (c, score: searchScore(query, c.descriptor.command)))
                .where((e) => e.score != null)
                .toList()
              ..sort((a, b) => b.score!.compareTo(a.score!));

        final resultCommands = result.map((e) => e.$1).toList();
        sorted.value = resultCommands;
        selected.value = resultCommands.isNotEmpty ? resultCommands.first : null;
        selectedIndex.value = resultCommands.isNotEmpty ? 0 : null;
      },
    );

    void submit(CommandAction action) {
      final intent = action.descriptor.build(outerContext, []);
      outerContext.invoke(intent);
      Navigator.pop(context);
    }

    return FocusScope(
      node: focusScopeNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == .escape) {
            Navigator.pop(context);
            return .handled;
          }
        }

        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          final currentIndex = selectedIndex.value;

          if (currentIndex != null) {
            int? nextIndex;
            if (event.logicalKey == .arrowUp) {
              nextIndex = currentIndex - 1;
            } else if (event.logicalKey == .arrowDown) {
              nextIndex = currentIndex + 1;
            }

            if (nextIndex != null) {
              nextIndex = nextIndex.clamp(0, sorted.value.length - 1);
              selectedIndex.value = nextIndex;
              selected.value = sorted.value[nextIndex];
              return .handled;
            }
          }
        }

        return .ignored;
      },
      child: Center(
        child: FractionalTranslation(
          translation: .new(0.0, 0.5),
          child: Surface(
            width: 400.0,
            shadows: context.shadows.window,
            color: context.colors.surface.secondary,
            borderSide: .new(color: context.colors.divider),
            borderRadius: .circular(4.0),
            child: ConstrainedBox(
              constraints: .new(maxHeight: 400.0),
              child: Column(
                mainAxisSize: .min,
                children: [
                  CommanderInputField(
                    controller: controller,
                    focusNode: focusNode,
                    onSubmitted: () {
                      final action = selected.value;
                      if (action != null) submit(action);
                    },
                  ),
                  Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: sorted.value.length,
                    itemBuilder: (context, index) {
                      final action = sorted.value[index];
                      return CommandSuggestionWidget(
                        action: action,
                        isSelected: action == selected.value,
                        onTap: () => submit(action),
                      );
                    },
                    separatorBuilder: (context, i) => Divider(
                      height: 1.0,
                      color: context.colors.divider,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommanderInputField extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Surface(
      width: 400.0,
      height: 48.0,
      borderRadius: .vertical(top: .circular(4.0)),
      color: context.colors.surface.secondary,
      shadows: context.shadows.window,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        options: .new(
          autofocus: true,
          padding: .symmetric(horizontal: 12.0),
          borderRadius: .vertical(top: .circular(4.0)),
          border: .none,
          leading: Text('>'),
          hintText: 'command',
        ),
      ),
    );
  }
}

class CommandSuggestionWidget extends StatelessWidget {
  const new({
    super.key,
    required this.action,
    this.isSelected = false,
    this.onTap,
  });

  final CommandAction action;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final descriptor = action.descriptor;
    final command = descriptor.command;
    final description = descriptor.resolveDescription(context);
    final shortcut = descriptor.resolveShortcut(context).firstOrNull;

    return Surface(
      width: 400.0,
      height: 28.0,
      color: context.colors.surface.secondary,
      child: ListItem(
        isSelected: isSelected,
        onTap: onTap,
        title: Text(
          command,
          style: context.typography.body,
        ),
        trailing: Row(
          children: [
            Text(
              description ?? '',
              // style: context.typography.body.tertiary,
            ),
            if (shortcut != null) ...[
              SizedBox(width: 8.0),
              SingleActivatorWidget(value: shortcut),
            ],
          ],
        ),
      ),
    );
  }
}
