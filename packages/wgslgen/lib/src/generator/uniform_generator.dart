part of '../generator.dart';

List<String> generateUniform(VariableInfo info, {required List<String> variables}) {
  final lines = <String>[];

  final usage = '.of([.uniform, .copyDst])';
  final viewName = info.uniformBufferViewName;
  final bufferName = info.uniformBufferName;
  final bufferBase = info.uniformBufferBase;

  lines.add(_metaUniformBufferView(variables));
  lines.addAll(_generateStaticBufferView(info, viewName: viewName, usage: usage));
  lines.add('');
  lines.add(_metaUniformBuffer(variables));
  lines.addAll(_generateStaticBuffer(info, viewName: viewName, bufferName: bufferName, bufferBase: bufferBase));

  return lines;
}
