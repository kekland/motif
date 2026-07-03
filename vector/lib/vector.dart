import 'package:vector/widgets/properties_panel.dart';

import 'imports.dart';

class VectorEditorPage extends HookWidget {
  const VectorEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useDisposable(() => VectorController());

    return Provider<VectorController>.value(
      value: controller,
      child: EditorPageTemplate(
        mainBarConstraints: .pixels(48.0, 48.0),
        sideBarConstraints: .ratio(0.25, 0.5),
        mainBar: VectorToolbar(),
        toolBar: null,
        sideBar: PropertiesPanel(),
        // toolBar: VectorToolbar(),
        canvas: VectorCanvas(),
      ),
    );
  }
}
