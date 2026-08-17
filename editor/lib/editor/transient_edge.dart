part of '../editor.dart';

class TransientEdge with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdge({
    required this.editor,
    required this.startVertex,
    this._cStart,
    this._cEnd,
    this._end,
  });

  final Editor editor;
  final VertexRef startVertex;

  VertexHandle get startHandle => editor.scene.handleOf(startVertex);
  Vec2 get start => editor.bundle.vertexPositionWorld(startHandle);

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
      endVertex = editor.edit((txn) => txn.embedVertex(endHitTest));
    } else {
      endVertex = editor.edit((txn) => txn.insert(VertexStatement(end!))).vertex;
    }

    final startHandle = editor.handleOf(startVertex);
    final endHandle = editor.handleOf(endVertex);

    final parentHandle = editor.bundle.lca(startHandle, editor.handleOf(endVertex));
    final parentKey = editor.bundle.frameKey(parentHandle)!;
    final transform = editor.bundle.frameTransformWorld(parentHandle);
    final transformedCubic = cubic.transformed(transform);

    final startTransform = editor.bundle.cellWorldTransform(startHandle);
    final endTransform = editor.bundle.cellWorldTransform(endHandle);

    final statement = EdgeStatement(
      startVertex,
      endVertex,
      parent: editor.refOf(parentKey),
      startTangent: startTransform.transformDelta2(transformedCubic.p1 - transformedCubic.p0),
      endTangent: endTransform.transformDelta2(transformedCubic.p2 - transformedCubic.p3),
    );

    editor.edit((txn) => txn.insert(statement));

    return [statement.edge];
  }

  TransientEdge? commit({SceneHitResult? endHitTest, bool startNewEdge = false}) {
    return editor.transientEdges.commit(this, endHitTest: endHitTest, startNewEdge: startNewEdge);
  }

  void remove() {
    editor.transientEdges.remove(this);
  }

  void _performRemove() {
    final hasUses = editor.bundle.vertexHasUses(startHandle);
    if (!hasUses) editor.edit((txn) => txn.remove(editor.scene.statementOf(startVertex).id));
  }
}

class TransientEdges with ChangeNotifier, ChangeNotifierDisposable {
  TransientEdges(this.editor);

  final Editor editor;
  final instances = <TransientEdge>[];

  TransientEdge create(VertexRef start, {Vec2? cStart}) {
    final edge = TransientEdge(editor: editor, startVertex: start, cStart: cStart);
    instances.add(edge);
    notifyListeners();
    return edge;
  }

  TransientEdge createWithHitTest(SceneHitResult hitTest, {Vec2? cStart}) {
    final ref = editor.edit((txn) => txn.embedVertex(hitTest));
    return create(ref, cStart: cStart);
  }

  TransientEdge? commit(TransientEdge edge, {SceneHitResult? endHitTest, bool startNewEdge = false}) {
    final newEdges = edge._performCommit(endHitTest);
    remove(edge);

    if (startNewEdge && newEdges.isNotEmpty) {
      final edge = newEdges.last;
      final edgeHandle = editor.handleOf(edge);
      final endHandle = editor.bundle.edgeEnd(edgeHandle);
      final end = editor.refOf(editor.bundle.vertexKey(endHandle))!;
      final endPosition = editor.bundle.vertexPositionWorld(endHandle);
      final endTangent = editor.bundle.edgeEndTangentWorld(edgeHandle);
      final cStart = endPosition - endTangent;

      return create(end, cStart: cStart);
    }

    return null;
  }

  void remove(TransientEdge edge) {
    edge._performRemove();
    instances.remove(edge);
    notifyListeners();
  }
}
