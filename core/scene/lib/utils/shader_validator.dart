import 'package:scene/scene.dart';
import 'package:state/state.dart';
import 'package:webgpu/webgpu.dart' as webgpu;

final class ShaderValidator with Disposable {
  ShaderValidator(this.scene) {
    _initFuture = _initialize();
  }

  final Scene scene;

  late Future<void> _initFuture;
  late final webgpu.Device device;

  Future<void> _initialize() async {
    final instance = webgpu.Instance.defaultInstance;
    final adapter = await instance.requestAdapter();
    device = await adapter.requestDevice(.new(label: 'shader-validator'));
  }

  Future<List<String>> validate(String shaderCode) async {
    await _initFuture;

    final shader = device.createShaderModule(.new(next: webgpu.ShaderSourceWGSL(code: shaderCode)));
    final compilationInfo = await shader.compilationInfo;
    return compilationInfo.messages.map((m) => m.message).toList();
  }

  @override
  void dispose() {
    device.destroy();
    super.dispose();
  }
}
