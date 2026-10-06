import 'package:app/imports.dart';
import 'package:app/servers.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'embedded_server_io.dart' if (dart.library.js_interop) 'embedded_server_web.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  AugmentedWidgetsFlutterBinding.ensureInitialized();

  final embeddedServer = await createEmbeddedServer();
  prefs = await SharedPreferences.getInstance();

  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setEnabledSystemUIMode(.manual, overlays: [.top]);

  if (prefs.getString('userId') == null) {
    prefs.setString('userId', uuid.v4());
  }

  if (prefs.getStringList('servers') == null) {
    prefs.setStringList('servers', ['https://motif.kz/api']);
  }

  final servers = AppServers(embeddedServer);

  runApp(
    Provider.value(
      value: servers,
      child: App(),
    ),
  );
}
