part of '../../slate.dart';

Widget gestureSurfaceTintEffect(BuildContext context, GestureSurface surface) {
  return GestureRegion.fromSurface(
    surface: surface,
    detectorBuilder: defaultGestureRegionDetectorBuilder,
    builder: (context, regionState) {
      final state = {...regionState, ...surface.state};

      return surface.buildSurface(
        context,
        state: state,
        padding: .zero,
        child: _TintEffectAnimator(
          state: state,
          child: Padding(
            padding: surface.padding ?? .zero,
            child: surface.resolveChild(context, state),
          ),
        ),
      );
    },
  );
}

class _TintEffectAnimator extends StatefulWidget {
  const _TintEffectAnimator({
    required this.state,
    required this.child,
  });

  final Set<WidgetState> state;
  final Widget child;

  @override
  State<_TintEffectAnimator> createState() => _TintEffectAnimatorState();
}

class _TintEffectAnimatorState extends State<_TintEffectAnimator> {
  Set<WidgetState> get state => widget.state;

  @override
  Widget build(BuildContext context) {
    final color = Surface.colorOf(context);
    final isSelected = state.contains(WidgetState.selected);
    final isFocused = state.contains(WidgetState.focused);
    final isHovered = state.contains(WidgetState.hovered);
    final isPressed = state.contains(WidgetState.pressed);

    final double tint;
    if (isPressed) {
      tint = 0.08;
    } else if (isHovered) {
      tint = 0.04;
    } else if (isSelected || isFocused) {
      tint = 0.02;
    } else {
      tint = 0.0;
    }

    return ColoredBox(
      color: color.tint?.withScaledAlpha(tint) ?? Colors.transparent,
      child: DefaultForegroundStyle(
        animationStyle: .noAnimation,
        iconWeight: 200.0,
        iconFill: isSelected || isFocused ? 1.0 : 0.0,
        iconGrade: isPressed || isHovered || isSelected || isFocused ? 0.0 : 0.0,
        color: isPressed ? context.colors.accent.primary : null,
        child: widget.child,
      ),
    );
  }
}
