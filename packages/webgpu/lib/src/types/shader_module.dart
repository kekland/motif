part of 'types.dart';

abstract class ShaderModule {
  set label(String value);

  Future<CompilationInfo> get compilationInfo;
}
