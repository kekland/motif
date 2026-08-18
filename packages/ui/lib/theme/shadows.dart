import 'package:ui/ui.dart';

typedef AppShadows = ({
  List<BoxShadow> small,
  List<BoxShadow> window,
});

AppShadows generateShadows(AppColors colors) {
  return (
    small: [
      .new(
        color: colors.shadow.withScaledAlpha(0.1),
        offset: .new(0.0, 2.0),
        blurRadius: 4.0,
      ),
    ],
    window: [
      .new(
        color: colors.shadow.withScaledAlpha(0.1),
        offset: .new(0.0, 8.0),
        blurRadius: 12.0,
      ),
    ],
  );
}
