import 'package:objective_c/objective_c.dart';
import 'package:native/macos.dart' as macos;

extension FlutterWindow on macos.NSApplication {
  macos.NSWindow get flutterWindow {
    final window = windows.firstObject!;
    return macos.NSWindow.fromPointer(window.ref.pointer);
  }
}
