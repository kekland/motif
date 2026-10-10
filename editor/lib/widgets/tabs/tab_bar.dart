import 'package:editor/imports.dart';

enum EditorTab {
  prefabs,
  generators,
  variables,
  animation;

  Widget icon(BuildContext context) => switch (this) {
    .prefabs => Icons.prefabs(),
    .generators => Icons.generator(),
    .variables => Icons.variable(),
    .animation => Icons.animation(),
  };

  String name(BuildContext context) => switch (this) {
    .prefabs => 'Prefabs',
    .generators => 'Generators',
    .variables => 'Variables',
    .animation => 'Animation',
  };
}

class EditorTabBar extends HookWidget {
  const new({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final tabSignal = context.editor.tab;
    final selectedTab = useExistingSignal(tabSignal).value;

    return Surface(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: .horizontal,
              itemCount: EditorTab.values.length,
              itemBuilder: (context, i) {
                final tab = EditorTab.values[i];
                return Row(
                  children: [
                    ListItem(
                      isSelected: selectedTab == tab,
                      onTap: () {
                        if (context.editor.tab.value == tab) {
                          tabSignal.value = null;
                          context.editor.panels.collapse(.tab);
                        } else {
                          context.editor.tab.value = tab;
                          context.editor.panels.expand(.tab);
                        }
                      },
                      width: 160.0,
                      leading: tab.icon(context),
                      title: Text(tab.name(context)),
                    ),
                    VerticalDivider(),
                  ],
                );
              },
            ),
          ),
          VerticalDivider(),
          HookBuilder(
            builder: (context) {
              final isVisible = useListenable(context.editor.toolOptionsWindow).isActive;

              return IconButton.flat(
                size: height,
                borderRadius: .zero,
                onTap: () => context.editor.toolOptionsWindow.toggle(context),
                isSelected: isVisible,
                tooltip: .new('Tool options', shortcut: .new(.keyO)),
                child: Icons.tune(),
              );
            },
          ),
          VerticalDivider(),
          SignalBuilder(
            builder: (context) {
              final isVisible = context.editor.commander.isVisible.value;
              return IconButton.flat(
                size: height,
                borderRadius: .zero,
                tooltip: .new('Command palette', shortcut: .new(.slash)),
                isSelected: isVisible,
                onTap: () => context.editor.commander.push(context),
                child: Icons.commander(),
              );
            },
          ),
        ],
      ),
    );
  }
}
