part of 'kernel.dart';

final class TopologyBundle {
  TopologyBundle() {
    _setRootFrame();
  }

  late final _queries = TopologyQuery._(this);
  TopologyQuery get query => _queries;

  Arrangement? _cachedArrangement;
  Arrangement get arrangement {
    final cached = _cachedArrangement;
    if (cached != null && cached._version == _version) return cached;
    return _cachedArrangement = .of(this);
  }

  final _frame = FrameStorage();
  final _vertex = VertexStorage();
  final _covertex = CovertexStorage();
  final _edge = EdgeStorage();
  final _coedge = CoedgeStorage();
  final _face = FaceStorage();

  FrameHandle get root => _frame.handleFor(.root);

  void _setRootFrame() {
    final i = _frame.alloc();
    _frame.parent[i] = .none;
    _frame.transform[i] = .identity();
    _frame.siblingPrev[i] = .none;
    _frame.siblingNext[i] = .none;
    _frame.childHead[i] = .none;
    _frame.childTail[i] = .none;
    _frame.clip[i] = .none;
    _frame.id.assign(i, .new('root'));
  }

  int _version = 0;
  int get version => _version;

  int _opCounter = 0;
  int _worldEpoch = 1;

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Frame methods
  // @-----------------------------------------------------------------------------------------------------------------@

  int get frameCount => _frame.liveCount;
  Iterable<FrameHandle> get frames => _frame.liveHandles;
  bool isFrameAlive(FrameHandle h) => _frame.isHandleAlive(h.index, h.gen);
  FrameHandle? frame(CellId id) => _frame.handleForId(id);

  FrameView frameView(FrameHandle h) {
    assert(_checkFrame(h));
    return ._((this, h));
  }

  FrameKey frameKey(FrameHandle h) => .frame(frameId(h));
  CellId frameId(FrameHandle h) {
    assert(_checkFrame(h));
    return _frame.id.of(h.index);
  }

  FrameHandle? frameParent(FrameHandle h) {
    assert(_checkFrame(h));
    final p = _frame.parent[h.index];
    return p.isNone ? null : _frame.handleFor(p);
  }

  bool frameHasChildren(FrameHandle h) {
    assert(_checkFrame(h));
    return _frame.childHead[h.index].isNotNone;
  }

  Iterable<CellHandle> frameChildren(FrameHandle h) sync* {
    assert(_checkFrame(h));
    var child = _frame.childHead[h.index];
    while (!child.isNone) {
      final childHandle = _handleOf(child);
      yield childHandle;
      child = _siblingNext(child);
    }
  }

  Mat4 frameTransform(FrameHandle h) {
    assert(_checkFrame(h));
    return .copy(_frame.transform[h.index]);
  }

  Mat4 frameTransformWorld(FrameHandle h) {
    assert(_checkFrame(h));
    return .copy(_frameWorldTransform(h.index));
  }

  Size2? frameSize(FrameHandle h, {FrameHandle? space}) {
    assert(_checkFrame(h));
    assert(space == null || _checkFrame(space));
    return _frameSizeIn(h.index, space?.index ?? h.index);
  }

  FaceHandle? frameClip(FrameHandle h) {
    assert(_checkFrame(h));
    final clip = _frame.clip[h.index];
    return clip.isNone ? null : _face.handleFor(clip);
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Vertex methods
  // @-----------------------------------------------------------------------------------------------------------------@

  int get vertexCount => _vertex.liveCount;
  Iterable<VertexHandle> get vertices => _vertex.liveHandles;
  bool isVertexAlive(VertexHandle h) => _vertex.isHandleAlive(h.index, h.gen);
  VertexHandle? vertex(CellId id) => _vertex.handleForId(id);

  VertexView vertexView(VertexHandle h) {
    assert(_checkVertex(h));
    return ._((this, h));
  }

  VertexKey vertexKey(VertexHandle h) => .vertex(vertexId(h));
  CellId vertexId(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertex.id.of(h.index);
  }

  Vec2 vertexPosition(VertexHandle h, {FrameHandle? space}) {
    assert(_checkVertex(h));
    assert(space == null || _checkFrame(space));
    return _vertexPositionIn(h.index, space?.index ?? _vertex.parent[h.index]);
  }

  Vec2 vertexPositionWorld(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertexPositionWorld(h.index);
  }

  bool vertexHasUses(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertex.diskStart[h.index].isNotNone;
  }

  int vertexValence(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertexDisk(h.index).length;
  }

  Iterable<Covertex> vertexUses(VertexHandle h) sync* {
    assert(_checkVertex(h));
    for (final cv in _vertexDisk(h.index)) yield _covertexAt(cv);
  }

  Iterable<EdgeHandle> vertexEdges(VertexHandle h) sync* {
    assert(_checkVertex(h));
    for (final cv in _vertexDisk(h.index)) yield _edgeAt(_covertex.edge[cv]);
  }

  List<List<EdgeHandle>> vertexSectors(VertexHandle h) {
    assert(_checkVertex(h));
    return _vertexSectors(h);
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Edge methods
  // @-----------------------------------------------------------------------------------------------------------------@

  int get edgeCount => _edge.liveCount;
  Iterable<EdgeHandle> get edges => _edge.liveHandles;
  bool isEdgeAlive(EdgeHandle h) => _edge.isHandleAlive(h.index, h.gen);
  EdgeHandle? edge(CellId id) => _edge.handleForId(id);

  EdgeView edgeView(EdgeHandle h) {
    assert(_checkEdge(h));
    return ._((this, h));
  }

  EdgeKey edgeKey(EdgeHandle h) => .edge(edgeId(h));
  CellId edgeId(EdgeHandle h) {
    assert(_checkEdge(h));
    return _edge.id.of(h.index);
  }

  VertexHandle edgeStart(EdgeHandle h) {
    assert(_checkEdge(h));
    return _vertex.handleFor(_edge.vStart[h.index]);
  }

  VertexHandle edgeEnd(EdgeHandle h) {
    assert(_checkEdge(h));
    return _vertex.handleFor(_edge.vEnd[h.index]);
  }

  Vec2 edgeStartTangent(EdgeHandle h, {FrameHandle? space}) {
    assert(_checkEdge(h));
    assert(space == null || _checkFrame(space));
    return _covertexTangentIn(_edge.cvStart[h.index], space: space?.index ?? _edge.parent[h.index]);
  }

  Vec2 edgeEndTangent(EdgeHandle h, {FrameHandle? space}) {
    assert(_checkEdge(h));
    assert(space == null || _checkFrame(space));
    return _covertexTangentIn(_edge.cvEnd[h.index], space: space?.index ?? _edge.parent[h.index]);
  }

  Cubic2 edgeCubic(EdgeHandle h, {FrameHandle? space}) {
    assert(_checkEdge(h));
    assert(space == null || _checkFrame(space));
    return _edgeCubicIn(h.index, space?.index ?? _edge.parent[h.index]);
  }

  Cubic2 edgeCubicWorld(EdgeHandle h) {
    assert(_checkEdge(h));
    return _edgeCubicWorld(h.index);
  }

  bool edgeHasUses(EdgeHandle h) {
    assert(_checkEdge(h));
    return _edge.radialStart[h.index].isNotNone;
  }

  Iterable<(FaceHandle, Coedge)> edgeUses(EdgeHandle h) sync* {
    assert(_checkEdge(h));
    for (final ce in _edgeRadial(h.index)) {
      final face = _faceAt(_coedge.face[ce]);
      final coedge = _coedgeAt(ce);
      yield (face, coedge);
    }
  }

  Iterable<FaceHandle> edgeFaces(EdgeHandle h) sync* {
    assert(_checkEdge(h));
    for (final ce in _edgeRadial(h.index)) yield _faceAt(_coedge.face[ce]);
  }

  VertexHandle coedgeStart(Coedge ce) {
    assert(_checkEdge(ce.edge));
    final e = ce.edge.index;
    return _vertexAt(ce.forward ? _edge.vStart[e] : _edge.vEnd[e]);
  }

  VertexHandle coedgeEnd(Coedge ce) {
    assert(_checkEdge(ce.edge));
    final e = ce.edge.index;
    return _vertexAt(ce.forward ? _edge.vEnd[e] : _edge.vStart[e]);
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Face methods
  // @-----------------------------------------------------------------------------------------------------------------@

  int get faceCount => _face.liveCount;
  Iterable<FaceHandle> get faces => _face.liveHandles;
  bool isFaceAlive(FaceHandle h) => _face.isHandleAlive(h.index, h.gen);
  FaceHandle? face(CellId id) => _face.handleForId(id);

  FaceView faceView(FaceHandle h) {
    assert(_checkFace(h));
    return ._((this, h));
  }

  FaceKey faceKey(FaceHandle h) => .face(faceId(h));
  CellId faceId(FaceHandle h) {
    assert(_checkFace(h));
    return _face.id.of(h.index);
  }

  double cycleSignedArea(Cycle cycle) {
    var total = 0.0;
    for (final u in cycle) {
      final a = _edgeCubicWorld(u.edge.index).signedAreaIntegral;
      total += u.forward ? a : -a;
    }
    return total;
  }

  double faceSignedArea(FaceHandle h) {
    _checkFace(h);
    var total = 0.0;
    for (final cycle in faceBoundary(h)) total += cycleSignedArea(cycle);
    return total;
  }

  Iterable<Cycle> faceBoundary(FaceHandle h) sync* {
    assert(_checkFace(h));
    for (final head in _face.boundary[h.index]) yield _cycleFor(_cycleCoedges(head));
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Tree methods
  // @-----------------------------------------------------------------------------------------------------------------@

  FrameHandle? parentOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _parentOf(h.cell);
    return p.isNone ? null : _frame.handleFor(p);
  }

  CellHandle? siblingPrevOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _siblingPrev(h.cell);
    return p.isNone ? null : _handleOf(p);
  }

  CellHandle? siblingNextOf(CellHandle h) {
    assert(_checkCell(h));
    final p = _siblingNext(h.cell);
    return p.isNone ? null : _handleOf(p);
  }

  FrameHandle lca(CellHandle a, CellHandle b) {
    assert(_checkCell(a));
    assert(_checkCell(b));
    return _lca(a, b);
  }

  Mat4 getTransformBetween(CellHandle from, CellHandle to) {
    assert(_checkCell(from));
    assert(_checkCell(to));
    return _transformBetween(from, to);
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Assertions
  // @-----------------------------------------------------------------------------------------------------------------@

  bool _checkCell(CellHandle h) {
    return switch (h.kind) {
      .frame => _checkFrame(h.asFrame),
      .vertex => _checkVertex(h.asVertex),
      .edge => _checkEdge(h.asEdge),
      .face => _checkFace(h.asFace),
    };
  }

  bool _checkFrame(FrameHandle h) {
    assert(isFrameAlive(h), 'stale frame handle: $h');
    return true;
  }

  bool _checkVertex(VertexHandle h) {
    assert(isVertexAlive(h), 'stale vertex handle: $h');
    return true;
  }

  bool _checkEdge(EdgeHandle h) {
    assert(isEdgeAlive(h), 'stale edge handle: $h');
    return true;
  }

  bool _checkFace(FaceHandle h) {
    assert(isFaceAlive(h), 'stale face handle: $h');
    return true;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Utilities methods
  // @-----------------------------------------------------------------------------------------------------------------@

  bool isCellAlive(CellHandle h) {
    return switch (h.kind) {
      .frame => isFrameAlive(h.asFrame),
      .vertex => isVertexAlive(h.asVertex),
      .edge => isEdgeAlive(h.asEdge),
      .face => isFaceAlive(h.asFace),
    };
  }

  CellId cellId(CellHandle h) {
    return switch (h.kind) {
      .frame => frameId(h.asFrame),
      .vertex => vertexId(h.asVertex),
      .edge => edgeId(h.asEdge),
      .face => faceId(h.asFace),
    };
  }

  CellKey key(CellHandle h) {
    return switch (h.kind) {
      .frame => frameKey(h.asFrame),
      .vertex => vertexKey(h.asVertex),
      .edge => edgeKey(h.asEdge),
      .face => faceKey(h.asFace),
    };
  }

  CellView cellView(CellHandle h) {
    return switch (h.kind) {
      .frame => frameView(h.asFrame),
      .vertex => vertexView(h.asVertex),
      .edge => edgeView(h.asEdge),
      .face => faceView(h.asFace),
    };
  }

  CellHandle? handle(CellKey ref) {
    return switch (ref.kind) {
      .frame => frame(ref.id),
      .vertex => vertex(ref.id),
      .edge => edge(ref.id),
      .face => face(ref.id),
    };
  }

  Mat4 cellWorldTransform(CellHandle h) {
    assert(_checkCell(h));
    return .copy(_frameWorldTransform(_spaceOf(h)));
  }

  Mat4 cellParentWorldTransform(CellHandle h) {
    assert(_checkCell(h));
    return .copy(_frameWorldTransform(_parentOf(h.cell)));
  }

  FrameHandle? cellSpace(CellHandle h) {
    assert(_checkCell(h));
    final s = _spaceOf(h);
    return s.isNone ? null : _frame.handleFor(s);
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Transactions
  // @-----------------------------------------------------------------------------------------------------------------@

  var _hasTransaction = false;

  TopologyTransaction beginTransaction() => TopologyTransaction(this);

  void _lockTransaction() {
    if (_hasTransaction) throw StateError('transaction already in progress');
    _hasTransaction = true;
  }

  void _endTransaction() {
    assert(_hasTransaction, 'no transaction in progress');
    _hasTransaction = false;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Cloning
  // @-----------------------------------------------------------------------------------------------------------------@

  TopologyBundle clone() {
    final out = TopologyBundle();
    out._frame.copyFrom(_frame);
    out._vertex.copyFrom(_vertex);
    out._covertex.copyFrom(_covertex);
    out._edge.copyFrom(_edge);
    out._coedge.copyFrom(_coedge);
    out._face.copyFrom(_face);

    out._opCounter = _opCounter;
    out._version = _version;
    out._worldEpoch = _worldEpoch;
    return out;
  }

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Validation
  // @-----------------------------------------------------------------------------------------------------------------@

  List<ValidationIssue> validate() => _validateBundle();
}
