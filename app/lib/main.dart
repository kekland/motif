import 'package:app/imports.dart';
import 'package:bindings/bindings.dart';

Future<void> main() async {
  if (kIsWeb) {
    final isRunningWithWasm = identical(double.nan, double.nan);

    // ignore: avoid_print
    print('wasm: $isRunningWithWasm');
  }

  AugmentedWidgetsFlutterBinding.ensureInitialized();
  await SceneStorage.initialize();

  runApp(App());
}
