import 'package:ui/ui.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get tabular => copyWith(fontFeatures: [const .tabularFigures()]);
}
