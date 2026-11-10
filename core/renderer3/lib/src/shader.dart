part of '../renderer.dart';

final class RenderShaderManager with ChangeNotifier, ChangeNotifierDisposable {
  new(this.renderer);
  final Renderer renderer;

  webgpu.ShaderModule? _module;
  webgpu.ShaderModule get module => _module!;

  void setup() => _build();

  void _build() {
    _module?.dispose();

    final code = render.source.split('\n');
    final userFragmentShaderFunctions = <String>[];
    final userFragmentShaderSwitches = <String>[];

    for (final entry in renderer.decoration.shader.values) {
      userFragmentShaderFunctions.add(entry.code);
      userFragmentShaderSwitches.add('case ${entry.key}u: { color = ${entry.functionName}(in); }');
    }

    code.insertAll(
      code.indexOf('// %MARK% USER FRAGMENT SHADER FUNCTION SLOT') + 1,
      userFragmentShaderFunctions,
    );

    code.insertAll(
      code.indexOf('        // %MARK% USER FRAGMENT SHADER SWITCH SLOT') + 1,
      userFragmentShaderSwitches,
    );
    
    _module = renderer.device!.createShaderModule(
      .new(
        label: 'render-main',
        next: webgpu.ShaderSourceWGSL(code: code.join('\n')),
      ),
    );

    renderer.renderStage.setup();
    notifyListeners();
  }
}
