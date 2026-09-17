import 'package:editor/imports.dart';

enum EditorTab {
  generators,
  variables;

  Widget icon(BuildContext context) => switch (this) {
    .generators => Icons.generator(),
    .variables => Icons.variable(),
  };

  String name(BuildContext context) => switch (this) {
    .generators => 'Generators',
    .variables => 'Variables',
  };
}

class EditorTabBar extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final tabSignal = context.editor.tab;
    final selectedTab = useExistingSignal(tabSignal).value;

    return Surface(
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
    );
  }
}
