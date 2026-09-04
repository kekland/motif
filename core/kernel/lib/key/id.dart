part of '../kernel.dart';

extension type const CellId._(int _v) implements Object {
  CellId.make({required int namespace, required int tag, int sub = 0}) : _v = _pack(namespace, tag, sub);

  static int _pack(int namespace, int tag, int sub) {
    assert(namespace >= 0 && namespace < (1 << 32));
    assert(tag >= 0 && tag < (1 << 16));
    assert(sub >= 0 && sub < (1 << 12));
    return (namespace << 28) | (tag << 12) | sub;
  }

  int get namespace => _v >>> 28;
  int get tag => (_v >>> 12) & 0xFFFF;
  int get sub => (_v & 0xFFF);

  CellId derive(int sub) {
    assert(sub >= 0 && sub < (1 << 12));
    return ._(_v & ~0xFFF | sub);
  }
}

extension type const CellRef<H extends CellHandle>._(int _v) implements Object {
  CellRef.make(CellId id, CellKind kind) : _v = (id._v << 2) | kind.index;
  CellRef.raw({required int namespace, required int tag, int sub = 0, required CellKind kind})
    : this.make(.make(namespace: namespace, tag: tag, sub: sub), kind);

  static FrameRef frame(CellId id) => .make(id, .frame);
  static VertexRef vertex(CellId id) => .make(id, .vertex);
  static EdgeRef edge(CellId id) => .make(id, .edge);
  static FaceRef face(CellId id) => .make(id, .face);

  CellId get id => ._(_v >>> 2);
  CellKind get kind => .values[_v & 3];
  int get namespace => id.namespace;
  int get tag => id.tag;
  int get sub => id.sub;

  FrameRef get asFrame {
    assert(kind == .frame);
    return ._(_v);
  }

  VertexRef get asVertex {
    assert(kind == .vertex);
    return ._(_v);
  }

  EdgeRef get asEdge {
    assert(kind == .edge);
    return ._(_v);
  }

  FaceRef get asFace {
    assert(kind == .face);
    return ._(_v);
  }
}

typedef FrameRef = CellRef<FrameHandle>;
typedef VertexRef = CellRef<VertexHandle>;
typedef EdgeRef = CellRef<EdgeHandle>;
typedef FaceRef = CellRef<FaceHandle>;
