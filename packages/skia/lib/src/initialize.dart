import 'platform/initialize_native.dart' if (dart.library.js_interop) 'platform/initialize_web.dart';

abstract class Skia {
  static Future<void> initialize() => initializeImpl();
}
