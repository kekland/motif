import 'package:editor/imports.dart';

class EditorWidget extends HookWidget {
  const EditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final editor = useDisposable(() => Editor());

    return ChangeNotifierProvider.value(
      value: editor,
      child: EditorActions(
        child: EditorPageTemplate(
          mainBar: EditorToolbar(),
          mainBarConstraints: .pixels(48.0, 48.0),
          sideBar: Sidebar(),
          toolBar: null,
          canvas: EditorShortcuts(child: EditorCanvas()),
        ),
      ),
    );
  }
}
