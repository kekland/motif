part of 'slate.dart';

class Surface extends StatelessWidget {
  const Surface({
    super.key,
    this.animationStyle,
    this.width,
    this.height,
    this.padding,
    this.color,
    this.foregroundColor,
    this.shadows,
    this.gradient,
    this.clipBehavior,
    this.borderRadius,
    this.borderSide,
    this.shape,
    this.child,
  });

  final AnimationStyle? animationStyle;

  final double? width;
  final double? height;
  final EdgeInsets? padding;

  final Color? color;
  final Color? foregroundColor;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  final Clip? clipBehavior;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final ShapeBorder? shape;

  final Widget? child;

  ShapeBorder? _resolveShapeBorder(BuildContext context) {
    if (shape != null) {
      return shape;
    }

    if (borderSide == null && borderRadius == null) {
      return null;
    }

    final _borderRadius = (borderRadius ?? BorderRadius.zero);
    final _borderSide = borderSide ?? BorderSide.none;

    return RoundedRectangleBorderNoPadding(
      borderRadius: _borderRadius,
      side: _borderSide,
    );
  }

  SurfaceColor _resolveSurfaceColor(BuildContext context) {
    final inheritedTextStyle = DefaultTextStyle.of(context);

    final backgroundColor = color ?? Surface.colorOf(context).background;
    final surfaceColor = color is SurfaceColor ? (color as SurfaceColor) : null;

    Color foregroundColor;
    if (this.foregroundColor != null) {
      foregroundColor = this.foregroundColor!;
    } else if (surfaceColor != null) {
      foregroundColor = surfaceColor.foreground;
    } else {
      foregroundColor = inheritedTextStyle.style.color!;
    }

    return SurfaceColor(
      background: backgroundColor,
      foreground: foregroundColor,
      tint: surfaceColor?.tint ?? context.colors.tint,
      divider: surfaceColor?.divider ?? context.colors.divider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animationStyle = this.animationStyle ?? AnimationStyle.noAnimation;

    final surfaceColor = _resolveSurfaceColor(context);

    Widget child = this.child ?? const SizedBox.shrink();

    if (animationStyle.hasDuration) {
      child = AnimatedPadding(
        duration: animationStyle.duration!,
        curve: animationStyle.curve ?? Curves.linear,
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
    } else {
      child = Padding(padding: padding ?? EdgeInsets.zero, child: child);
    }

    child = DefaultForegroundStyle(
      animationStyle: animationStyle,
      color: surfaceColor.foreground,
      child: InheritedSurfaceColor(
        color: surfaceColor,
        child: child,
      ),
    );

    final shape = _resolveShapeBorder(context);

    final backgroundDecoration = ShapeDecoration(
      color: gradient != null ? null : color,
      shape: shape ?? const RoundedRectangleBorder(),
      shadows: shadows,
      gradient: gradient,
    );

    final foregroundDecoration = ShapeDecoration(
      shape: shape ?? const RoundedRectangleBorder(),
    );

    var clipBehavior = this.clipBehavior;
    clipBehavior ??= color != null || shape != null ? Clip.antiAlias : Clip.none;

    if (animationStyle.duration == Duration.zero) {
      return Container(
        width: width,
        height: height,
        decoration: backgroundDecoration,
        foregroundDecoration: foregroundDecoration,
        clipBehavior: clipBehavior,
        child: child,
      );
    }

    return AnimatedContainer(
      duration: animationStyle.duration!,
      curve: animationStyle.curve!,
      width: width,
      height: height,
      decoration: backgroundDecoration,
      foregroundDecoration: foregroundDecoration,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  static InheritedSurfaceColor? _surfaceColorOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedSurfaceColor>();
  }

  static SurfaceColor? maybeColorOf(BuildContext context) => _surfaceColorOf(context)?.color;
  static SurfaceColor colorOf(BuildContext context) => maybeColorOf(context)!;
}

class InheritedSurfaceColor extends InheritedWidget {
  const InheritedSurfaceColor({
    super.key,
    required this.color,
    required super.child,
  });

  final SurfaceColor? color;

  @override
  bool updateShouldNotify(covariant InheritedSurfaceColor oldWidget) {
    return color != oldWidget.color;
  }
}
