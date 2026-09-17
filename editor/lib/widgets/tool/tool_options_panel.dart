import 'package:editor/imports.dart';

class ToolOptionsPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final toolController = useListenable(context.editor.tool);
    final tool = toolController.activeTool!;
    final options = tool.options.map((o) => o.key).toList();

    return Surface(
      child: Column(
        children: [
          Header(
            leading: tool.buildIcon(context),
            title: Text(tool.resolveName(context)),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, i) => Divider(),
              itemBuilder: (context, i) {
                final key = options[i];
                final optionSignal = toolController.getOptionSignal(key);
                final option = toolController.getOption(key);

                return option.build(
                  context,
                  optionSignal,
                  (v) => toolController.setOption(key, option.copyWith(value: v)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
