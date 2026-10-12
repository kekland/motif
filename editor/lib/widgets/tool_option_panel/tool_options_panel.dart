import 'package:editor/imports.dart';

class const ToolOptionsPanel({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final toolController = editor.tool;
    final tool = useComputedValue(() => toolController.activeTool);
    final options = tool?.options ?? [];
    final txn = useMemoized(() => PropTransaction());

    return Column(
      children: [
        Header(
          leading: tool?.buildIcon(context),
          title: Text('Options'),
        ),
        Divider(),
        Provider<PropTransaction>.value(
          value: txn,
          child: PropListBuilder(
            props: options.map((o) => toolController.getProp(o.key)).toList(),
          ),
        ),
        Divider(),
      ],
    );
  }
}
