part of '../renderer.dart';

final class RendererUpdater with ChangeNotifier, ChangeNotifierDisposable {
  new(this.renderer) {
    renderer.scene.addUpdateListener(_onSceneUpdate);
    bundle.frameStorage.observe(_frameObserver);
    bundle.vertexStorage.observe(_vertexObserver);
    bundle.covertexStorage.observe(_covertexObserver);
    bundle.edgeStorage.observe(_edgeObserver);
    bundle.faceStorage.observe(_faceObserver);
  }

  final Renderer renderer;
  Scene get scene => renderer.scene;
  Bundle get bundle => renderer.bundle;

  final _frameObserver = CacheArenaObserver<FrameIndex>();
  final _vertexObserver = CacheArenaObserver<VertexIndex>();
  final _covertexObserver = CacheArenaObserver<CovertexIndex>();
  final _edgeObserver = CacheArenaObserver<EdgeIndex>();
  final _faceObserver = CacheArenaObserver<FaceIndex>();

  final _restyledCells = HashSet<CellRef>();
  final _updatedFrames = HashSet<FrameRef>();
  final _added = HashSet<CellRef>();
  final _deleted = HashSet<CellRef>();

  void _onSceneUpdate(EvalPass pass) {
    _restyledCells.addAll(pass.restyled);
    _added.addAll(pass.added);
    _deleted.addAll(pass.deleted);
    _updatedFrames.addAll(pass.movedFrames);
    notifyListeners();
  }

  void _onStyleUpdate(CellRef ref) {
    _restyledCells.add(ref);
    notifyListeners();
  }

  void initialUpdate() {
    final textStatements = <TextStatement>{};
    for (final s in scene.evaluation.statements) {
      if (s is TextStatement) textStatements.add(s);
    }

    _updateStorage(
      frames: bundle.frameStorage.liveIndices,
      vertices: bundle.vertexStorage.liveIndices,
      covertices: bundle.covertexStorage.liveIndices,
      edges: bundle.edgeStorage.liveIndices,
      faces: bundle.faceStorage.liveIndices,
      restyled: scene.bundle.query.allCells,
      text: textStatements,
      framesCreated: bundle.frameStorage.liveIndices,
      verticesCreated: bundle.vertexStorage.liveIndices,
      edgesCreated: bundle.edgeStorage.liveIndices,
      facesCreated: bundle.faceStorage.liveIndices,
    );

    renderer.draw.initialUpdate();
  }

  void update() {
    _pruneStorage(
      frames: _frameObserver.retired,
      vertices: _vertexObserver.retired,
      covertices: _covertexObserver.retired,
      edges: _edgeObserver.retired,
      faces: _faceObserver.retired,
      deleted: _deleted,
    );

    final textStatements = <TextStatement>{};
    for (final id in _updatedFrames) {
      final statement = scene.statement(id.statementId);
      if (statement is TextStatement) textStatements.add(statement);
    }

    for (final ref in _added) {
      final statement = scene.statement(ref.statementId);
      if (statement is TextStatement) textStatements.add(statement);
    }

    _updateStorage(
      frames: _frameObserver.createdOrTouched,
      vertices: _vertexObserver.createdOrTouched,
      covertices: _covertexObserver.createdOrTouched,
      edges: _edgeObserver.createdOrTouched,
      faces: _faceObserver.createdOrTouched,
      restyled: _restyledCells,
      text: textStatements,
      framesCreated: _frameObserver.created,
      verticesCreated: _vertexObserver.created,
      edgesCreated: _edgeObserver.created,
      facesCreated: _faceObserver.created,
    );

    _frameObserver.clear();
    _vertexObserver.clear();
    _covertexObserver.clear();
    _edgeObserver.clear();
    _faceObserver.clear();
    _restyledCells.clear();
    _added.clear();
    _updatedFrames.clear();
    _deleted.clear();

    renderer.draw.updateOrder();
  }

  void _updateStorage({
    required Iterable<FrameIndex> frames,
    required Iterable<VertexIndex> vertices,
    required Iterable<CovertexIndex> covertices,
    required Iterable<EdgeIndex> edges,
    required Iterable<FaceIndex> faces,
    required Iterable<CellRef> restyled,
    required Iterable<TextStatement> text,
    required Iterable<FrameIndex> framesCreated,
    required Iterable<VertexIndex> verticesCreated,
    required Iterable<EdgeIndex> edgesCreated,
    required Iterable<FaceIndex> facesCreated,
  }) {
    final expandedFrames = HashSet<FrameIndex>.from(frames);
    final work = <FrameIndex>[...frames];
    while (work.isNotEmpty) {
      final current = work.removeLast();
      if (!bundle.frameStorage.isLive(current)) continue;
      expandedFrames.add(current);
      final children = bundle.frameChildrenRaw(current);
      for (final c in children) {
        if (c.kind == .frame) work.add(c.asFrame);
      }
    }

    for (final i in expandedFrames) {
      if (!bundle.frameStorage.isLive(i)) continue;
      renderer.geometry.updateFrame(i);
    }

    for (final i in vertices) {
      if (!bundle.vertexStorage.isLive(i)) continue;
      renderer.geometry.updateVertex(i);
      renderer.topology.updateVertex(i);
      renderer.draw.updateCell(bundle.vertexStorage.handleFor(i));
    }

    for (final i in covertices) {
      if (!bundle.covertexStorage.isLive(i)) continue;
      renderer.geometry.updateCovertex(i);
      renderer.topology.updateCovertex(i);
    }

    for (final i in edges) {
      if (!bundle.edgeStorage.isLive(i)) continue;
      renderer.geometry.updateEdge(i);
      renderer.topology.updateEdge(i);
    }

    for (final i in faces) {
      if (!bundle.faceStorage.isLive(i)) continue;
      renderer.topology.updateFace(i);
    }

    final _text = {...text};

    for (final ref in _updatedFrames) {
      final statement = scene.statement(ref.statementId);
      if (statement is TextStatement) _text.add(statement);
    }

    for (final ref in restyled) {
      final handle = bundle.handle(ref);
      if (handle == null) continue;

      renderer.draw.updateCell(handle);
      if (ref.kind == .frame) {
        final statement = scene.statement(ref.statementId);
        if (statement is TextStatement) _text.add(statement);
      }
    }

    for (final i in framesCreated) renderer.draw.updateCell(bundle.frameStorage.handleFor(i));
    for (final i in verticesCreated) renderer.draw.updateCell(bundle.vertexStorage.handleFor(i));
    for (final i in edgesCreated) renderer.draw.updateCell(bundle.edgeStorage.handleFor(i));
    for (final i in facesCreated) renderer.draw.updateCell(bundle.faceStorage.handleFor(i));

    for (final statement in _text) {
      final handle = bundle.handle(statement.frame);
      if (handle == null) continue;

      renderer.text.process(statement);
      renderer.draw.updateText(statement, handle.asFrame);
    }
  }

  void _pruneStorage({
    required Iterable<FrameIndex> frames,
    required Iterable<VertexIndex> vertices,
    required Iterable<CovertexIndex> covertices,
    required Iterable<EdgeIndex> edges,
    required Iterable<FaceIndex> faces,
    required Iterable<CellRef> deleted,
  }) {
    for (final i in vertices) {
      renderer.topology.releaseVertex(i);
      renderer.style.release(i.cell);
      renderer.draw.release(i.cell);
    }

    for (final i in covertices) {
      renderer.topology.releaseCovertex(i);
    }

    for (final i in edges) {
      renderer.topology.releaseEdge(i);
      renderer.style.release(i.cell);
      renderer.draw.release(i.cell);
    }

    for (final i in faces) {
      renderer.topology.releaseFace(i);
      renderer.style.release(i.cell);
      renderer.draw.release(i.cell);
    }

    for (final ref in deleted) {
      renderer.text.release(ref.statementId);
      renderer.draw.releaseRef(ref);
    }
  }

  @override
  void dispose() {
    renderer.scene.removeUpdateListener(_onSceneUpdate);
    bundle.frameStorage.unobserve(_frameObserver);
    bundle.vertexStorage.unobserve(_vertexObserver);
    bundle.covertexStorage.unobserve(_covertexObserver);
    bundle.edgeStorage.unobserve(_edgeObserver);
    bundle.faceStorage.unobserve(_faceObserver);
    super.dispose();
  }
}
