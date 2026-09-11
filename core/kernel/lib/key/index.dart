part of '../kernel.dart';

const int kNone = -1;

extension type const ElementIndex(int _i) implements Object {
  static const none = ElementIndex(kNone);
  static const zero = ElementIndex(0);
  bool get isNone => _i == kNone;
  bool get isNotNone => _i != kNone;

  int get i {
    assert(isNotNone);
    return _i;
  }
}

enum CellKind { frame, vertex, edge, face }

extension type const CellIndex.raw(int value) implements Object {
  CellIndex.from(int index, CellKind kind) : value = (index << 2) | kind.index;

  static const none = CellIndex.raw(kNone);
  bool get isNone => value == kNone;
  bool get isNotNone => value != kNone;

  int get i {
    assert(isNotNone);
    return value >> 2;
  }

  ElementIndex get index {
    assert(isNotNone);
    return .new(value >> 2);
  }

  CellKind get kind {
    assert(isNotNone);
    return .values[value & 3];
  }

  FrameIndex get asFrame {
    assert(kind == .frame);
    return .new(i);
  }

  VertexIndex get asVertex {
    assert(kind == .vertex);
    return .new(i);
  }

  EdgeIndex get asEdge {
    assert(kind == .edge);
    return .new(i);
  }

  FaceIndex get asFace {
    assert(kind == .face);
    return .new(i);
  }
}
