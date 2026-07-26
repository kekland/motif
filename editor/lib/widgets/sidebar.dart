import 'package:flutter/widgets.dart';
import 'package:stack_multi_pane_container/stack_multi_pane_container.dart';

import 'properties_panel/properties_panel.dart';
import 'scene_tree/scene_tree_panel.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiPaneContainer(
      direction: .vertical,
      panels: [
        Panel(
          constraints: .pixels(384.0, .infinity),
          child: PropertiesPanel(),
        ),
        // Panel(
        //   constraints: .flex(1.0),
        //   child: SceneTreePanel(),
        // ),
      ],
    );
  }
}
