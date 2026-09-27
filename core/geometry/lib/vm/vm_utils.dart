import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

extension Mat4VM on Mat4 {
  vm.Matrix4 asVM() {
    final storage = Float64x2List.fromList(this.storage);
    return .fromBuffer(storage.buffer, 0);
  }
}

extension Matrix4Utils on vm.Matrix4 {
  double getMaxScaleOnAxis2D() {
    final scaleXSq = this[0] * this[0] + this[1] * this[1];
    final scaleYSq = this[4] * this[4] + this[5] * this[5];
    return math.sqrt(math.max(scaleXSq, scaleYSq));
  }
}
