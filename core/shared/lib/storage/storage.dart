import 'dart:typed_data';

import 'package:geometry/geometry_32.dart' as geom32;
import 'package:geometry/geometry_64.dart' as geom64;

const storageBaseSize = 8;

extension F64ListExt on Float64List {
  Float64List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64List(n)..setAll(0, this);
  }
}

extension Vec2List32Ext on geom32.Vec2List {
  geom32.Vec2List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return geom32.Vec2List(n)..buffer.setAll(0, buffer);
  }
}

extension Mat4List32Ext on geom32.Mat4List {
  geom32.Mat4List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return geom32.Mat4List(n)..buffer.setAll(0, buffer);
  }
}

extension Vec2List64Ext on geom64.Vec2List {
  geom64.Vec2List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return geom64.Vec2List(n)..buffer.setAll(0, buffer);
  }
}

extension Mat4List64Ext on geom64.Mat4List {
  geom64.Mat4List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return geom64.Mat4List(n)..buffer.setAll(0, buffer);
  }
}

extension F64x2ListExt on Float64x2List {
  Float64x2List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64x2List(n)..setAll(0, this);
  }
}

extension I32ListExt on Int32List {
  Int32List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return Int32List(n)..setAll(0, this);
  }
}

extension U32ListExt on Uint32List {
  Uint32List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint32List(n)..setAll(0, this);
  }
}

extension U8ListExt on Uint8List {
  Uint8List grow(int atLeast) {
    var n = isEmpty ? storageBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint8List(n)..setAll(0, this);
  }
}
