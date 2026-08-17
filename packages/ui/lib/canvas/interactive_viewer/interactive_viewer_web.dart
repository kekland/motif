import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class CanvasWebInterop {
  static JSFunction? _wheelListener;

  static void _preventScroll(web.Event event) {
    event.preventDefault();
  }

  static void lockBrowserGestures() {
    if (!kIsWeb || _wheelListener != null) return;

    _wheelListener = _preventScroll.toJS;
    web.window.addEventListener(
      'wheel',
      _wheelListener!,
      web.AddEventListenerOptions(passive: false),
    );
  }

  static void unlockBrowserGestures() {
    if (!kIsWeb || _wheelListener == null) return;
    web.window.removeEventListener('wheel', _wheelListener!);
    _wheelListener = null;
  }
}
