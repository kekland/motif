import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';
import 'main_native.dart' if (dart.library.js_interop) 'main_web.dart';

Future<void> main() async {
  await initializePlatform();
  AugmentedWidgetsFlutterBinding.ensureInitialized();
  await SceneStorage.initialize();
  runApp(App());
}
