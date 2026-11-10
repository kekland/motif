import 'dart:ui' as ui;

import 'package:shared/shared.dart';
import 'package:skia/skia.dart' as skia;

extension ToUiPath on skia.Path {
  ui.Path toUiPath() {
    final path = ui.Path();

    var _point = 0;
    double p() => points[_point++];
    for (var i = 0; i < verbs.length; i++) {
      final _ = switch (verbs[i]) {
        .move => path.moveTo(p(), p()),
        .line => path.lineTo(p(), p()),
        .quad => path.quadraticBezierTo(p(), p(), p(), p()),
        .cubic => path.cubicTo(p(), p(), p(), p(), p(), p()),
        .close => path.close(),
        .conic => path.conicTo(p(), p(), p(), p(), p()),
        _ => unreachable(),
      };
    }

    return path;
  }
}
