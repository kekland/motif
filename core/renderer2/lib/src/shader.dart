import 'package:renderer2/renderer.dart';
import 'package:renderer2/src/cache/decoration_cache.dart';
import 'package:shared/shared.dart';
import 'package:webgpu/webgpu.dart' as webgpu;

import 'shaders/render.g.dart' as render;

final class ShaderManager with ChangeNotifier {
  ShaderManager(this.renderer, this.onShaderModuleUpdated) {
    update(notify: false);
  }

  final SceneRenderer renderer;
  final void Function() onShaderModuleUpdated;
  DecorationCache get decorationCache => renderer.decorationCache;

  late webgpu.ShaderModule shaderModule;

  void update({bool notify = true}) {
    final code = render.source.split('\n');
    final userFragmentShaders = <String>[];
    final userFragmentShaderSelectors = <String>[];

    for (final entry in decorationCache.shaderCode.entries) {
      userFragmentShaders.add(entry.value);

      final hash = Mix64.hashInt(entry.key.hashCode);
      userFragmentShaderSelectors.add('case ${hash}u: { color = fragment_$hash(in); }');
    }

    code.insertAll(
      code.indexOf('// %MARK% USER FRAGMENT SHADER SLOT') + 1,
      userFragmentShaders,
    );

    code.insertAll(
      code.indexOf('// % MARK% USER FRAGMENT SHADER SELECTOR SLOT') + 1,
      userFragmentShaderSelectors,
    );

    // print(code.join('\n'));

    shaderModule = renderer.device!.createShaderModule(
      .new(
        label: 'render',
        next: webgpu.ShaderSourceWGSL(code: code.join('\n')),
      ),
    );

    if (notify) onShaderModuleUpdated();
  }
}
