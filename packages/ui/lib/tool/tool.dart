import 'package:ui/ui.dart';

export 'tool_shortcuts.dart';
export 'tool_options.dart';

abstract class Tool {
  const Tool();

  String get key;
  SingleActivator? get shortcut => null;

  List<ToolOption> get options => [];

  String resolveName(BuildContext context);
  Widget buildIcon(BuildContext context);
  Widget buildViewportOverlay(
    BuildContext context,
    OverlayChildLayoutInfo info,
    covariant Tool tool,
  ) => const SizedBox.expand();
}

class ToolController with ChangeNotifier, ChangeNotifierDisposable {
  ToolController({List<Tool>? initialToolset}) {
    if (initialToolset != null) toolset = initialToolset;

    for (final tool in toolset) {
      for (final option in tool.options) {
        _options[option.key] = option;
        _optionValueSignals[option.key] = option.createSignal();
      }
    }

    notifyListenersOn([_toolset, _activeTool, _options]);
    _activeTool.value = toolset.firstOrNull;
  }

  late final _toolset = $listSignal<Tool>([]);
  List<Tool> get toolset => _toolset.value;
  set toolset(List<Tool> value) => _toolset.value = value;

  late final _activeTool = $signal<Tool?>(null);
  Tool? get activeTool => _activeTool.value;
  set activeTool(Tool? value) => _activeTool.value = value;

  late final _options = $mapSignal<String, ToolOption>({});
  late final _optionValueSignals = <String, Signal>{};

  ToolOption getOption(String key) => _options[key]!;
  ReadonlySignal getOptionSignal(String key) => _optionValueSignals[key]!;
  void setOption(String key, ToolOption value) {
    _options[key] = value;
    _optionValueSignals[key]!.value = value.value;
  }
}
