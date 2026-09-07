part of 'kernel.dart';

final class Bundle {
  Bundle() {
    _frame.allocRoot();
  }

  final _frame = FrameStorage();
  final _coframe = CoframeStorage();
  final _vertex = VertexStorage();
  final _covertex = CovertexStorage();
  final _edge = EdgeStorage();
  final _coedge = CoedgeStorage();
  final _face = FaceStorage();

  final _changeTracker = ChangeTracker();

  late final _queries = TopologyQuery._(this);
  TopologyQuery get query => _queries;

  Arrangement? _cachedArrangement;
  Arrangement get arrangement {
    final cached = _cachedArrangement;
    if (cached != null && cached._version == _version) return cached;
    return _cachedArrangement = .of(this);
  }

  FrameHandle get root => _frame.handleFor(.root);

  var _worldEpoch = 0;
  var _version = 0;
  int get version => _version;

  // -------------------------------------------------------------------------------------------------------------------
  // Frame
  // -------------------------------------------------------------------------------------------------------------------

  int get frameCount => _frame.liveCount;
  Iterable<FrameHandle> get frames => _frame.liveHandles;

  bool frameHasChildren(FrameHandle h) {
    assert(_checkFrame(h));
    return _frameHasChildren(h.index);
  }

  Iterable<CellHandle> frameChildren(FrameHandle h) sync* {
    assert(_checkFrame(h));
    for (final c in _frameChildren(h.index)) yield _cellHandle(c);
  }

  Iterable<CellHandle> frameSubtree(FrameHandle f) sync* {
    for (final c in frameChildren(f)) {
      yield c;
      if (c.kind == .frame) yield* frameSubtree(c.asFrame);
    }
  }

  CellHandle? frameChildrenHead(FrameHandle h) {
    assert(_checkFrame(h));
    final c = _frameChildHead(h.index);
    return c.isNone ? null : _cellHandle(c);
  }

  Mat4 frameTransform(FrameHandle h, {FrameHandle? space}) {
    assert(_checkFrame(h));
    assert(space == null || _checkFrame(space));
    return _frameTransform(h.index, space: space?.index);
  }

  Size2? frameSize(FrameHandle h, {FrameHandle? space}) {
    assert(_checkFrame(h));
    assert(space == null || _checkFrame(space));
    return _frameSize(h.index, space: space?.index);
  }

  FaceHandle? frameClip(FrameHandle h) {
    assert(_checkFrame(h));
    final c = _frameClip(h.index);
    return c != null ? _face.handleFor(c) : null;
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Vertex
  // -------------------------------------------------------------------------------------------------------------------

  int get vertexCount => _vertex.liveCount;
  Iterable<VertexHandle> get vertices => _vertex.liveHandles;

  bool vertexHasUses(VertexHandle v) {
    assert(_checkVertex(v));
    return _vertexHasUses(v.index);
  }

  Iterable<EdgeHandle> vertexEdges(VertexHandle v) sync* {
    assert(_checkVertex(v));
    for (final e in _vertexEdges(v.index)) yield _edge.handleFor(e);
  }

  Iterable<Covertex> vertexUses(VertexHandle v) sync* {
    assert(_checkVertex(v));
    for (final cv in _vertexDiskLive(v.index)) yield _covertexFor(cv);
  }

  Vec2 vertexPosition(VertexHandle v, {FrameHandle? space}) {
    assert(_checkVertex(v));
    assert(space == null || _checkFrame(space));
    return _vertexPosition(v.index, space: space?.index);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Edge
  // -------------------------------------------------------------------------------------------------------------------

  int get edgeCount => _edge.liveCount;
  Iterable<EdgeHandle> get edges => _edge.liveHandles;

  bool edgeHasUses(EdgeHandle e) {
    assert(_checkEdge(e));
    return _edgeHasUses(e.index);
  }

  Iterable<FaceHandle> edgeFaces(EdgeHandle e) sync* {
    assert(_checkEdge(e));
    for (final f in _edgeFaces(e.index)) yield _face.handleFor(f);
  }

  Iterable<(FaceHandle, Coedge)> edgeUses(EdgeHandle e) sync* {
    assert(_checkEdge(e));
    for (final ce in _edgeRadial(e.index)) {
      final face = _face.handleFor(_coedge.face[ce]);
      final coedge = _coedgeFor(ce);
      yield (face, coedge);
    }
  }

  VertexHandle edgeStart(EdgeHandle e) {
    assert(_checkEdge(e));
    return _vertex.handleFor(_edgeStart(e.index));
  }

  VertexHandle edgeEnd(EdgeHandle e) {
    assert(_checkEdge(e));
    return _vertex.handleFor(_edgeEnd(e.index));
  }

  Iterable<VertexHandle> edgeVertices(EdgeHandle e) sync* {
    assert(_checkEdge(e));
    for (final v in _edgeVertices(e.index)) yield _vertex.handleFor(v);
  }

  Vec2 edgeStartTangent(EdgeHandle e, {FrameHandle? space}) {
    assert(_checkEdge(e));
    assert(space == null || _checkFrame(space));
    return _edgeStartTangent(e.index, space: space?.index);
  }

  Vec2 edgeEndTangent(EdgeHandle e, {FrameHandle? space}) {
    assert(_checkEdge(e));
    assert(space == null || _checkFrame(space));
    return _edgeEndTangent(e.index, space: space?.index);
  }

  Cubic2 edgeCubic(EdgeHandle e, {FrameHandle? space}) {
    assert(_checkEdge(e));
    assert(space == null || _checkFrame(space));
    return _edgeCubic(e.index, space: space?.index);
  }

  CubicArcIndex edgeCubicArcIndex(EdgeHandle e, {FrameHandle? space}) {
    assert(_checkEdge(e));
    assert(space == null || _checkFrame(space));
    return _edgeCubicArcIndex(e.index, space: space?.index);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Coedge
  // -------------------------------------------------------------------------------------------------------------------

  VertexHandle coedgeStart(Coedge ce) {
    assert(_checkEdge(ce.edge));
    return ce.forward ? edgeStart(ce.edge) : edgeEnd(ce.edge);
  }

  VertexHandle coedgeEnd(Coedge ce) {
    assert(_checkEdge(ce.edge));
    return ce.forward ? edgeEnd(ce.edge) : edgeStart(ce.edge);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Cycle
  // -------------------------------------------------------------------------------------------------------------------

  double cycleSignedArea(Cycle cycle, {FrameHandle? space}) {
    assert(space == null || _checkFrame(space));
    return _cycleSignedArea(cycle, space: space?.index);
  }

  int cycleWinding(Cycle cycle, Vec2 p, {FrameHandle? space}) {
    assert(space == null || _checkFrame(space));
    return _cycleWinding(cycle, p, space: space?.index);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Face
  // -------------------------------------------------------------------------------------------------------------------

  int get faceCount => _face.liveCount;
  Iterable<FaceHandle> get faces => _face.liveHandles;

  Iterable<Cycle> faceBoundary(FaceHandle f) sync* {
    assert(_checkFace(f));
    for (final ce in _faceBoundary(f.index)) yield _cycleFor(_cycleCoedges(ce));
  }

  double faceSignedArea(FaceHandle f, {FrameHandle? space}) {
    assert(_checkFace(f));
    assert(space == null || _checkFrame(space));
    return _faceSignedArea(f.index, space: space?.index);
  }

  int faceWinding(FaceHandle f, Vec2 p, {FrameHandle? space}) {
    assert(_checkFace(f));
    assert(space == null || _checkFrame(space));
    return _faceWinding(f.index, p, space: space?.index);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Tree
  // -------------------------------------------------------------------------------------------------------------------

  FrameHandle? parentOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _treeParentOf(h.cellIndex);
    return p.isNone ? null : _frame.handleFor(p);
  }

  CellHandle? siblingPrevOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _treeSiblingPrev(h.cellIndex);
    return p.isNone ? null : _cellHandle(p);
  }

  CellHandle? siblingNextOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _treeSiblingNext(h.cellIndex);
    return p.isNone ? null : _cellHandle(p);
  }

  Mat4 transformBetween(CellHandle a, CellHandle b) {
    assert(_checkCell(a));
    assert(_checkCell(b));
    return _treeTransformBetween(a.cellIndex, b.cellIndex);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Cells
  // -------------------------------------------------------------------------------------------------------------------

  FrameHandle? frame(CellId id) => _frame.handleForId(id);
  VertexHandle? vertex(CellId id) => _vertex.handleForId(id);
  EdgeHandle? edge(CellId id) => _edge.handleForId(id);
  FaceHandle? face(CellId id) => _face.handleForId(id);

  FrameRef frameRef(FrameHandle h) => .frame(frameId(h));
  CellId frameId(FrameHandle h) {
    assert(_checkFrame(h));
    return _frame.id.of(h.index);
  }

  VertexRef vertexRef(VertexHandle h) => .vertex(vertexId(h));
  CellId vertexId(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertex.id.of(h.index);
  }

  EdgeRef edgeRef(EdgeHandle h) => .edge(edgeId(h));
  CellId edgeId(EdgeHandle h) {
    assert(_checkEdge(h));
    return _edge.id.of(h.index);
  }

  FaceRef faceRef(FaceHandle h) => .face(faceId(h));
  CellId faceId(FaceHandle h) {
    assert(_checkFace(h));
    return _face.id.of(h.index);
  }

  H? handle<H extends CellHandle>(CellRef ref) => switch (ref.kind) {
    .frame => frame(ref.id),
    .vertex => vertex(ref.id),
    .edge => edge(ref.id),
    .face => face(ref.id),
  } as H?;

  CellId id(CellHandle h) {
    return switch (h.kind) {
      .frame => frameId(h.asFrame),
      .vertex => vertexId(h.asVertex),
      .edge => edgeId(h.asEdge),
      .face => faceId(h.asFace),
    };
  }

  CellRef<H> ref<H extends CellHandle>(H h) {
    return switch (h.kind) {
      .frame => frameRef(h.asFrame),
      .vertex => vertexRef(h.asVertex),
      .edge => edgeRef(h.asEdge),
      .face => faceRef(h.asFace),
    } as CellRef<H>;
  }

  bool isLive(CellRef ref) {
    final handle = this.handle(ref);
    if (handle == null) return false;
    return switch (ref.kind) {
      .frame => isFrameLive(handle as FrameHandle),
      .vertex => isVertexLive(handle as VertexHandle),
      .edge => isEdgeLive(handle as EdgeHandle),
      .face => isFaceLive(handle as FaceHandle),
    };
  }

  Iterable<CellRef> cellDirectDependents(CellRef r) {
    final h = handle(r);
    return _cellDependents(h!.cellIndex).map((i) => ref(_cellHandle(i)));
  }

  List<CellRef> cellDependencies(CellRef ref) {
    final out = <CellRef>[];

    if (ref.kind == .edge) {
      final e = edge(ref.id)!;
      out.add(vertexRef(edgeStart(e)));
      out.add(vertexRef(edgeEnd(e)));
    } else if (ref.kind == .face) {
      final f = face(ref.id)!;
      for (final c in faceBoundary(f)) {
        for (final u in c) {
          out.add(edgeRef(u.edge));
          out.add(vertexRef(coedgeEnd(u)));
        }
      }
    }

    return out;
  }

  FrameHandle lca(CellHandle a, CellHandle b) {
    assert(_checkCell(a) && _checkCell(b));
    return _frame.handleFor(_treeLca(a.cellIndex, b.cellIndex));
  }

  bool isAncestorOf(CellHandle a, {required FrameHandle ancestor}) {
    assert(_checkCell(a) && _checkFrame(ancestor));
    return _treeIsAncestorOf(a.cellIndex, ancestor: ancestor.index);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Transaction
  // -------------------------------------------------------------------------------------------------------------------

  var _hasTransaction = false;

  Transaction beginTransaction({int? namespace}) => Transaction(this, namespace: namespace);

  void _lockTransaction() {
    if (_hasTransaction) throw StateError('transaction already in progress');
    _hasTransaction = true;
  }

  void _endTransaction() {
    assert(_hasTransaction, 'no transaction in progress');
    _hasTransaction = false;
  }
}
