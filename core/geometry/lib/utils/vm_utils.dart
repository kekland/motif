import 'dart:math' as math;
import 'dart:typed_data';

import 'package:geometry/geometry_32.dart' as geom32;
import 'package:vector_math/vector_math.dart' as vm32;

import 'package:geometry/geometry_64.dart' as geom64;
import 'package:vector_math/vector_math_64.dart' as vm64;

extension Mat4ToVMUtils64 on geom64.Mat4 {
  vm64.Matrix4 asVM() {
    final storage = Float64x2List.fromList(this.storage);
    return vm64.Matrix4.fromBuffer(storage.buffer, 0);
  }
}

extension Matrix4Utils64 on vm64.Matrix4 {
  double getMaxScaleOnAxis2D() {
    final scaleXSq = this[0] * this[0] + this[1] * this[1];
    final scaleYSq = this[4] * this[4] + this[5] * this[5];
    return math.sqrt(math.max(scaleXSq, scaleYSq));
  }
}

extension Mat4ToVMUtils32 on geom32.Mat4 {
  vm32.Matrix4 asVM() => vm32.Matrix4.fromBuffer(storage.buffer, 0);
}

extension Matrix4Utils32 on vm32.Matrix4 {
  double getMaxScaleOnAxis2D() {
    final scaleXSq = this[0] * this[0] + this[1] * this[1];
    final scaleYSq = this[4] * this[4] + this[5] * this[5];
    return math.sqrt(math.max(scaleXSq, scaleYSq));
  }
}
