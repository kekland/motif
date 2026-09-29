import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/statement_widget.dart';

class ProgramPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final editor = context.editor;
    useListenable(editor.scene);

    final selection = editor.selection;
    useListenable(selection);

    final program = editor.program;

    return Scrollbar(
      controller: scrollController,
      child: CustomScrollView(
        controller: scrollController,
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
      ),
    );
  }
}
