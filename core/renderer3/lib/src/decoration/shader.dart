part of '../../renderer.dart';

final class GeneratedShaderCode({
  required final int key,
  required final String functionName,
  required final String code,
});

final class ShaderDecorationManager with ChangeNotifier, ChangeNotifierDisposable {
  new(this.renderer);

  final Renderer renderer;
  final _logger = Logger('ShaderDecorationManager');

  int? resolve(String id, ShaderBlueprint blueprint, {CellRef? ref}) {
    final code = _cache.get(id, blueprint, updateToken: ref);
    return code?.key;
  }

  Iterable<GeneratedShaderCode> get values => _cache.values;

  late final _cache = $disposable(
    LruAsyncCache<String, ShaderBlueprint, GeneratedShaderCode>(
      _validate,
      onResolve: (token) {
        renderer.updater._onStyleUpdate(token as CellRef);
        renderer.renderShader.setup();
      },
      label: 'shader',
    ),
  );

  Future<GeneratedShaderCode?> _validate(String id, ShaderBlueprint blueprint) async {
    final fnName = id.replaceAll('-', '_');
    final code = blueprint.toWgsl(fnName).join('\n');

    final validationCode = [
      'struct VtxOut {',
      '  @location(0) world_position: vec2f,',
      '  @location(1) local_position: vec2f,',
      '};',
      code,
    ];

    final validation = await renderer.scene.shaderValidator.validate(validationCode.join('\n'));
    if (validation.isEmpty) {
      return .new(
        key: Mix64.hashInt(id.hashCode),
        functionName: fnName,
        code: code,
      );
    }

    _logger.warning('$id: validation failed: ${validation.join('\n ')}');
    return null;
  }
}
