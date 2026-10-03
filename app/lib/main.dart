import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/services.dart';

import 'embedded_server_io.dart' if (dart.library.js_interop) 'embedded_server_web.dart';

Future<void> main() async {
  AugmentedWidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    envOverride = DevelopmentEnv();
  }

  final embeddedServer = await createEmbeddedServer();

  Provider.debugCheckInvalidValueType = null;

  SystemChrome.setEnabledSystemUIMode(.manual, overlays: [.top]);
  runApp(
    Provider.value(
      value: embeddedServer,
      child: App(),
    ),
  );
}
