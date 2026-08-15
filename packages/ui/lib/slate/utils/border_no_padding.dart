part of '../slate.dart';

mixin _BorderNoPadding on OutlinedBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
}

class RoundedRectangleBorderNoPadding extends RoundedRectangleBorder with _BorderNoPadding {
  RoundedRectangleBorderNoPadding({BorderSide side = BorderSide.none, super.borderRadius})
      : super(side: side.copyWith(strokeAlign: BorderSide.strokeAlignInside, width: side.width));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundedRectangleBorderNoPadding) {
      return RoundedRectangleBorderNoPadding(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }

    if (a is RoundedSuperellipseBorderNoPadding) {
      return RoundedSuperellipseBorderNoPadding(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundedRectangleBorderNoPadding) {
      return RoundedRectangleBorderNoPadding(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }

    if (b is RoundedSuperellipseBorderNoPadding) {
      return RoundedSuperellipseBorderNoPadding(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }

    return super.lerpTo(b, t);
  }
}

class RoundedSuperellipseBorderNoPadding extends RoundedSuperellipseBorder with _BorderNoPadding {
  RoundedSuperellipseBorderNoPadding({
    BorderSide side = BorderSide.none,
    super.borderRadius,
  }) : super(side: side.copyWith(strokeAlign: BorderSide.strokeAlignInside, width: side.width));

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is RoundedSuperellipseBorderNoPadding) {
      return RoundedSuperellipseBorderNoPadding(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }

    if (a is RoundedRectangleBorderNoPadding) {
      return RoundedRectangleBorderNoPadding(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
      );
    }

    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is RoundedSuperellipseBorderNoPadding) {
      return RoundedSuperellipseBorderNoPadding(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }

    if (b is RoundedRectangleBorderNoPadding) {
      return RoundedRectangleBorderNoPadding(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
      );
    }

    return super.lerpTo(b, t);
  }
}
