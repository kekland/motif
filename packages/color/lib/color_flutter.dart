import 'dart:ui' as ui;
import 'package:css/color/color_flutter.dart';

import 'color_data.dart';
export 'color.dart';

extension ColorDataFlutter on ColorData {
  /// Converts this color data to a [ui.Color] in a given color space.
  ui.Color toUiColor({ui.ColorSpace colorSpace = .sRGB}) => cssColor.toUiColor(colorSpace: colorSpace);
}
