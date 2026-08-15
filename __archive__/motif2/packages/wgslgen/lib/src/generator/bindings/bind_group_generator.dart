part of '../../generator.dart';

List<String> generateBindGroup(int group, Map<int, VariableInfo> map) {
  final lines = <String>[];
  final sortedEntries = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

  // Raw constructor
  lines.add(_metaBindGroup(group));
  lines.add('wgpu.BindGroup createBindGroup${group}Raw(');
  lines.add('  wgpu.Device device, {');
  lines.add('  wgpu.BindGroupLayout? layout,');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartMemberName;
    final type = info.rawResourceType;
    lines.add('  required $type $varName,');
  }
  lines.add('  String? label,');
  lines.add('}) => device.createBindGroup(.new(');
  lines.add('  label: label ?? ${_wgpuLabel('bind group $group')},');
  lines.add('  layout: layout ?? createBindGroup${group}Layout(device),');
  lines.add('  entries: [');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartMemberName;
    lines.add('    .new(binding: ${info.binding}, ');
    if (info.resourceType == .uniform || info.resourceType == .storage) {
      lines.last += 'buffer: $varName.buffer, offset: $varName.offset, size: $varName.size';
    } else if (info.resourceType == .texture || info.resourceType == .storageTexture) {
      lines.last += 'textureView: $varName';
    } else if (info.resourceType == .sampler) {
      lines.last += 'sampler: $varName';
    } else {
      throw Exception('Unsupported resource type: ${info.resourceType}');
    }

    lines.last += '),';
  }
  lines.add('  ],');
  lines.add('));');
  lines.add('');

  // Typed constructor
  lines.add(_metaBindGroup(group));
  lines.add('wgpu.BindGroup createBindGroup$group(');
  lines.add('  wgpu.Device device, {');
  lines.add('  wgpu.BindGroupLayout? layout,');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartMemberName;
    final type = info.typedResourceType;
    lines.add('  required $type $varName,');
  }
  lines.add('  String? label,');
  lines.add('}) => createBindGroup${group}Raw(');
  lines.add('  device,');
  lines.add('  layout: layout,');
  lines.add('  label: label,');
  for (final MapEntry(key: _, value: info) in sortedEntries) {
    final varName = info.dartMemberName;
    if (info.resourceType == .uniform || info.resourceType == .storage) {
      lines.add('  $varName: $varName.bufferView,');
    } else {
      lines.add('  $varName: $varName,');
    }
  }
  lines.add(');');

  return lines;
}
