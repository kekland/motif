part of '../generator.dart';

List<String> generateShaderModule(String name, String source) {
  final lines = <String>[];

  lines.add('@wgsl.ShaderSource(\'$name\')');
  lines.add('const String _shaderSource = r\'\'\'');
  lines.add(source);
  lines.add('\'\'\';');
  lines.add('');

  lines.add('@wgsl.ShaderModule(\'$name\')');
  lines.add('wgpu.ShaderModule createShaderModule(wgpu.Device device) => device.createShaderModule(.new(');
  lines.add('  label: \'($name) module\',');
  lines.add('  next: const wgpu.ShaderSourceWGSL(code: _shaderSource),');
  lines.add('));');

  return lines;
}
