import 'package:vector/imports.dart';
import 'package:stack_ffi/stack_ffi.dart';
import 'package:vector/widgets/floating_action_bar/windows/stroke_options_window.dart';
import 'package:vector/widgets/floating_action_bar/windows/stroke_width_window.dart';

part 'options/stroke_options_button.dart';
part 'options/stroke_width_option.dart';
part 'options/stroke_topological_option.dart';


class FloatingActionBarPositioned extends StatelessWidget {
  const FloatingActionBarPositioned({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      // right: 16.0,
      // child: Center(
      //   heightFactor: 1.0,
      //   child: child,
      // ),
      child: child,
    );
  }
}

class FloatingActionBar extends HookWidget {
  const FloatingActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VectorController.watch(context);
    final tools = useComputedValue(() => controller.tool.toolset);
    final activeTool = useComputedValue(() => controller.tool.activeTool);

    useListenable(controller.strokeProperties);
    final strokeProperties = controller.strokeProperties;

    return Surface(
      height: 56.0,
      borderRadius: .circular(12.0),
      color: context.colors.surface.secondary,
      shadows: context.shadows.window,
      child: Row(
        children: [
          const SizedBox(width: 8.0),
          Icons.dragHandle(color: context.colors.display.tertiary),
          const SizedBox(width: 4.0),
          ColorPicker(
            size: 40.0,
            value: () => strokeProperties.color,
            onChanged: (c) => controller.strokeProperties.color = c,
          ),
          const SizedBox(width: 8.0),
          StrokeWidthOption(),
          const SizedBox(width: 8.0),
          StrokeTopologicalOption(),
          const SizedBox(width: 8.0),
          StrokeOptionsButton(),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
