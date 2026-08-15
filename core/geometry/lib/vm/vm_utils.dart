import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

extension Mat4VM on Mat4 {
  vm.Matrix4 asVM() {
    final storage = Float64x2List.fromList(this.storage);
    return .fromBuffer(storage.buffer, 0);
  }
}
