part of '../../renderer.dart';

final class IndirectStage {
  new(this.renderer);
  final Renderer renderer;
  BindingsManager get bindings => renderer.bindings;

  late webgpu.ComputePipeline _indirectPipeline;

  void setup() {
    final module = indirect.createShaderModule(renderer.device!);
    _indirectPipeline = indirect.createComputePipeline(renderer.device!, module: module);
  }

  late webgpu.BindGroup _group0;
  late webgpu.BindGroup _group2;

  void rebind() {
    _group0 = bindings.createBindGroup0(indirect.createBindGroup0LayoutDescriptor());
    _group2 = bindings.createBindGroup2(indirect.createBindGroup2LayoutDescriptor());
  }

  void dispatch(webgpu.CommandEncoder encoder) {
    final drawCount = renderer.draw.order.count;
    final pass = encoder.beginComputePass(.new(label: 'indirect'));
    pass.setPipeline(_indirectPipeline);
    indirect.bindPipeline(pass, group0: _group0, group2: _group2);
    pass.dispatchWorkgroups((drawCount / 64).ceil());
    pass.end();
  }
}
