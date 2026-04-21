import 'package:commander/commander.dart';
import 'package:design/imports.dart';
import 'package:flutter/services.dart';
import 'package:design/widgets/editor/canvas.dart';
import 'package:design/widgets/editor/nodes_panel.dart';
import 'package:design/widgets/editor/properties_panel.dart';
import 'package:design/widgets/editor/toolbar.dart';
import 'package:text/text.dart';

class DesignEditorPage extends HookWidget {
  const DesignEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => DesignController());

    ttt();

    return Scaffold(
      child: Provider.value(
        value: controller,
        child: Actions(
          dispatcher: LoggingActionDispatcher(logger: Logger('design.actions')),
          actions: {
            SelectNodeIntent: SelectNodeAction(),
            ClearSelectionIntent: ClearSelectionAction(),
            DeleteSelectionIntent: DeleteSelectionAction(),
            MoveSelectionIntent: MoveSelectionAction(),
          },
          child: EditorPageTemplate(
            mainBar: NodesPanel(),
            sideBar: PropertiesPanel(),
            toolBar: DesignToolbar(),
            canvas: CommanderRoot(
              child: Shortcuts(
                shortcuts: {
                  SingleActivator(LogicalKeyboardKey.delete): intents.deleteSelection(),
                  SingleActivator(LogicalKeyboardKey.backspace): intents.deleteSelection(),

                  // Shifting
                  SingleActivator(LogicalKeyboardKey.arrowUp): intents.moveSelection(Offset(0, -1)),
                  SingleActivator(LogicalKeyboardKey.arrowDown): intents.moveSelection(Offset(0, 1)),
                  SingleActivator(LogicalKeyboardKey.arrowLeft): intents.moveSelection(Offset(-1, 0)),
                  SingleActivator(LogicalKeyboardKey.arrowRight): intents.moveSelection(Offset(1, 0)),

                  // Shifting (with Shift held)
                  SingleActivator(LogicalKeyboardKey.arrowUp, shift: true): intents.moveSelection(Offset(0, -10)),
                  SingleActivator(LogicalKeyboardKey.arrowDown, shift: true): intents.moveSelection(Offset(0, 10)),
                  SingleActivator(LogicalKeyboardKey.arrowLeft, shift: true): intents.moveSelection(Offset(-10, 0)),
                  SingleActivator(LogicalKeyboardKey.arrowRight, shift: true): intents.moveSelection(Offset(10, 0)),
                },
                child: DesignCanvas(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
