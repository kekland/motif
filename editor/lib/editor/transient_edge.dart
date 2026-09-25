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

  Vec2? _nextCStart;
  Vec2? get nextCStart => _nextCStart;
  set nextCStart(Vec2? value) {
    if (_nextCStart == value) return;
    _nextCStart = value;
    notifyListeners();
  }

  Cubic2 get cubic => Cubic2(start, end ?? start, p1: cStart, p2: cEnd);

  List<EdgeRef> _performCommit(
    SceneHitResult? endHitTest, {
    bool topological = true,
    bool destructive = true,
    EdgeStyle edgeStyle = .default_,
  }) {
    if (_end == null) return [];

    return editor.edit((txn) {
      late final VertexRef endVertex;
      if (endHitTest != null) {
        endVertex = txn.embedVertex(endHitTest, topological: topological, destructive: destructive);
      } else {
        endVertex = txn.insert(VertexStatement(end!)).ref;
      }

      txn.flush();
      final result = txn.embedEdge(
        startVertex,
        endVertex,
        cubic,
        topological: topological,
        destructive: destructive,
        style: edgeStyle,
      );

      return result;
    }, mergeKey: mergeKey);
  }

  TransientEdge? commit({
    SceneHitResult? endHitTest,
    bool startNewEdge = false,
    bool topological = true,
    bool destructive = true,
    EdgeStyle edgeStyle = .default_,
  }) {
    return editor.transientEdges.commit(
      this,
      endHitTest: endHitTest,
      startNewEdge: startNewEdge,
      topological: topological,
      destructive: destructive,
      edgeStyle: edgeStyle,
    );
  }

  List<Intersection> get intersections {
    if (_end == null) return [];
    final cubic = this.cubic;

    final selfIntersection = cubic.selfIntersect();

    final intersections = editor.bundle.intersections.withCubic(cubic);
    return [
      ?selfIntersection,
      ...intersections.values.expand((e) => e.intersections),
    ];
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

  TransientEdge? commit(
    TransientEdge edge, {
    SceneHitResult? endHitTest,
    bool startNewEdge = false,
    bool topological = true,
    bool destructive = true,
    EdgeStyle edgeStyle = .default_,
  }) {
    final newEdges = edge._performCommit(
      endHitTest,
      topological: topological,
      destructive: destructive,
      edgeStyle: edgeStyle,
    );
    remove(edge);

    if (startNewEdge && newEdges.isNotEmpty) {
      final committedEdge = newEdges.last;
      final end = editor.bundle.edgeEnd(editor.handleOf(committedEdge)!).ref(editor.bundle);
      final cEnd = edge.cEnd ?? edge.end!;
      final cStart = edge.nextCStart ?? cEnd.pointReflect(edge.end!);
      return create(end, cStart: cStart, mergeKey: Object());
    }

    return null;
  }

  void remove(TransientEdge edge) {
    instances.remove(edge);
    notifyListeners();
  }
}
