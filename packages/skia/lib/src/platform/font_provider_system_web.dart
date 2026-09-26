import 'dart:js_interop';

import 'package:skia/skia.dart';
import 'package:web/web.dart' as web;

extension type _FontData(JSObject _) implements JSObject {
  external String get family;
  external String get postscriptName;
  external JSPromise<web.Blob> blob();
}

@JS('queryLocalFonts')
external JSPromise<JSArray<_FontData>> _queryLocalFonts();

Future<int> addSystemFontsImpl(FontProvider provider) async {
  var added = 0;

  for (final font in (await _queryLocalFonts().toDart).toDart) {
    final blob = await font.blob().toDart;
    final bytes = (await blob.arrayBuffer().toDart).toDart.asUint8List();
    if (provider.add(bytes)) added++;
  }

  return added;
}
