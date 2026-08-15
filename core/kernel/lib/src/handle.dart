part of 'kernel.dart';

int _pack(int kind, int index, int gen) => (gen << 32) | (index << 2) | kind;

extension type const CellHandle._(int raw) implements Object {
  CellHandle.make(CellKind kind, ElementIndex index, int generation) : raw = _pack(kind.index, index.i, generation);

  bool get isNotNone => !isNone;
  bool get isNone => raw == kNone;

  CellKind get kind {
    assert(isNotNone);
    return CellKind.values[raw & 0x3];
  }

  int get _index => (raw & 0xFFFFFFFF) >> 2;

  ElementIndex get index {
    assert(isNotNone);
    return ElementIndex(_index);
  }

  int get gen {
    assert(isNotNone);
    return raw >>> 32;
  }

  CellIndex get cell {
    assert(isNotNone);
    return ._(raw & 0xFFFFFFFF);
  }

  FrameHandle get asFrame {
    assert(kind == .frame);
    return FrameHandle._(this);
  }

  VertexHandle get asVertex {
    assert(kind == .vertex);
    return VertexHandle._(this);
  }

  EdgeHandle get asEdge {
    assert(kind == .edge);
    return EdgeHandle._(this);
  }

  FaceHandle get asFace {
    assert(kind == .face);
    return FaceHandle._(this);
  }

  String name(TopologyBundle bundle) => '${bundle.cellId(this)}';
  CellId asId(TopologyBundle bundle) => bundle.cellId(this);
  CellKey asKey(TopologyBundle bundle) => bundle.key(this);
  CellView asView(TopologyBundle bundle) => CellView._((bundle, this));
}

extension type const FrameHandle._(CellHandle h) implements CellHandle {
  FrameHandle.make(FrameIndex index, int gen) : h = .make(.frame, index, gen);

  FrameIndex get index {
    assert(h.kind == .frame);
    return FrameIndex(_index);
  }

  String name(TopologyBundle bundle) => '${bundle.frameId(this)}';
  CellId asId(TopologyBundle bundle) => bundle.frameId(this);
  CellKey asKey(TopologyBundle bundle) => bundle.frameKey(this);
  FrameView asView(TopologyBundle bundle) => ._((bundle, this));
}

extension type const VertexHandle._(CellHandle h) implements CellHandle {
  VertexHandle.make(VertexIndex index, int gen) : h = .make(.vertex, index, gen);

  VertexIndex get index {
    assert(h.kind == .vertex);
    return VertexIndex(_index);
  }

  String name(TopologyBundle bundle) => '${bundle.vertexId(this)}';
  CellId asId(TopologyBundle bundle) => bundle.vertexId(this);
  CellKey asKey(TopologyBundle bundle) => bundle.vertexKey(this);
  VertexView asView(TopologyBundle bundle) => ._((bundle, this));
}

extension type const EdgeHandle._(CellHandle h) implements CellHandle {
  EdgeHandle.make(EdgeIndex index, int gen) : h = .make(.edge, index, gen);

  EdgeIndex get index {
    assert(h.kind == .edge);
    return EdgeIndex(_index);
  }

  String name(TopologyBundle bundle) => '${bundle.edgeId(this)}';
  CellId asId(TopologyBundle bundle) => bundle.edgeId(this);
  CellKey asKey(TopologyBundle bundle) => bundle.edgeKey(this);
  EdgeView asView(TopologyBundle bundle) => ._((bundle, this));
}

extension type const FaceHandle._(CellHandle h) implements CellHandle {
  FaceHandle.make(FaceIndex index, int gen) : h = .make(.face, index, gen);

  FaceIndex get index {
    assert(h.kind == .face);
    return FaceIndex(_index);
  }

  String name(TopologyBundle bundle) => '${bundle.faceId(this)}';
  CellId asId(TopologyBundle bundle) => bundle.faceId(this);
  CellKey asKey(TopologyBundle bundle) => bundle.faceKey(this);
  FaceView asView(TopologyBundle bundle) => ._((bundle, this));
}
