part of 'types.dart';

abstract class RenderPipeline {
  set label(String value);

  BindGroupLayout getBindGroupLayout(int index);
}
