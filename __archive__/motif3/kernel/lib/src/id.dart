part of 'kernel.dart';

extension type const CellId(String value) implements Object {
  CellId derive(String suffix) => CellId('$value#$suffix');
  bool descendsFrom(CellId ancestor) => value == ancestor.value || value.startsWith('${ancestor.value}#');
}

enum CellKind { frame, vertex, edge, face }

extension type const CellKey<K extends CellHandle>._((CellKind, CellId) v) {
  const CellKey(CellKind kind, CellId id) : this._((kind, id));
  const CellKey.frame(CellId id) : this._((.frame, id));
  const CellKey.vertex(CellId id) : this._((.vertex, id));
  const CellKey.edge(CellId id) : this._((.edge, id));
  const CellKey.face(CellId id) : this._((.face, id));

  CellKind get kind => v.$1;
  CellId get id => v.$2;

  FrameKey get asFrame {
    assert(kind == .frame);
    return this as FrameKey;
  }

  VertexKey get asVertex {
    assert(kind == .vertex);
    return this as VertexKey;
  }

  EdgeKey get asEdge {
    assert(kind == .edge);
    return this as EdgeKey;
  }

  FaceKey get asFace {
    assert(kind == .face);
    return this as FaceKey;
  }
}

typedef FrameKey = CellKey<FrameHandle>;
typedef VertexKey = CellKey<VertexHandle>;
typedef EdgeKey = CellKey<EdgeHandle>;
typedef FaceKey = CellKey<FaceHandle>;
