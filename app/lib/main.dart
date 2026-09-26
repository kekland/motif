import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';
import 'package:skia/skia.dart' as skia;

Future<void> main() async {
  AugmentedWidgetsFlutterBinding.ensureInitialized();

  await skia.Skia.initialize();
  await SceneStorage.initialize();

  if (kDebugMode) {
    envOverride = DevelopmentEnv();
  }

  runApp(App());
}
