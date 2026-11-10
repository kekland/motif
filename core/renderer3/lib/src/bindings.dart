part of '../renderer.dart';

final class BindingsManager {
  new(this.renderer);
  final Renderer renderer;

  List<webgpu.BindGroupEntry>? _group0Entries;
  List<webgpu.BindGroupEntry>? _group1Entries;
  List<webgpu.BindGroupEntry>? _group2Entries;

  webgpu.BindGroup _createBindGroup(
    webgpu.BindGroupLayoutDescriptor layoutDescriptor,
    List<webgpu.BindGroupEntry> entries,
    String label,
  ) {
    final layout = renderer.device!.createBindGroupLayout(layoutDescriptor);
    final requiredEntries = layoutDescriptor.entries.map((e) => e.binding).toSet();
    final filteredEntries = entries.where((entry) => requiredEntries.contains(entry.binding)).toList();

    return renderer.device!.createBindGroup(
      .new(
        label: label,
        layout: layout,
        entries: filteredEntries,
      ),
    );
  }

  webgpu.BindGroup createBindGroup0(webgpu.BindGroupLayoutDescriptor layoutDescriptor) {
    return _createBindGroup(layoutDescriptor, _group0Entries!, 'bind-group-0');
  }

  webgpu.BindGroup createBindGroup1(webgpu.BindGroupLayoutDescriptor layoutDescriptor) {
    return _createBindGroup(layoutDescriptor, _group1Entries!, 'bind-group-1');
  }

  webgpu.BindGroup createBindGroup2(webgpu.BindGroupLayoutDescriptor layoutDescriptor) {
    return _createBindGroup(layoutDescriptor, _group2Entries!, 'bind-group-2');
  }

  void setup() {
    _group0Entries = gen_bindings.createBindGroup0Entries(
      world: renderer.uniforms.world.bufferView,
      storageOffsets: renderer.uniforms.storageOffsets.bufferView,
      storageCounts: renderer.uniforms.storageCounts.bufferView,
      storageCapacity: renderer.uniforms.storageCapacity.bufferView,
    );

    _group1Entries = gen_bindings.createBindGroup1Entries(
      topology: renderer.topology.buffer.bufferView,
      geometry: renderer.geometry.buffer.bufferView,
      style: renderer.style.buffer.bufferView,
      decoration: renderer.decoration.buffer.bufferView,
      draw: renderer.draw.buffer.bufferView,
      glyphGeometry: renderer.text.glyph.buffer.bufferView,
      glyphInstances: renderer.text.instanceBuffer.bufferView,
      textStyle: renderer.text.style.buffer.bufferView,
    );

    _group2Entries = gen_bindings.createBindGroup2Entries(
      segments: renderer.renderBuffers.segments.bufferView,
      segmentOffset: renderer.renderBuffers.segmentOffset.bufferView,
      renderGeometry: renderer.renderBuffers.renderGeometry.bufferView,
      renderGeometryOffset: renderer.renderBuffers.renderGeometryOffset.bufferView,
      renderIndirect: renderer.renderBuffers.indirectArgs.bufferView,
    );

    renderer.flattenStage.rebind();
    renderer.geometryStage.rebind();
    renderer.indirectStage.rebind();
    renderer.renderStage.rebind();
  }
}
