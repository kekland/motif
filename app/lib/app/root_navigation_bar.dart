import 'package:app/imports.dart';
import 'package:native/native.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.tabs,
    required this.activeTab,
    this.onTabSelected,
    this.onTabClosed,
  });

  final List<AppTab> tabs;
  final int activeTab;
  final ValueChanged<int>? onTabSelected;
  final ValueChanged<int>? onTabClosed;

  @override
  Widget build(BuildContext context) {
    return Surface(
      color: context.colors.surface.primary,
      child: SafeArea(
        top: true,
        bottom: false,
        child: WindowTitlebar(
          preferredHeight: 36.0,
          trafficLightsHorizontalOffset: 12.0,
          child: Row(
            children: [
              VerticalDivider(),
              Expanded(
                child: AppTabBar(
                  tabs: tabs,
                  activeTab: activeTab,
                  onTabSelected: onTabSelected,
                  onTabClosed: onTabClosed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTabBar extends StatelessWidget {
  const new({
    super.key,
    required this.tabs,
    required this.activeTab,
    this.onTabSelected,
    this.onTabClosed,
  });

  final List<AppTab> tabs;
  final int activeTab;
  final ValueChanged<int>? onTabSelected;
  final ValueChanged<int>? onTabClosed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: .horizontal,
      itemCount: 1 + tabs.length,
      separatorBuilder: (context, i) => const VerticalDivider(),
      itemBuilder: (context, i) {
        if (i == tabs.length) return SizedBox.shrink();
        if (i == 0) {
          return ListItem(
            onTap: () => onTabSelected?.call(0),
            isSelected: activeTab == 0,
            expands: false,
            selectedColor: context.colors.surface.secondary,
            leading: Center(child: Icons.home()),
          );
        }

        final tab = tabs[i];
        return ListItem(
          onTap: () => onTabSelected?.call(i),
          trailing: IconButton.flat(
            onTap: () => onTabClosed?.call(i),
            child: Icons.close(),
          ),
          expands: false,
          isSelected: i == activeTab,
          leading: tab.leading,
          selectedColor: context.colors.surface.secondary,
          title: Text(tab.title),
        );
      },
    );
  }
}

class AppTab {
  new({
    required this.title,
    required this.body,
    this.leading,
  }) : key = GlobalKey();

  final Widget? leading;
  final String title;
  final GlobalKey key;
  final Widget body;
}
