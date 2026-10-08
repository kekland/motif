part of 'scene.dart';

sealed class SceneNode {
  SceneNode._(this.tree, this._parent);

  final SceneTree tree;

  SceneNode? get parent => _parent;
  SceneNode? _parent;

  int get depth => parent != null ? parent!.depth + 1 : 0;

  FrameRef? get frame;
  bool get isLeaf => frame == null;

  List<CellRef> get cells;

  List<ObjectSceneNode> get children => !isLeaf ? (_children ??= tree._build(this)) : const [];
  List<ObjectSceneNode>? _children;

  int? get index => parent?._children?.indexOf(this as ObjectSceneNode);

  ObjectSceneNode? get siblingPrev {
    if (index == null) return null;
    if (index! > 0) return parent!._children![index! - 1];
    return null;
  }

  ObjectSceneNode? get siblingNext {
    if (index == null) return null;
    if (index! < (parent!._children!.length - 1)) return parent!._children![index! + 1];
    return null;
  }
}

final class RootSceneNode extends SceneNode {
  RootSceneNode._(SceneTree tree) : super._(tree, null);

  @override
  FrameRef get frame => .root;

  @override
  List<CellRef> get cells => const [];
}

final class ObjectSceneNode extends SceneNode {
  ObjectSceneNode._(super.tree, super.parent, this.id) : super._();

  final StatementId id;

  @override
  var cells = <CellRef>[];

  Statement get statement => tree.evaluation.statement(id)!;
  StatementId get object => tree.evaluation.rootOf(id);
  bool get derived => object != id;

  @override
  FrameRef? get frame => switch (statement) {
    FramedStatement(isLeaf: false, :final frame) => frame,
    _ => null,
  };
}

final class SceneTree with ChangeNotifier {
  SceneTree(this.scene) {
    root = ._(this);
    _byFrame[.root] = root;
    scene.evaluation.addUpdateListener(_update);
  }

  final Scene scene;
  Evaluation get evaluation => scene.evaluation;
  Bundle get bundle => scene.bundle;

  late final RootSceneNode root;

  List<ObjectSceneNode> get flattened {
    if (_flattened == null) _computeFlattened();
    return _flattened!;
  }

  List<ObjectSceneNode>? _flattened;
  Map<StatementId, int>? _flattenedIndices;

  int? indexOf(StatementId id) {
    if (_flattenedIndices == null) _computeFlattened();
    return _flattenedIndices?[id];
  }

  (int, int)? rangeOf(Iterable<StatementId> ids) {
    final indices = ids.map(indexOf).whereType<int>().toList();
    if (indices.isEmpty) return null;
    final min = indices.reduce((a, b) => a < b ? a : b);
    final max = indices.reduce((a, b) => a > b ? a : b);
    return (min, max);
  }

  Iterable<ObjectSceneNode> nodesInRange(int start, int end) {
    return flattened.skip(start).take(end - start + 1);
  }

  void _computeFlattened() {
    final flattened = <ObjectSceneNode>[];
    final indices = <StatementId, int>{};

    void walk(SceneNode node) {
      if (node is! ObjectSceneNode) return;
      indices[node.id] = flattened.length;
      flattened.add(node);

      for (final child in node.children) walk(child);
    }

    for (final child in root.children) walk(child);
    _flattened = flattened;
    _flattenedIndices = indices;
  }

  final _byFrame = <FrameRef, SceneNode>{};
  final _byId = <StatementId, ObjectSceneNode>{};
  ObjectSceneNode? nodeOf(StatementId id) => _byId[id];

  List<ObjectSceneNode> _build(SceneNode parent) {
    final frame = parent.frame!;
    final nodes = <StatementId, ObjectSceneNode>{};
    for (final handle in bundle.frameChildren(bundle.frame(frame)!)) {
      final ref = handle.ref(bundle);
      if (parent is ObjectSceneNode) {
        if (ref.statementId == parent.id) continue;
      }

      final id = ref.statementId;
      final node = nodes.putIfAbsent(ref.statementId, () {
        final ObjectSceneNode n;
        if (_byId[id] != null) {
          n = _byId[id]!;
        } else {
          n = ObjectSceneNode._(this, parent, id);
          _byId[id] = n;
        }

        n._parent = parent;
        n.cells = [];
        return n;
      });

      node.cells.add(ref);
    }

    for (final n in nodes.values) {
      if (n.frame != null) _byFrame[n.frame!] = n;
    }

    return nodes.values.toList();
  }

  void _update(EvalPass pass) {
    final frames = pass.movedFrames;

    if (pass.deleted.isNotEmpty) {
      _byId.removeWhere((id, _) => !evaluation.hasNode(id));
      _byFrame.removeWhere((f, n) => n is ObjectSceneNode && !evaluation.hasNode(n.id));
    }

    var changed = pass.deleted.isNotEmpty;
    for (final f in frames) {
      final node = _byFrame[f];
      final before = node?._children;
      if (node == null || before == null) continue;

      final after = _build(node);
      node._children = after;
      if (!listEquals(before, after)) changed = true;
    }

    if (!changed) return;
    _flattened = null;
    notifyListeners();
  }

  @override
  void dispose() {
    scene.evaluation.removeUpdateListener(_update);
    super.dispose();
  }
}
