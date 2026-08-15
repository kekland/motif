import 'package:editor/imports.dart';
import 'package:editor/widgets/program_panel/statement_widget.dart';

class ProgramPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    useListenable(editor.scene);

    final program = editor.program;

    return CustomScrollView(
      slivers: [
        PinnedHeaderSliver(
          child: Header(
            leading: Icons.stacks(),
            title: Text('Program'),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => StatementWidget(statement: program[i]),
            childCount: program.length,
          ),
        ),
      ],
    );
  }
}
