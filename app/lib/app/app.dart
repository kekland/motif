import 'package:app/imports.dart';
import 'package:app/app/root_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = Colors.grey;
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
          showPerformanceOverlay: true,
          theme: materialTheme,
          home: RootPage(),
        ),
      ),
    );
  }
}
