import 'package:app/app/app.dart';
import 'package:bindings/bindings.dart';
import 'package:flutter/widgets.dart';

void main() {
  AugmentedWidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}
