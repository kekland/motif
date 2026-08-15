import 'dart:ui' as ui;

import 'package:vector_math/vector_math_64.dart';

extension Vector2Utils on Vector2 {
  ui.Offset get offset => ui.Offset(x, y);
}
