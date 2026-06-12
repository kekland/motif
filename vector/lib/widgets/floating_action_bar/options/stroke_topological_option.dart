part of '../floating_action_bar.dart';

class StrokeTopologicalOption extends HookWidget {
  const StrokeTopologicalOption({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    useListenable(controller.strokeProperties);

    final strokeProperties = controller.strokeProperties;
    final topological = strokeProperties.topological;

    return GestureSurface(
      onTap: () => controller.strokeProperties.topological = !topological,
      animationStyle: context.animations.effectFast,
      width: 40.0,
      height: 40.0,
      borderRadius: topological ? .circular(20.0) : .circular(8.0),
      color: topological ? context.colors.accent.secondary : context.colors.surface.primary,
      child: Center(
        child: DefaultGestureReaction(
          animationStyle: context.animations.effectFast,
          states: {if (topological) .selected},
          child: Icons.topology(),
        ),
      ),
    );
  }
}
