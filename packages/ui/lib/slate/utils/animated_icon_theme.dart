part of '../slate.dart';

class _IconThemeDataTween extends Tween<IconThemeData> {
  _IconThemeDataTween({super.begin});

  @override
  IconThemeData lerp(double t) {
    return IconThemeData.lerp(begin, end, t);
  }
}

class AnimatedIconTheme extends ImplicitlyAnimatedWidget {
  const AnimatedIconTheme({
    super.key,
    required super.duration,
    super.curve,
    required this.data,
    required this.child,
  });

  final IconThemeData data;
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedIconTheme> createState() => _AnimatedIconThemeState();
}

class _AnimatedIconThemeState extends ImplicitlyAnimatedWidgetState<AnimatedIconTheme> {
  _IconThemeDataTween? _iconThemeData;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    final v = visitor(
      _iconThemeData,
      widget.data,
      (dynamic value) => _IconThemeDataTween(begin: value as IconThemeData),
    );

    _iconThemeData = v as _IconThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) => IconTheme(
        data: _iconThemeData!.evaluate(animation),
        child: child!,
      ),
    );
  }
}
