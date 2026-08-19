import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import 'package:native/src/modules/shared/mouse_cursor.dart';

abstract class FfiMouseCursor extends FfiMouseCursorBase {
  FfiMouseCursor({super.hotSpot});

  @override
  MouseCursorSession createSession(int device) => _WebMouseCursorSession(this, device);
}

class _WebMouseCursorSession extends FfiMouseCursorSession {
  _WebMouseCursorSession(super.cursor, super.device);

  @override
  Future<void> activate() async {
    final result = await cursor.nativeObjectMemoizer.runOnce(() async {
      final reprs = await resolvedReprs;
      if (reprs.isEmpty) return null;

      final logicalSize = await size;
      final dpr = web.window.devicePixelRatio;

      var bestIndex = 0, minDiff = double.infinity, bestScale = 1.0;
      for (var i = 0; i < reprs.length; i++) {
        final size = reprs[i].$2;
        final scale = size.width / logicalSize.width;
        final diff = (scale - dpr).abs();
        if (diff < minDiff) {
          minDiff = diff;
          bestIndex = i;
          bestScale = scale;
        }
      }

      final blob = web.Blob(
        [reprs[bestIndex].$1.toJS].toJS,
        .new(type: 'image/png'),
      );

      return (web.URL.createObjectURL(blob), bestScale);
    });

    if (result != null) {
      final (url, scale) = result as (String, double);

      final size = await this.size;
      final hotSpot = this.hotSpot ?? size.center(.zero);
      final hx = hotSpot.dx.round();
      final hy = hotSpot.dy.round();
      if (disposed) return;

      final standardStyle = 'image-set(url("$url") ${scale}x) $hx $hy, auto';
      final webkitStyle = '-webkit-image-set(url("$url") ${scale}x) $hx $hy, auto';
      final fallbackStyle = 'url("$url") $hx $hy, auto';

      var targetElement = web.document.body;
      if (targetElement == null) return;

      targetElement.style.cursor = standardStyle;

      if (targetElement.style.cursor == '') {
        targetElement.style.cursor = webkitStyle;
      }

      if (targetElement.style.cursor == '') {
        targetElement.style.cursor = fallbackStyle;
      }
    }
  }
}
