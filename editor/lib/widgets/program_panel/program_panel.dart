import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/statement_widget.dart';

class ProgramPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    useListenable(editor.scene);

    final selection = editor.selection;
    useListenable(selection);

    final program = editor.program;

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => StatementWidget(
              statement: program[i],
              isSelected: selection.statements.contains(program[i].id),
            ),
            childCount: program.length,
          ),
        ),
      ],
    );
  }
}
