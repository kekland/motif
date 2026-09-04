part of '../kernel.dart';

const int kNone = -1;

extension type const ElementIndex(int _i) implements Object {
  static const none = ElementIndex(kNone);

  int get i {
    assert(isNotNone);
    return _i;
  }

  bool get isNotNone => !isNone;
  bool get isNone => _i == kNone;
}

extension type const CellIndex._(int v) implements Object {
  CellIndex.from(int index, CellKind kind) : v = (index << 2) | kind.index;

  static const none = CellIndex._(kNone);

  int get i {
    assert(isNotNone);
    return v >> 2;
  }

  ElementIndex get index {
    assert(isNotNone);
    return .new(v >> 2);
  }

  CellKind get kind {
    assert(isNotNone);
    return CellKind.values[v & 3];
  }

  bool get isNotNone => !isNone;
  bool get isNone => v == kNone;

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
