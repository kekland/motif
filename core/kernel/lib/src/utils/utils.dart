part of '../kernel.dart';

const _arenaListBaseSize = 8;

extension F64ListExt on Float64List {
  Float64List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64List(n)..setAll(0, this);
  }
}

extension Vec2ListExt on Vec2List {
  Vec2List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Vec2List(n)..setAll(0, this);
  }
}

extension F64x2ListExt on Float64x2List {
  Float64x2List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Float64x2List(n)..setAll(0, this);
  }
}

extension Mat4ListExt on Mat4List {
  Mat4List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Mat4List(n)..setAll(0, this);
  }
}

extension I32ListExt on Int32List {
  Int32List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Int32List(n)..setAll(0, this);
  }
}

extension U32ListExt on Uint32List {
  Uint32List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint32List(n)..setAll(0, this);
  }
}

extension U64ListExt on Uint64List {
  Uint64List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint64List(n)..setAll(0, this);
  }
}

extension U8ListExt on Uint8List {
  Uint8List grow(int atLeast) {
    var n = isEmpty ? _arenaListBaseSize : length;
    while (n < atLeast) n *= 2;
    return Uint8List(n)..setAll(0, this);
  }
}
