import 'package:editor/imports.dart';

class RootSelectionPanel extends HookWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scene = context.editor.scene.signal;
    final settings = useComputed(() => scene().program.settings);

    void update(ProgramSettings Function(ProgramSettings) transform) {
      scene().editTransient(
        (txn) => txn.applyChange(
          .settings(
            before: settings(),
            after: transform(settings()),
          ),
        ),
      );
    }

    return Column(
      children: [
        Header(
          padding: .zero,
          title: TextInputField(
            value: useComputed(() => settings().title),
            onChanged: (v) => update((s) => s.copyWith(title: v)),
            options: .new(
              isFlat: true,
              leading: Icons.document(),
              borderRadius: .zero,
              padding: .symmetric(horizontal: 8.0),
            ),
          ),
        ),
        Divider(),
        PropsSectionWidget(
          title: Text('Background color'),
          child: Padding(
            padding: PropWidget.padding,
            child: ColorInputField(
              value: useComputed(() => settings().backgroundColor.partial),
              onChanged: (v) => update((s) => s.copyWith(backgroundColor: v.apply(s.backgroundColor))),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
