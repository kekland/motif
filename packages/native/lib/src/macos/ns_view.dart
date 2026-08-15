import 'package:ffi/ffi.dart';
import 'package:flutter/widgets.dart';

import 'package:native/macos.dart' as macos;

extension NSViewUtils on macos.NSView {
  void setFrameRect(Rect rect) {
    withZoneArena(() {
      Rect _rect = rect;
      if (superview != null) {
        final superviewSize = superview!.frame.size;
        _rect = Rect.fromLTWH(
          rect.left,
          superviewSize.height - rect.top - rect.height,
          rect.width,
          rect.height,
        );
      }

      frame = macos.Structs.CGRect(
        _rect.left,
        _rect.top,
        _rect.width,
        _rect.height,
      );
    });
  }
}
