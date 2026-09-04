part of '../kernel.dart';

extension type const CellHandle._(int _v) implements Object {
  CellHandle.make(CellKind kind, ElementIndex index, int gen) : _v = _pack(kind.index, index.i, gen);

  static int _pack(int kind, int index, int gen) => (gen << 32) | (index << 2) | kind;

  int get _index => (_v & 0xFFFFFFFF) >> 2;
  ElementIndex get index => .new(_index);
  CellIndex get cell => ._(_v & 0xFFFFFFFF);
  int get gen => (_v >> 32);
  CellKind get kind => .values[_v & 3];

  FrameHandle get asFrame {
    assert(kind == .frame);
    return ._(this);
  }

  VertexHandle get asVertex {
    assert(kind == .vertex);
    return ._(this);
  }

  EdgeHandle get asEdge {
    assert(kind == .edge);
    return ._(this);
  }

  FaceHandle get asFace {
    assert(kind == .face);
    return ._(this);
  }

  CellId id(Bundle bundle) => bundle.id(this);
  CellRef ref(Bundle bundle) => bundle.ref(this);
}
