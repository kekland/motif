part of '../generator.dart';

List<String> generateBindGroup(String name, int group, EntryFunctions entries, Map<int, VariableInfo> map) {
  final lines = <String>[];
  final sortedEntries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final values = map.values.toList();

  VariableInfo? getValue(String name) {
    final idx = values.indexWhere((v) => v.dartName == name);
    if (idx == -1) return null;
    return values[idx];
  }

  String getVisibility(VariableInfo info) {
    final vtx = entries.vertex.any((i) => i.resources.any((r) => r.group == info.group && r.binding == info.binding));
    final frag = entries.fragment.any(
      (i) => i.resources.any((r) => r.group == info.group && r.binding == info.binding),
    );
    final comp = entries.compute.any((i) => i.resources.any((r) => r.group == info.group && r.binding == info.binding));

    final values = [
      if (vtx) '.vertex',
      if (frag) '.fragment',
      if (comp) '.compute',
    ];

    if (values.length == 1) return values.first;
    if (values.isNotEmpty) return '.of([${values.join(', ')}])';
    return '.none';
  }

  // Bind group layout
  lines.add('@wgsl.BindGroupLayoutDescriptor($group)');
  lines.add('wgpu.BindGroupLayoutDescriptor get bindGroup${group}Layout => .new(');
  lines.add('  label: \'($name) bind group $group layout\',');
  lines.add('  entries: [');
  for (final MapEntry(key: binding, value: info) in sortedEntries) {
    final visibility = getVisibility(info);

    lines.add('    .new(');
    lines.add('      binding: $binding,');
    lines.add('      visibility: $visibility,');

    if (info.resourceType == .uniform || info.resourceType == .storage) {
      lines.addAll(_generateBufferLayout(info).indent(3));
    } else if (info.resourceType == .texture) {
      lines.addAll(_generateTextureLayout(info).indent(3));
    } else if (info.resourceType == .sampler) {
      final relations = info.relations.map((r) => getValue(r)).nonNulls.toList();
      lines.addAll(_generateSamplerLayout(info, relations).indent(3));
    } else if (info.resourceType == .storageTexture) {
      lines.addAll(_generateStorageTextureLayout(info).indent(3));
    } else {
      throw Exception('Unsupported resource type: ${info.resourceType}');
    }

    lines.add('    ),');
  }
  lines.add('  ],');
  lines.add(');');
  lines.add('');
  lines.add('@wgsl.BindGroupLayout($group)');
  lines.add('wgpu.BindGroupLayout createBindGroup${group}Layout(wgpu.Device device) => device.createBindGroupLayout(bindGroup${group}Layout);');
  lines.add('');

  // Bind group (raw)
  lines.add('@wgsl.BindGroup($group)');
  lines.add('wgpu.BindGroup createBindGroup${group}Raw(');
  lines.add('  wgpu.Device device,');
  lines.add('  wgpu.BindGroupLayout layout, {');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartName;
    final type = switch (info.resourceType) {
      .uniform || .storage => 'wgpu.BufferView',
      .texture || .storageTexture => 'wgpu.TextureView',
      .sampler => 'wgpu.Sampler',
      _ => throw Exception('Unsupported resource type: ${info.resourceType}'),
    };

    lines.add('  required $type $varName,');
  }
  lines.add('  String? label,');
  lines.add('}) => device.createBindGroup(.new(');
  lines.add('  label: label ?? \'($name) bind group $group\',');
  lines.add('  layout: layout,');
  lines.add('  entries: [');
  for (final MapEntry(key: binding, value: info) in sortedEntries) {
    final varName = info.dartName;

    lines.add('    .new(');
    lines.add('      binding: $binding,');
    if (info.resourceType == .uniform || info.resourceType == .storage) {
      lines.add('      buffer: $varName.buffer,');
      lines.add('      offset: $varName.offset,');
      lines.add('      size: $varName.size,');
    } else if (info.resourceType == .texture || info.resourceType == .storageTexture) {
      lines.add('      textureView: $varName,');
    } else if (info.resourceType == .sampler) {
      lines.add('      sampler: $varName,');
    } else {
      throw Exception('Unsupported resource type: ${info.resourceType}');
    }

    lines.add('    ),');
  }
  lines.add('  ],');
  lines.add('));');
  lines.add('');

  // Bind group (typed)
  lines.add('@wgsl.BindGroup($group)');
  lines.add('wgpu.BindGroup createBindGroup$group(');
  lines.add('  wgpu.Device device,');
  lines.add('  wgpu.BindGroupLayout layout, {');

  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartName;
    final type = switch (info.resourceType) {
      .uniform || .storage => '${info.type.dartName}Buffer',
      .texture || .storageTexture => 'wgpu.TextureView',
      .sampler => 'wgpu.Sampler',
      _ => throw Exception('Unsupported resource type: ${info.resourceType}'),
    };

    lines.add('  required $type $varName,');
  }
  lines.add('}) => createBindGroup${group}Raw(');
  lines.add('  device,');
  lines.add('  layout,');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartName;
    if (info.resourceType == .uniform || info.resourceType == .storage) {
      lines.add('  $varName: $varName.bufferView,');
    } else {
      lines.add('  $varName: $varName,');
    }
  }
  lines.add(');');

  return lines;
}

List<String> _generateBufferLayout(VariableInfo info) {
  final isReadonly = info.access == 'read';
  final bufferType = info.resourceType == .uniform ? 'uniform' : (isReadonly ? 'readOnlyStorage' : 'storage');

  final minSize = info.isArray ? info.stride : info.size;

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
