import 'package:flutter/widgets.dart';
import 'package:stack/stack.dart';

abstract class Tool {
  const Tool();

  String get key;
  Widget buildIcon(BuildContext context);
  Widget buildViewportOverlay(BuildContext context, OverlayChildLayoutInfo info) => const SizedBox.expand();
}

class ToolController with ChangeNotifier, ChangeNotifierDisposable {
  ToolController({List<Tool>? initialToolset}) {
    if (initialToolset != null) toolset = initialToolset;
    notifyListenersOn([_toolset, _activeTool]);

    _activeTool.value = toolset.firstOrNull;
  }

  late final _toolset = $listSignal<Tool>([]);
  List<Tool> get toolset => _toolset.value;
  set toolset(List<Tool> value) => _toolset.value = value;

  late final _activeTool = $signal<Tool?>(null);
  Tool? get activeTool => _activeTool.value;
  set activeTool(Tool? value) => _activeTool.value = value;
}
