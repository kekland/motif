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
  final Vertex startVertex;

  Vector2 get start => startVertex.position;
  MultiChildSceneObject get parent => startVertex.parent!;

  Vector2? _cStart;
  Vector2? get cStart => _cStart;
  set cStart(Vector2? value) {
    if (_cStart == value) return;
    _cStart = value?.clone();
    notifyListeners();
  }

  Vector2? _cEnd;
  Vector2? get cEnd => _cEnd;
  set cEnd(Vector2? value) {
    if (_cEnd == value) return;
    _cEnd = value?.clone();
    notifyListeners();
  }

  Vector2? _end;
  Vector2? get end => _end;
  set end(Vector2? value) {
    if (_end == value) return;
    _end = value?.clone();
    notifyListeners();
  }

  Cubic2 get cubic => Cubic2(start, end ?? start, p1: cStart, p2: cEnd);

  List<Edge> _performCommit(SceneHitTestResult? endHitTest) {
    if (_end == null) return [];

    late final Vertex endVertex;
    if (endHitTest != null) {
      endVertex = editor.scene.topology.embedVertexAtHitTest(endHitTest);
    } else {
      endVertex = Vertex(_end!);
      endVertex.parent = parent;
    }

    return editor.scene.topology.commitStroke(
      parent,
      .fromCubic(cubic),
      startVertex: startVertex,
      endVertex: endVertex,
    );
  }

  TransientEdge? commit({SceneHitTestResult? endHitTest, bool startNewEdge = false}) {
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

  TransientEdge create(Vertex start, {Vector2? cStart}) {
    final edge = TransientEdge(editor: editor, startVertex: start, cStart: cStart);
    instances.add(edge);
    notifyListeners();
    return edge;
  }

  TransientEdge createWithHitTest(SceneHitTestResult hitTest, {Vector2? cStart}) {
    final startVertex = editor.scene.topology.embedVertexAtHitTest(hitTest);
    return create(startVertex, cStart: cStart);
  }

  TransientEdge? commit(TransientEdge edge, {SceneHitTestResult? endHitTest, bool startNewEdge = false}) {
    final newEdges = edge._performCommit(endHitTest);
    remove(edge);

    if (startNewEdge && newEdges.isNotEmpty) {
      final last = newEdges.last;
      final lastKnot = last.path.last;
      final cStart = lastKnot.cIn.pointReflect(last.end.position);
      return create(last.end, cStart: cStart);
    }

    return null;
  }

  void remove(TransientEdge edge) {
    instances.remove(edge);
    notifyListeners();
  }
}
