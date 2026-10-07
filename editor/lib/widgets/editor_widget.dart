import 'package:editor/imports.dart';
import 'package:editor/widgets/editor_canvas.dart';
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

class EditorWidget extends HookWidget {
  const new({
    super.key,
    required this.sync,
  });

  final EditorSync sync;

  @override
  Widget build(BuildContext context) {
    final state = useComputedValue(() => sync.state);
    final editor = useComputedValue(() => sync.editor);

    return switch (state) {
      .closed => Center(child: Text('Connection closed')),
      .errored => Center(child: Text('Error: ${sync.error}')),
      .connecting || .idle => Center(child: CircularProgressIndicator()),
      .connected => ConnectedEditorWidget(editor: editor!),
    };
  }
}

class ConnectedEditorWidget extends HookWidget {
  const ConnectedEditorWidget({super.key, required this.editor});

  final Editor editor;

  @override
  Widget build(BuildContext context) {
    final isLoaded = useExistingSignal(editor.isLoaded).value;
    if (!isLoaded) return const SizedBox.shrink();

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;

          return Provider.value(
            value: editor,
            child: PortalRoot(
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
                          child: EditorTabBar(height: 36.0),
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
            ),
          );
        },
      ),
    );
  }
}
