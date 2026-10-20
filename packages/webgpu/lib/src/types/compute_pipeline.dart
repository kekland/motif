part of 'types.dart';

abstract class ComputePipeline {
  set label(String value);

  BindGroupLayout getBindGroupLayout(int index);
}
