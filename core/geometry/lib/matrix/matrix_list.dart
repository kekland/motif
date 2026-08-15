import 'dart:typed_data';

import 'package:geometry/geometry.dart';

extension type const Mat4List._(Float64x2List storage) implements Float64x2List {
  Mat4List(int length) : this._(Float64x2List(length * _stride));
  Mat4List.fromList(List<Float64x2> list) : this._(.fromList(list));
  Mat4List.view(Float64x2List storage) : this._(storage);
  Mat4List.viewFloat64(Float64List storage) : this._(storage.buffer.asFloat64x2List());

  static const _stride = 8;

  int get length => storage.length ~/ _stride;

  Mat4 operator [](int index) => .view(.sublistView(storage, index * _stride, (index + 1) * _stride));
  void operator []=(int index, Mat4 value) => storage.setRange(index * _stride, (index + 1) * _stride, value.storage);
}
