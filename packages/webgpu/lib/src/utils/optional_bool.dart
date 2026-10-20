import 'package:webgpu/webgpu.dart';

extension OptionalBoolValue on OptionalBool {
  bool? get asBoolean => switch (this) {
    .undefined => null,
    .true_ => true,
    .false_ => false,
    _ => throw ArgumentError(),
  };
}
