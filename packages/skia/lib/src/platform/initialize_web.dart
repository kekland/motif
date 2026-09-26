import 'dart:js_interop';

import 'package:skia/src/gen/skia_bindings_web.g.dart';

@JS('skiaReady')
external JSPromise get _skiaReady;

Future<void> skiaReady() => _skiaReady.toDart;

Future<void> initializeImpl() async {
  await skiaReady();
  GeneratedBindings.initBindings('skia');
}
