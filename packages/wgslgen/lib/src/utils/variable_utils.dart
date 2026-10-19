part of '../generator.dart';

extension VariableInfoExt on VariableInfo {
  String get dartName => toDartTopLevelName(name);
  String get dartMemberName => toDartMemberName(name);

  String getVisibility(EntryFunctions entries) {
    final vtx = entries.vertex.any((i) => i.resources.any((r) => r.group == group && r.binding == binding));
    final frag = entries.fragment.any((i) => i.resources.any((r) => r.group == group && r.binding == binding));
    final comp = entries.compute.any((i) => i.resources.any((r) => r.group == group && r.binding == binding));

    final values = [
      if (vtx) '.vertex',
      if (frag) '.fragment',
      if (comp) '.compute',
    ];

    if (values.length == 1) return values.first;
    if (values.isNotEmpty) return '.of([${values.join(', ')}])';
    return '.none';
  }

  String get rawResourceType => switch (resourceType) {
    .uniform || .storage => 'wgpu.BufferView',
    .texture || .storageTexture => 'wgpu.TextureView',
    .sampler => 'wgpu.Sampler',
    _ => throw UnimplementedError('Unknown resource type: $resourceType'),
  };

  String get typedResourceType => switch (resourceType) {
    .uniform => uniformBufferBase,
    .storage => storageBufferBase,
    _ => rawResourceType,
  };
}

extension BufferVariableInfoExt on VariableInfo {
  String get uniformBufferName => '${type.extensionName}UniformBuffer';
  String get uniformBufferViewName => '${uniformBufferName}View';
  String get uniformBufferBase => 'wgsl.UniformBuffer<${type.internalName}>';

  bool get storageBufferIsDynamic {
    if (isArray) return true;
    if (isStruct) {
      final struct = type.asStruct;
      return struct.members.isNotEmpty && struct.members.last.isArray;
    }
    return false;
  }

  String get storageBufferName => '${type.extensionName}StorageBuffer';
  String get storageBufferViewName => '${storageBufferName}View';
  String get storageBufferBase {
    if (storageBufferIsDynamic) {
      if (isArray) return 'wgsl.ArrayStorageBuffer<${type.asArray.format.internalName}>';
      return 'wgsl.ArrayStorageBuffer<${type.internalName}>';
    }
    return 'wgsl.StorageBuffer<${type.internalName}>';
  }
}
