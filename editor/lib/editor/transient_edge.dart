part of '../editor.dart';

class TransientEdge with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdge({
    required this.editor,
    required this.startVertex,
    required this.mergeKey,
    this._cStart,
    this._cEnd,
    this._end,
  });

  final Editor editor;
  final VertexRef startVertex;
  final Object mergeKey;

  VertexHandle get startHandle => editor.scene.handleOf(startVertex)!;
  Vec2 get start => editor.bundle.vertexPosition(startHandle, space: .root);

  Vec2? _cStart;
  Vec2? get cStart => _cStart;
  set cStart(Vec2? value) {
    if (_cStart == value) return;
    _cStart = value;
    notifyListeners();
  }

  Vec2? _cEnd;
  Vec2? get cEnd => _cEnd;
  set cEnd(Vec2? value) {
    if (_cEnd == value) return;
    _cEnd = value;
    notifyListeners();
  }

  Vec2? _end;
  Vec2? get end => _end;
  set end(Vec2? value) {
    if (_end == value) return;
    _end = value;
    notifyListeners();
  }

  Cubic2 get cubic => Cubic2(start, end ?? start, p1: cStart, p2: cEnd);

  List<EdgeRef> _performCommit(SceneHitResult? endHitTest) {
    if (_end == null) return [];

    late final VertexRef endVertex;
    if (endHitTest != null) {
      endVertex = editor.edit((txn) => txn.embedVertex(endHitTest), mergeKey: mergeKey);
    } else {
      endVertex = editor.edit((txn) => txn.insert(VertexStatement(end!)), mergeKey: mergeKey).ref;
    }

    final startHandle = editor.handleOf(startVertex)!;
    final endHandle = editor.handleOf(endVertex)!;

    final parentHandle = editor.bundle.lca(startHandle, endHandle);
    final parentRef = editor.bundle.frameRef(parentHandle);
    final transform = editor.bundle.frameTransform(parentHandle, space: .root);
    final transformedCubic = cubic.transformed(transform);

    final startTransform = editor.bundle.query.localToWorld(startVertex);
    final endTransform = editor.bundle.query.localToWorld(endVertex);

    final statement = EdgeStatement(
      startVertex.selector(),
      endVertex.selector(),
      parent: parentRef,
      startTangent: startTransform.transformDelta2(transformedCubic.p1 - transformedCubic.p0),
      endTangent: endTransform.transformDelta2(transformedCubic.p2 - transformedCubic.p3),
    );

    editor.edit((txn) => txn.insert(statement), mergeKey: mergeKey);
    return [statement.ref];
  }

  TransientEdge? commit({SceneHitResult? endHitTest, bool startNewEdge = false}) {
    return editor.transientEdges.commit(this, endHitTest: endHitTest, startNewEdge: startNewEdge);
  }

  void remove() {
    editor.transientEdges.remove(this);
  }
}

class TransientEdges with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdges(this.editor);

  final Editor editor;
  final instances = <TransientEdge>[];

  TransientEdge create(VertexRef start, {Vec2? cStart, required Object mergeKey}) {
    final edge = TransientEdge(editor: editor, startVertex: start, cStart: cStart, mergeKey: mergeKey);
    instances.add(edge);
    notifyListeners();
    return edge;
  }

  TransientEdge createWithHitTest(SceneHitResult hitTest, {Vec2? cStart}) {
    final mergeKey = Object();
    final ref = editor.edit((txn) => txn.embedVertex(hitTest), mergeKey: mergeKey);
    return create(ref, cStart: cStart, mergeKey: mergeKey);
  }

  TransientEdge? commit(TransientEdge edge, {SceneHitResult? endHitTest, bool startNewEdge = false}) {
    final newEdges = edge._performCommit(endHitTest);
    remove(edge);

    if (startNewEdge && newEdges.isNotEmpty) {
      final edge = newEdges.last;
      final edgeHandle = editor.handleOf(edge);
      final endHandle = editor.bundle.edgeEnd(edgeHandle!);
      final end = editor.refOf(endHandle)!;
      final endPosition = editor.bundle.vertexPosition(endHandle, space: .root);
      final endTangent = editor.bundle.edgeEndTangent(edgeHandle, space: .root);
      final cStart = endPosition - endTangent;

      return create(end, cStart: cStart, mergeKey: Object());
    }

    return null;
  }

  void remove(TransientEdge edge) {
    instances.remove(edge);
    notifyListeners();
  }
}
