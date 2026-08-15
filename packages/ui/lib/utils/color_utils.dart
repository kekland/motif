import 'package:ui/ui.dart';

extension ColorUtils on Color {
  Color withScaledAlpha(double scale) {
    return withValues(alpha: (a * scale).clamp(0, 1));
  }
}
