import 'types.dart';

part 'generator/bind_group_generator.dart';
part 'generator/compute_state_generator.dart';
part 'generator/compute_pipeline_generator.dart';
part 'generator/fragment_state_generator.dart';
part 'generator/overrides_generator.dart';
part 'generator/pipeline_layout_generator.dart';
part 'generator/render_pipeline_generator.dart';
part 'generator/shader_module_generator.dart';
part 'generator/storage_generator.dart';
part 'generator/struct_generator.dart';
part 'generator/type_generator.dart';
part 'generator/uniform_generator.dart';
part 'generator/vertex_layout_generator.dart';
part 'generator/vertex_state_generator.dart';

List<String> generate(String name, String source, WgslReflectionInfo info) {
  final lines = <String>[];

  lines.addAll(generateOverrides(info.overrides));
  lines.add('');

  for (final struct in info.structs) {
    // Detect vertex input/output structs. For now just check if all members have location attributes.
    final members = struct.members;
    final allHaveLocation =
        members.isNotEmpty &&
        members.every((m) => m.attributes.any((a) => a.name == 'location' || a.name == 'builtin'));

    if (allHaveLocation) {
      // ignore: avoid_print
      print(
        'Skipping struct ${struct.name}: detected as vertex input/output struct (all members have @location or @builtin attributes)',
      );
      continue;
    }

    lines.addAll(generateStruct(struct));
    lines.add('');
  }

  final groups = <int, Map<int, VariableInfo>>{};
  void _checkGroup(VariableInfo info) {
    groups[info.group] ??= {};
    final group = groups[info.group]!;
    if (group.containsKey(info.binding)) {
      throw Exception('Duplicate binding: @group(${info.group}), @binding(${info.binding})');
    }

    group[info.binding] = info;
  }

  for (final uniform in info.uniforms) {
    _checkGroup(uniform);
    lines.addAll(generateUniform(name, uniform));
    lines.add('');
  }

  for (final storage in info.storages) {
    _checkGroup(storage);

    if (storage.resourceType == .storage) {
      lines.addAll(generateStorage(name, storage));
      lines.add('');
    }
  }

  for (final sampler in info.samplers) {
    _checkGroup(sampler);
  }

  for (final texture in info.textures) {
    _checkGroup(texture);
  }

  for (final group in groups.entries) {
    final groupId = group.key;
    final bindings = group.value;

    lines.addAll(generateBindGroup(name, groupId, info.entry, bindings));
    lines.add('');
  }

  if (groups.isNotEmpty) {
    lines.addAll(generatePipelineLayout(name, groups));
    lines.add('');
  }

  for (final vertexEntry in info.entry.vertex) {
    final layout = generateVertexBufferLayout(name, vertexEntry);
    if (layout != null) {
      lines.addAll(layout);
      lines.add('');
    }
  }

  for (final computeEntry in info.entry.compute) {
    lines.addAll(generateComputeState(computeEntry));
    lines.add('');
  }

  for (final vertexEntry in info.entry.vertex) {
    lines.addAll(generateVertexState(vertexEntry));
    lines.add('');
  }

  for (final fragmentEntry in info.entry.fragment) {
    lines.addAll(generateFragmentState(fragmentEntry));
    lines.add('');
  }

  for (final computeEntry in info.entry.compute) {
    lines.addAll(generateComputePipeline(name, computeEntry));
    lines.add('');
  }

  for (final vertexEntry in info.entry.vertex) {
    for (final fragmentEntry in info.entry.fragment) {
      lines.addAll(generateRenderPipeline(name, vertexEntry, fragmentEntry));
      lines.add('');
    }
  }

  lines.addAll(generateShaderModule(name, source));

  return lines;
}
