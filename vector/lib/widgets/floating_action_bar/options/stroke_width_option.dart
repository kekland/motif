part of '../floating_action_bar.dart';

class StrokeWidthDragActivity extends DragActivity {
  StrokeWidthDragActivity({
    required this.startWidth,
    required this.onWidthChanged,
  }) {
    currentWidth = startWidth;
  }

  final double startWidth;
  final ValueChanged<double> onWidthChanged;

  late double currentWidth;

  static const pixelsPerWidth = 4.0;

  @override
  void onUpdate(DragUpdateDetails details) {
    final delta = details.globalPosition.dx - startDetails.globalPosition.dx;
    final newValue = ((startWidth + delta / pixelsPerWidth).clamp(1.0, 100.0)).roundToDouble();

    if (newValue != currentWidth) {
      currentWidth = newValue;
      onWidthChanged(currentWidth);
      Haptics.click();
    }

    super.onUpdate(details);
  }
}

class StrokeWidthOption extends HookWidget {
  const StrokeWidthOption({super.key});

  @override
  Widget build(BuildContext context) {
    final (createWindow, hasWindow) = useCreateWindowEntry(context, StrokeWidthWindow.createEntry);

    final controller = VectorController.watch(context);
    useListenable(controller.strokeProperties);
    final strokeProperties = controller.strokeProperties;
    final width = strokeProperties.width;

    final activity = useState<StrokeWidthDragActivity?>(null);
    final hasActivity = activity.value != null;

    final widthFits = width < 32.0;
    final Widget child;

    if (widthFits) {
      child = Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          color: context.colors.surface.primary.foreground,
          shape: BoxShape.circle,
        ),
      );
    } else {
      child = Text(
        width.round().toString(),
        style: context.typography.caption1.tertiary.tabular,
      );
    }

    return GestureSurface(
      animationStyle: context.animations.effectFast,
      onTap: createWindow,
      onHorizontalDragStart: (d) {
        activity.value = StrokeWidthDragActivity(
          startWidth: width,
          onWidthChanged: (width) => controller.strokeProperties.width = width,
        );

        activity.value!.onStart(d);
      },
      onHorizontalDragUpdate: (d) => activity.value!.onUpdate(d),
      onHorizontalDragEnd: (d) {
        activity.value!.onEnd(d);
        activity.value = null;
      },
      onHorizontalDragCancel: () {
        activity.value?.onEnd(null);
        activity.value = null;
      },
      width: 40.0,
      height: 40.0,
      borderRadius: hasActivity || hasWindow ? .circular(20.0) : .circular(8.0),
      color: context.colors.surface.primary,
      child: Center(
        child: child,
      ),
    );
  }
}
