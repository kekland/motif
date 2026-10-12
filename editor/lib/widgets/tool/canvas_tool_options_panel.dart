import 'package:editor/imports.dart';

class const CanvasToolOptionsWindow({
  super.key,
  required final Editor editor,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final txn = useMemoized(() => PropTransaction());
    final toolController = editor.tool;
    final options = [
      toolController.getOption<SnapToPixelToolOption>(SnapToPixelToolOption.entry.key),
    ];

    return WindowScaffold(
      title: Text('Options'),
      child: SizedBox(
        width: 360.0,
        child: Provider<PropTransaction>.value(
          value: txn,
          child: PropListBuilder(
            props: options.map((o) => toolController.getProp(o.key)).toList(),
          ),
        ),
      ),
    );
  }
}
