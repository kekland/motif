part of '../../generator.dart';

List<String> generateBindGroupLayout(int group, EntryFunctions entries, Map<int, VariableInfo> map) {
  final lines = <String>[];
  final sortedEntries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final values = map.values.toList();

  VariableInfo? getVariable(String name) {
    final idx = values.indexWhere((v) => v.dartName == name);
    if (idx == -1) return null;
    return values[idx];
  }

  lines.add(_metaBindGroupLayoutDescriptor(group));
  lines.add('wgpu.BindGroupLayoutDescriptor get bindGroup${group}LayoutDescriptor => .new(');
  lines.add('  label: ${_wgpuLabel('bind group $group layout')},');
  lines.add('  entries: [');
  for (final MapEntry(key: binding, value: info) in sortedEntries) {
    final visibility = info.getVisibility(entries);
    final relations = info.relations.map(getVariable).nonNulls.toList();

    final l = <String>[];
    l.add('.new(');
    l.add('  binding: $binding,');
    l.add('  visibility: $visibility,');
    l.addAll(_generateLayout(info, relations).indent());
    l.add('),');

    lines.addAll(l.indent(2));
  }
  lines.add('  ],');
  lines.add(');');
  lines.add('');
  lines.add(_metaBindGroupLayout(group));
  lines.add('wgpu.BindGroupLayout createBindGroup${group}Layout(wgpu.Device device) {');
  lines.add('  return device.createBindGroupLayout(bindGroup${group}LayoutDescriptor);');
  lines.add('}');

  return lines;
}

List<String> _generateLayout(VariableInfo info, List<VariableInfo> relations) {
  if (info.resourceType == .uniform || info.resourceType == .storage) return _generateBufferLayout(info);
  if (info.resourceType == .texture) return _generateTextureLayout(info);
  if (info.resourceType == .storageTexture) return _generateStorageTextureLayout(info);
  if (info.resourceType == .sampler) return _generateSamplerLayout(info, relations);
  throw Exception('Unsupported resource type: ${info.resourceType}');
}

List<String> _generateBufferLayout(VariableInfo info) {
  final isReadonly = info.access == 'read';
  final bufferType = info.resourceType == .uniform ? 'uniform' : (isReadonly ? 'readOnlyStorage' : 'storage');

  final int minSize;
  if (info.isArray) {
    minSize = info.stride;
  } else if (info.isStruct) {
    final members = info.type.asStruct.members;
    final isDynamic = info.storageBufferIsDynamic;
    if (isDynamic) {
      minSize = info.size + members.last.type.asArray.stride;
    } else {
      minSize = info.size;
    }
  } else {
    minSize = info.size;
  }

  return [
    'buffer: .new(',
    '  type: .$bufferType,',
    '  minBindingSize: $minSize,',
    '  hasDynamicOffset: false,',
    '),',
  ];
}

List<String> _generateTextureLayout(VariableInfo info) {
  final name = info.type.name;
  var dimension = 'twoD';
  if (name.contains('1d')) dimension = 'oneD';
  if (name.contains('3d')) dimension = 'threeD';
  if (name.contains('cube')) dimension = 'cube';
  if (name.contains('array')) dimension += 'Array';

  var sampleType = 'float';
  if (info.format?.name == 'u32') sampleType = 'uint';
  if (info.format?.name == 'i32') sampleType = 'sint';
  if (info.format?.name == 'unfilterable-float') sampleType = 'unfilterableFloat';
  if (name.startsWith('texture_depth')) sampleType = 'depth';

  final isMultisampled = name.contains('multisampled');

  return [
    'texture: .new(',
    '  sampleType: .$sampleType,',
    '  multisampled: $isMultisampled,',
    '  viewDimension: .$dimension,',
    '),',
  ];
}

List<String> _generateSamplerLayout(VariableInfo info, List<VariableInfo> relations) {
  final isComparison = info.type.name == 'sampler_comparison';

  final isNonFiltering = relations.any((r) => r.format?.name.contains('unfilterable') == true);
  final type = isComparison ? 'comparison' : (isNonFiltering ? 'nonFiltering' : 'filtering');

  return [
    'sampler: .new(type: .$type),',
  ];
}

List<String> _generateStorageTextureLayout(VariableInfo info) {
  final name = info.type.name;
  var dimension = 'twoD';
  if (name.contains('1d')) dimension = 'oneD';
  if (name.contains('3d')) dimension = 'threeD';
  if (name.contains('array')) dimension += 'Array';

  final access = switch (info.access) {
    'read' => 'readOnly',
    'write' => 'writeOnly',
    _ => 'readWrite',
  };

  final format = _parseTexelFormat(info.format!.name);

  return [
    'storageTexture: .new(',
    '  access: .$access,',
    '  format: .$format,',
    '  viewDimension: .$dimension,',
    '),',
  ];
}

final _texelFormatMapping = {
  'rgba8unorm': 'RGBA8Unorm',
  'rgba8snorm': 'RGBA8Snorm',
  'rgba8uint': 'RGBA8Uint',
  'rgba8sint': 'RGBA8Sint',
  'rgba16unorm': 'RGBA16Unorm',
  'rgba16snorm': 'RGBA16Snorm',
  'rgba16uint': 'RGBA16Uint',
  'rgba16sint': 'RGBA16Sint',
  'rgba16float': 'RGBA16Float',
  'rg8unorm': 'RG8Unorm',
  'rg8snorm': 'RG8Snorm',
  'rg8uint': 'RG8Uint',
  'rg8sint': 'RG8Sint',
  'rg16unorm': 'RG16Unorm',
  'rg16snorm': 'RG16Snorm',
  'rg16uint': 'RG16Uint',
  'rg16sint': 'RG16Sint',
  'rg16float': 'RG16Float',
  'r32uint': 'R32Uint',
  'r32sint': 'R32Sint',
  'r32float': 'R32Float',
  'rg32uint': 'RG32Uint',
  'rg32sint': 'RG32Sint',
  'rg32float': 'RG32Float',
  'rgba32uint': 'RGBA32Uint',
  'rgba32sint': 'RGBA32Sint',
  'rgba32float': 'RGBA32Float',
  'bgra8unorm': 'BGRA8Unorm',
  'r8unorm': 'R8Unorm',
  'r8snorm': 'R8Snorm',
  'r8uint': 'R8Uint',
  'r16unorm': 'R16Unorm',
  'r16snorm': 'R16Snorm',
  'r16uint': 'R16Uint',
  'r16sint': 'R16Sint',
  'r16float': 'R16Float',
  'rgb10a2unorm': 'RGB10A2Unorm',
  'rgb10a2uint': 'RGB10A2Uint',
  'rg11b10float': 'RG11B10Float',
};

String _parseTexelFormat(String name) {
  final format = _texelFormatMapping[name];
  if (format == null) throw Exception('Unsupported texel format: $name');
  return format;
}
