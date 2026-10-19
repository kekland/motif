part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _ShaderModuleImpl on _ShaderModuleBase {
  Future<CompilationInfo> get compilationInfo => _getCompilationInfoImpl();
  CompilationInfo get compilationInfoSync => _getCompilationInfoSyncImpl();

  set label(String label) => _setLabelImpl(label);
}
