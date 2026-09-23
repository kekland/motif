import 'package:app/app/root_navigation_bar.dart';
import 'package:app/home/home_page.dart';
import 'package:app/imports.dart';

class App extends StatefulWidget {
  const App({super.key});

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final tabs = <AppTab>[];
  var activeTab = 0;

  @override
  void initState() {
    super.initState();
    tabs.add(
      .new(
        body: HomePage(),
        leading: Icons.home(),
        title: 'Home',
      ),
    );
  }

  void push(AppTab tab) {
    tabs.add(tab);
    activeTab = tabs.length - 1;
    setState(() {});
  }

  void remove(int i) {
    if (i == 0) throw StateError('cannot pop home tab');
    tabs.removeAt(i);
    if (activeTab >= tabs.length) activeTab = tabs.length - 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = Colors.indigo;
    final theme = generateAppTheme(
      brightness: .dark,
      seedColor: seedColor,
    );

    return AppThemeWidget(
      theme: theme,
      iconTheme: .new(
        weight: 200.0,
        grade: 0.0,
        size: 20.0,
      ),
      builder: (context, materialTheme) => Surface(
        color: theme.colors.surface.primary,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          theme: materialTheme,
          home: Scaffold(
            child: TooltipManager(
              child: PortalRoot(
                anchorResolver: (context) => .compute(context),
                child: ContextMenuRoot(
                  child: Column(
                    children: [
                      AppNavigationBar(
                        tabs: tabs,
                        activeTab: activeTab,
                        onTabSelected: (i) => setState(() => activeTab = i),
                        onTabClosed: (i) => remove(i),
                      ),
                      Divider(),
                      Expanded(
                        child: IndexedStack(
                          index: activeTab,
                          children: [
                            for (final t in tabs) KeyedSubtree(key: t.key, child: t.body),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
