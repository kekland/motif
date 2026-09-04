part of 'kernel.dart';

extension type const CellView._((TopologyBundle b, CellHandle h) k) {
  TopologyBundle get bundle => k.$1;
  CellHandle get handle => k.$2;

  bool get isAlive => bundle.isCellAlive(handle);
  CellId get id => bundle.cellId(handle);
  CellKey get key => bundle.key(handle);

  CellKind get kind => handle.kind;
  FrameView? get parent => bundle.parentOf(handle)?.view(bundle);
  CellView? get prevSibling => bundle.siblingPrevOf(handle)?.view(bundle);
  CellView? get nextSibling => bundle.siblingNextOf(handle)?.view(bundle);

  FrameView lca(CellView other) => bundle.lca(handle, other.handle).view(bundle);
  Mat4 getTransformTo(CellView other) => bundle.getTransformBetween(handle, other.handle);
}

extension type const FrameView._((TopologyBundle b, FrameHandle h) k) implements CellView {
  FrameHandle get handle => k.$2;

  Mat4 get transform => bundle.frameTransform(handle);
  bool get hasChildren => bundle.frameHasChildren(handle);
  Iterable<CellView> get children => bundle.frameChildren(handle).map((h) => h.view(bundle));
}

extension type const VertexView._((TopologyBundle b, VertexHandle h) k) implements CellView {
  VertexHandle get handle => k.$2;

  Vec2 get position => bundle.vertexPosition(handle);
  int get valence => bundle.vertexValence(handle);
  bool get hasUses => bundle.vertexHasUses(handle);
  Iterable<Covertex> get uses => bundle.vertexUses(handle);
  Iterable<EdgeView> get edges => bundle.vertexEdges(handle).map((h) => h.view(bundle));
  List<List<EdgeView>> get sectors {
    final sectors = <List<EdgeView>>[];
    for (final sector in bundle.vertexSectors(handle)) {
      sectors.add(sector.map((h) => h.view(bundle)).toList());
    }
    return sectors;
  }
}

extension type const EdgeView._((TopologyBundle b, EdgeHandle h) k) implements CellView {
  EdgeHandle get handle => k.$2;

  VertexView get start => bundle.edgeStart(handle).view(bundle);
  VertexView get end => bundle.edgeEnd(handle).view(bundle);
  bool get isLoop => bundle.edgeStart(handle) == bundle.edgeEnd(handle);
  Vec2 get startHandle => bundle.edgeStartTangent(handle);
  Vec2 get endHandle => bundle.edgeEndTangent(handle);
  Iterable<(FaceView, Coedge)> get uses => bundle.edgeUses(handle).map((u) => (u.$1.view(bundle), u.$2));
  Iterable<FaceView> get faces => bundle.edgeFaces(handle).map((h) => h.view(bundle));
}

extension type const FaceView._((TopologyBundle b, FaceHandle h) k) implements CellView {
  FaceHandle get handle => k.$2;

  Iterable<Cycle> get boundary => bundle.faceBoundary(handle);
}
