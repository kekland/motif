import 'package:app/imports.dart';
import 'package:app/app/root_page.dart';
import 'package:design/design.dart';
import 'package:stack_window_manager/stack_window_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = Colors.blue;
    final brightness = Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      dynamicSchemeVariant: .fidelity,
      contrastLevel: 0.0,
    );

    final theme = generateAppTheme(
      seedColor: seedColor,
      brightness: colorScheme.brightness,
      dynamicSchemeVariant: .fidelity,
      contrastLevel: 0.0
    );

    final themeData = ThemeData.from(colorScheme: colorScheme).copyWith(
      dividerColor: theme.colors.divider,
      dividerTheme: .new(color: theme.colors.divider, space: 1.0),
    );

    return InheritedAppTheme(
      theme: theme,
      child: Surface(
        color: theme.colors.surface.primary,
        child: TransientTransformsTickerProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            theme: themeData,
            home: WindowRoot(child: RootPage()),
          ),
        ),
      ),
    );
  }
}
