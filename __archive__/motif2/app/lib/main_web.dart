import 'dart:js_interop';

import 'package:skia/geometry/web.dart';

@JS('skiaReady')
external JSPromise get _skiaReady;

Future<void> skiaReady() => _skiaReady.toDart;

Future<void> initializePlatform() async {
  await skiaReady();
  GeneratedBindings.initBindings('skia');
}
