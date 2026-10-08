import 'package:editor/imports.dart';

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
        final key = option.key;

        _options[key] = option;
        _optionProps[key] = option.createProp(this);
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
  late final _optionProps = <String, Prop>{};

  O getOption<O extends ToolOption>(String key) => _options[key]! as O;

  T get<T>(String key) => _options[key]!.value as T;
  void set<T>(String key, T value) {
    _options[key] = _options[key]!.copyWith(value: value);
    _optionProps[key]!.sources.single.signal?.value = value;
  }

  Prop getProp(String key) => _optionProps[key]!;
}
