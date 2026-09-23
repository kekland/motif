import 'package:app/imports.dart';

class EditorPage extends HookWidget {
  const new({
    super.key,
    required this.id,
    required this.program,
  });

  final String id;
  final Program program;

  @override
  Widget build(BuildContext context) {
    final scene = useDisposable(() => Scene(id: id, program: program));
    final editor = useDisposable(() => Editor(scene: scene));

    useListenerEffect(scene, () {
      final program = scene.program;
      storage.saveScene(id, program);
    });

    return Scaffold(child: EditorWidget(editor: editor));
  }
}
