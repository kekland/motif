import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class CanvasWebInterop {
  static JSFunction? _wheelListener;
  static JSFunction? _contextMenuListener;

  static void _prevent(web.Event event) {
    event.preventDefault();
  }

  static void lockBrowserGestures() {
    if (!kIsWeb || _wheelListener != null) return;

    _wheelListener = _prevent.toJS;
    web.window.addEventListener(
      'wheel',
      _wheelListener!,
      web.AddEventListenerOptions(passive: false),
    );

    _contextMenuListener = _prevent.toJS;
    web.window.addEventListener(
      'contextmenu',
      _contextMenuListener!,
    );
  }

  static void unlockBrowserGestures() {
    if (!kIsWeb || _wheelListener == null) return;
    web.window.removeEventListener('wheel', _wheelListener!);
    web.window.removeEventListener('contextmenu', _contextMenuListener!);
    _wheelListener = null;
    _contextMenuListener = null;
  }
}
