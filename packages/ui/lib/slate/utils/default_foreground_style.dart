part of '../slate.dart';

class DefaultForegroundStyle extends StatelessWidget {
  const DefaultForegroundStyle({
    super.key,
    this.animationStyle,
    this.style,
    this.color,
    this.maxLines,
    this.overflow,
    this.iconSize,
    this.iconFill,
    this.iconGrade,
    this.iconWeight,
    this.textAlign,
    required this.child,
  });

  final AnimationStyle? animationStyle;
  final TextStyle? style;
  final Color? color;
  final double? iconSize;
  final double? iconFill;
  final double? iconWeight;
  final double? iconGrade;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animationStyle = this.animationStyle ?? AnimationStyle.noAnimation;
    final color = this.color ?? style?.color;

    if (animationStyle.duration != null && animationStyle.duration! > .zero) {
      return DefaultTextStyle.merge(
        style: TextStyle(color: color).merge(style),
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow ?? TextOverflow.visible,
        child: IconTheme.merge(
          data: IconThemeData(
            color: color,
            fill: iconFill,
            weight: iconWeight,
            grade: iconGrade,
            size: iconSize,
          ),
          child: child,
        ),
      );
    }

    final parentTextStyle = DefaultTextStyle.of(context);
    final parentIconTheme = IconTheme.of(context);

    return AnimatedDefaultTextStyle(
      duration: animationStyle.duration!,
      curve: animationStyle.curve ?? Curves.linear,
      maxLines: maxLines ?? parentTextStyle.maxLines,
      overflow: overflow ?? parentTextStyle.overflow,
      textAlign: textAlign ?? parentTextStyle.textAlign,
      style: parentTextStyle.style.merge(TextStyle(color: color).merge(style)),
      child: AnimatedIconTheme(
        duration: animationStyle.duration!,
        curve: animationStyle.curve ?? Curves.linear,
        data: IconThemeData(
          color: color ?? parentIconTheme.color,
          fill: iconFill ?? parentIconTheme.fill,
          size: iconSize ?? parentIconTheme.size,
          opticalSize: parentIconTheme.opticalSize,
          weight: iconWeight ?? parentIconTheme.weight,
          grade: iconGrade ?? parentIconTheme.grade,
          opacity: parentIconTheme.opacity,
          applyTextScaling: parentIconTheme.applyTextScaling,
          shadows: parentIconTheme.shadows,
        ),
        child: child,
      ),
    );
  }
}
