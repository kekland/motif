import 'package:editor/imports.dart';
import 'package:editor/widgets/canvas.dart';
import 'package:editor/widgets/scene_panel.dart';
import 'package:editor/widgets/sidebar.dart';
import 'package:editor/widgets/tabs/tab.dart';
import 'package:editor/widgets/tabs/tab_bar.dart';
import 'package:editor/widgets/toolbar.dart';

enum EditorPanel {
  toolbar,
  scene,
  main,
  canvas,
  tab,
  tabBar,
  sidebar,
  selection,
  tool,
}

class EditorWidget extends StatelessWidget {
  const EditorWidget({super.key, required this.editor});

  final Editor editor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;

        return Provider.value(
          value: editor,
          child: Panels<EditorPanel>(
            key: editor.panelsRootKey,
            direction: .horizontal,
            panels: [
              Panel(
                key: EditorPanel.toolbar,
                constraints: .pixels(48.0, 48.0),
                child: EditorToolbar(),
              ),
              Panel(
                key: EditorPanel.scene,
                constraints: .pixels(0.0, 384.0, initial: 200.0),
                child: ScenePanel(),
              ),
              Panel(
                key: EditorPanel.main,
                constraints: .flex(1.0),
                child: Panels(
                  direction: .vertical,
                  panels: [
                    Panel(
                      key: EditorPanel.canvas,
                      constraints: .flex(1.0),
                      child: EditorCanvas(),
                    ),
                    Panel(
                      key: EditorPanel.tab,
                      constraints: .pixels(0.0, maxHeight * 0.35),
                      child: EditorTabWidget(),
                    ),
                    Panel(
                      key: EditorPanel.tabBar,
                      constraints: .pixels(36.0, 36.0),
                      child: EditorTabBar(),
                    ),
                  ],
                ),
              ),

              Panel(
                key: EditorPanel.sidebar,
                constraints: .pixels(196.0, 384.0, initial: 296.0),
                child: EditorSidebar(),
              ),
            ],
          ),
        );
      },
    );
  }
}
