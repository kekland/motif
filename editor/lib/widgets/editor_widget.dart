import 'package:editor/imports.dart';
import 'package:editor/widgets/actions.dart';
import 'package:editor/widgets/canvas.dart';
import 'package:editor/widgets/program_panel/program_panel.dart';
import 'package:editor/widgets/sidebar.dart';
import 'package:editor/widgets/tab_bar.dart';
import 'package:editor/widgets/toolbar.dart';

class EditorWidget extends StatelessWidget {
  const EditorWidget({super.key, required this.editor});

  final Editor editor;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: editor,
      child: EditorActions(
        child: EditorShortcuts(
          child: ToolShortcuts(
            controller: editor.tool,
            child: Panels(
              direction: .horizontal,
              panels: [
                Panel(
                  constraints: .pixels(48.0, 48.0),
                  child: EditorToolbar(),
                ),
                Panel(
                  constraints: .pixels(0.0, 384.0, initial: 200.0),
                  child: ProgramPanel(),
                ),
                Panel(
                  constraints: .flex(1.0),
                  child: Panels(
                    direction: .vertical,
                    panels: [
                      Panel(
                        constraints: .flex(1.0),
                        child: EditorCanvas(),
                      ),
                      Panel(
                        constraints: .pixels(0.0, 196.0),
                        child: Container(),
                      ),
                      Panel(
                        constraints: .pixels(36.0, 36.0),
                        child: EditorTabBar(),
                      ),
                    ],
                  ),
                ),

                Panel(
                  constraints: .pixels(196.0, 384.0, initial: 296.0),
                  child: EditorSidebar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
