import 'package:stack_multi_pane_container/stack_multi_pane_container.dart';
import 'package:ui/ui.dart' hide Panel;

class EditorPageTemplate extends StatelessWidget {
  const EditorPageTemplate({
    super.key,
    required this.mainBar,
    required this.sideBar,
    required this.toolBar,
    required this.canvas,
  });

  final Widget? mainBar;
  final Widget? sideBar;
  final Widget? toolBar;
  final Widget? canvas;

  @override
  Widget build(BuildContext context) {
    return MultiPaneContainer(
      direction: Axis.horizontal,
      panels: [
        if (mainBar != null)
          Panel(
            constraints: .pixels(196.0, 384.0),
            child: mainBar!,
          ),
        Panel(
          constraints: .flex(1.0),
          child: Column(
            children: [
              if (canvas != null) Expanded(child: canvas!) else Spacer(),
              if (toolBar != null) ...[
                Divider(height: 1.0),
                SizedBox(height: 48.0, child: toolBar!),
              ],
            ],
          ),
        ),
        if (sideBar != null)
          Panel(
            constraints: .pixels(196.0, 384.0, initial: 296.0),
            child: sideBar!,
          ),
      ],
    );
  }
}
