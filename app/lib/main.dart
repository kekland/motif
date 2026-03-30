import 'package:app/app/app.dart';
import 'package:app/imports.dart';

Future<void> main() async {
  StackWidgetsFlutterBinding.ensureInitialized();
  initializeStack(
    errorDecoder: (_, _) => null,
    errorHandler: (e) {},
  );

  runApp(const App());
}
