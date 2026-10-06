import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'embedded_server_io.dart' if (dart.library.js_interop) 'embedded_server_web.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  AugmentedWidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    envOverride = DevelopmentEnv();
  }

  final embeddedServer = await createEmbeddedServer();
  prefs = await SharedPreferences.getInstance();

  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setEnabledSystemUIMode(.manual, overlays: [.top]);

  runApp(
    Provider.value(
      value: embeddedServer,
      child: App(),
    ),
  );
}
