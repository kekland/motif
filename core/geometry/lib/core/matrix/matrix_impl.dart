import 'dart:math' as math;

import 'package:geometry/gen/_import.dart';

extension MatrixImpl on Mat4 {
  double get determinant2 => this[0] * this[5] - this[1] * this[4];
  Mat4 inverted() => .copy(this)..invert();

  double get scaleX => math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
  double get scaleY => math.sqrt(this[4] * this[4] + this[5] * this[5] + this[6] * this[6]);
  double get scaleZ => math.sqrt(this[8] * this[8] + this[9] * this[9] + this[10] * this[10]);

  Mat4 withNormalizedScale() {
    final sx = scaleX, sy = scaleY, sz = scaleZ;
    final m = Mat4.copy(this);
    // dart format off
    if (sx > 0) { m[0] /= sx; m[1] /= sx; m[2] /= sx; }
    if (sy > 0) { m[4] /= sy; m[5] /= sy; m[6] /= sy; }
    if (sz > 0) { m[8] /= sz; m[9] /= sz; m[10] /= sz; }
    // dart format on
    return m;
  }

  Mat4 unmirrored(Size2 box) {
    if (determinant2 > 0) return this;

    final Mat4 flip;
    if (this[0] < 0) {
      flip = Mat4.identity()
        ..translate(box.width, 0.0)
        ..scale(-1, 1);
    } else {
      flip = Mat4.identity()
        ..translate(0.0, box.height)
        ..scale(1, -1);
    }

    return this * flip;
  }

  double get maxScaleOnAxis => math.max(math.max(scaleX, scaleY), scaleZ);
  double get maxScaleOnAxis2D => math.max(scaleX, scaleY);

  bool equals(Mat4 other, [double epsilon = 1e-6]) {
    for (var i = 0; i < 16; i++) {
      if ((this[i] - other[i]).abs() > epsilon) return false;
    }
    return true;
  }

  bool exactEquals(Mat4 other) {
    for (var i = 0; i < 16; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}
