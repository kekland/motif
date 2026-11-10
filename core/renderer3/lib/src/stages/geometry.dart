part of '../../renderer.dart';

final class GeometryStage {
  new(this.renderer);
  final Renderer renderer;
  BindingsManager get bindings => renderer.bindings;

  late webgpu.ComputePipeline _countPipeline;
  late webgpu.ComputePipeline _scanPipeline;
  late webgpu.ComputePipeline _generatePipeline;

  late webgpu.ComputePipeline _glyphCountPipeline;
  late webgpu.ComputePipeline _glyphGeneratePipeline;

  void setup() {
    final module = geometry.createShaderModule(renderer.device!);
    _countPipeline = geometry.createCountPipeline(renderer.device!, module: module);
    _scanPipeline = geometry.createScanPipeline(renderer.device!, module: module);
    _generatePipeline = geometry.createGeneratePipeline(renderer.device!, module: module);

    final glyphModule = glyph_geometry.createShaderModule(renderer.device!);
    _glyphCountPipeline = glyph_geometry.createCountPipeline(renderer.device!, module: glyphModule);
    _glyphGeneratePipeline = glyph_geometry.createGeneratePipeline(renderer.device!, module: glyphModule);
  }

  late webgpu.BindGroup _group0;
  late webgpu.BindGroup _group1;
  late webgpu.BindGroup _group2;

  late webgpu.BindGroup _glyphGroup0;
  late webgpu.BindGroup _glyphGroup1;
  late webgpu.BindGroup _glyphGroup2;

  void rebind() {
    _group0 = bindings.createBindGroup0(geometry.createBindGroup0LayoutDescriptor());
    _group1 = bindings.createBindGroup1(geometry.createBindGroup1LayoutDescriptor());
    _group2 = bindings.createBindGroup2(geometry.createBindGroup2LayoutDescriptor());

    _glyphGroup0 = bindings.createBindGroup0(glyph_geometry.createBindGroup0LayoutDescriptor());
    _glyphGroup1 = bindings.createBindGroup1(glyph_geometry.createBindGroup1LayoutDescriptor());
    _glyphGroup2 = bindings.createBindGroup2(glyph_geometry.createBindGroup2LayoutDescriptor());
  }

  void dispatch(webgpu.CommandEncoder encoder) {
    final drawCount = renderer.draw.order.count;

    {
      final pass = encoder.beginComputePass(.new(label: 'geometry/count'));
      pass.setPipeline(_countPipeline);
      geometry.bindCountPipeline(pass, group0: _group0, group1: _group1, group2: _group2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'geometry/glyph_count'));
      pass.setPipeline(_glyphCountPipeline);
      glyph_geometry.bindCountPipeline(pass, group0: _glyphGroup0, group1: _glyphGroup1, group2: _glyphGroup2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'geometry/scan'));
      pass.setPipeline(_scanPipeline);
      geometry.bindScanPipeline(pass, group0: _group0, group2: _group2);
      pass.dispatchWorkgroups(1);
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'geometry/generate'));
      pass.setPipeline(_generatePipeline);
      geometry.bindGeneratePipeline(pass, group0: _group0, group1: _group1, group2: _group2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }

    {
      final pass = encoder.beginComputePass(.new(label: 'geometry/glyph_generate'));
      pass.setPipeline(_glyphGeneratePipeline);
      glyph_geometry.bindGeneratePipeline(pass, group0: _glyphGroup0, group1: _glyphGroup1, group2: _glyphGroup2);
      pass.dispatchWorkgroups((drawCount / 64).ceil());
      pass.end();
    }
  }
}
