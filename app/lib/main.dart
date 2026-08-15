import 'package:app/app/app.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

void main() {
  if (kIsWeb) {
    final isRunningWithWasm = identical(double.nan, double.nan);

    // ignore: avoid_print
    print('wasm: $isRunningWithWasm');
  }

  AugmentedWidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}
