part of '../../renderer.dart';

final class FlattenStage {
  new(this.renderer);
  final Renderer renderer;
  BindingsManager get bindings => renderer.bindings;

  late webgpu.ComputePipeline _countPipeline;
  late webgpu.ComputePipeline _scanPipeline;
  late webgpu.ComputePipeline _generatePipeline;

  void setup() {
    final module = flatten.createShaderModule(renderer.device!);
    _countPipeline = flatten.createCountPipeline(renderer.device!, module: module);
    _scanPipeline = flatten.createScanPipeline(renderer.device!, module: module);
    _generatePipeline = flatten.createGeneratePipeline(renderer.device!, module: module);
  }

  late webgpu.BindGroup _group0;
  late webgpu.BindGroup _group1;
  late webgpu.BindGroup _group2;

  void rebind() {
    _group0 = bindings.createBindGroup0(flatten.createBindGroup0LayoutDescriptor());
    _group1 = bindings.createBindGroup1(flatten.createBindGroup1LayoutDescriptor());
    _group2 = bindings.createBindGroup2(flatten.createBindGroup2LayoutDescriptor());
  }

  void dispatch(webgpu.CommandEncoder encoder) {
    final drawCount = renderer.draw.order.edgeCount;

    {
      final pass = encoder.beginComputePass(.new(label: 'flatten/count'));
      pass.setPipeline(_countPipeline);
      flatten.bindCountPipeline(pass, group0: _group0, group1: _group1, group2: _group2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'flatten/scan'));
      pass.setPipeline(_scanPipeline);
      flatten.bindScanPipeline(pass, group0: _group0, group2: _group2);
      pass.dispatchWorkgroups(1);
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'flatten/generate'));
      pass.setPipeline(_generatePipeline);
      flatten.bindGeneratePipeline(pass, group0: _group0, group1: _group1, group2: _group2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }
  }
}
