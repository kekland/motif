import 'dart:js_interop' as js;

@js.JS()
external Window get window;

extension type Window._(js.JSObject _) implements js.JSObject {
  // ignore: non_constant_identifier_names
  external CanvasKit get CanvasKitInstance;
}

extension type CanvasKit._(js.JSObject _) implements js.JSObject {
  static CanvasKit get instance => window.CanvasKitInstance;
}

void test_text() {
  print(CanvasKit.instance);
}
