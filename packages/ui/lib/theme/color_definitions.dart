import 'dart:ui';

import 'package:ui/slate.dart';

typedef AppSurfaceColors = ({
  SurfaceColor primary,
  SurfaceColor secondary,
  SurfaceColor tertiary,
  SurfaceColor canvas,
});

typedef AppDisplayColors = ({
  Color primary,
  Color secondary,
  Color tertiary,
});

typedef AppAccentColors = ({
  SurfaceColor primary,
  SurfaceColor secondary,
});

typedef AppDangerColors = ({
  SurfaceColor primary,
  SurfaceColor secondary,
});

typedef AppColors = ({
  AppSurfaceColors surface,
  AppDisplayColors display,
  AppAccentColors accent,
  AppDangerColors danger,
  Color divider,
  Color tint,
  Color normal,
  Color inverse,
  Color shadow,
});
