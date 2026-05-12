part of '../src.dart';
// ignore_for_file: unused_element

class ShaderModule extends _ShaderModule {
  ShaderModule._(super.ptr) : super._();
  ShaderModule._borrowed(super.ptr) : super._borrowed();

  Future<CompilationInfo> get compilationInfo => _shaderModuleGetCompilationInfo(this);
  void setLabel(String label) => _shaderModuleSetLabel(this, label);
}
