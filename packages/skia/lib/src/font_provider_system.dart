import 'package:skia/skia.dart';

import 'platform/font_provider_system_native.dart'
    if (dart.library.js_interop) 'platform/font_provider_system_web.dart';

abstract class FontProviderSystem {
  static Future<int> addSystemFonts(FontProvider provider) => addSystemFontsImpl(provider);
}
