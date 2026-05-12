import 'package:app/app/app.dart';
import 'package:app/imports.dart';

import 'main_native.dart' if (dart.library.js_interop) 'main_web.dart';

Future<void> main() async {
  await initializePlatform();

  StackWidgetsFlutterBinding.ensureInitialized();
  initializeStack(errorDecoder: (_, _) => null, errorHandler: (e) {});

  runApp(const App());
}
