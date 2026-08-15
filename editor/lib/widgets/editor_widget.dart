import 'package:editor/imports.dart';
import 'package:editor/widgets/actions.dart';
import 'package:editor/widgets/canvas.dart';
import 'package:editor/widgets/sidebar.dart';
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
          child: Panels(
            direction: .horizontal,
            panels: [
              Panel(
                constraints: .pixels(48.0, 48.0),
                child: EditorToolbar(),
              ),
              Panel(
                constraints: .flex(1.0),
                child: ClipRect(
                  child: EditorCanvas(),
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
    );
  }
}
