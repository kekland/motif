part of '../../_program.dart';

/// Represents the object tree of the program.
final class ObjectTree with ChangeNotifier {
  ObjectTree(this.evaluation);
  final Evaluation evaluation;
  Bundle get bundle => evaluation.bundle;

  List<ObjectNode> get children => _children;
  List<ObjectNode> _children = [];

  int? indexOf(StatementId id) {
    final index = _children.indexWhere((node) => node.id == id);
    return index != -1 ? index : null;
  }

  ObjectNode? nodeOf(StatementId id) => _byId[id];
  ObjectNode? parentOf(StatementId id) => _byId[id]?._parent;

  /// Returns everything in [id]'s subtree (including itself).
  Iterable<ObjectNode> subtree(StatementId id) sync* {
    final node = nodeOf(id);
    if (node == null) return;
    yield node;
    for (final child in node.children) yield* subtree(child.id);
  }

  ObjectNode? of(StatementId id) {
    final node = _byId[id];
    if (node != null) return node;

    var evalNode = evaluation.nodeOf(id);
    while (evalNode != null) {
      final objectNode = nodeOf(evalNode.id);
      if (objectNode != null) return objectNode;
      evalNode = evalNode.parent;
    }

    return null;
  }

  final _byId = <StatementId, ObjectNode>{};
  final _byFrame = <FrameRef, ObjectNode>{};

  List<ObjectNode>? _flattened;
  Map<StatementId, int>? _flattenedIndices;

  List<ObjectNode> get flattened {
    if (_flattened == null) _computeFlattened();
    return _flattened!;
  }

  int? flattenedIndexOf(StatementId id) {
    if (_flattenedIndices == null) _computeFlattened();
    return _flattenedIndices?[id];
  }

  (int, int)? flattenedRangeOf(Iterable<StatementId> ids) {
    final indices = ids.map(flattenedIndexOf).whereType<int>().toList();
    if (indices.isEmpty) return null;
    final min = indices.reduce((a, b) => a < b ? a : b);
    final max = indices.reduce((a, b) => a > b ? a : b);
    return (min, max);
  }

  Iterable<ObjectNode> nodesInFlattenedRange(int start, int end) {
    return flattened.skip(start).take(end - start + 1);
  }

  void _computeFlattened() {
    final flattened = <ObjectNode>[];
    final indices = <StatementId, int>{};

    void walk(ObjectNode node) {
      indices[node.id] = flattened.length;
      flattened.add(node);

      for (final child in node.children) walk(child);
    }

    for (final child in children) walk(child);
    _flattened = flattened;
    _flattenedIndices = indices;
  }

  /// Resolves the subtree of child objects for the given parent node.
  List<ObjectNode> _buildSubtree(ObjectNode? parent) {
    final frame = parent != null ? parent.frame : FrameRef.root;
    if (frame == null) return [];

    final nodes = <StatementId, ObjectNode>{};

    for (final handle in bundle.frameChildren(bundle.frame(frame)!)) {
      final ref = handle.ref(bundle);
      final id = ref.statementId;
      if (parent != null && id == parent.id) continue;

      final statement = evaluation.statement(id)!;
      if (statement is! PlacedStatement) continue;

      final node = nodes.putIfAbsent(id, () {
        final n = _byId[id] ??= ObjectNode._(this, parent, id);
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

  void _onChanged(Iterable<CellRef> moved, Iterable<CellRef> deleted) {
    var changed = false;

    if (deleted.isNotEmpty) {
      _byId.removeWhere((id, _) => !evaluation.hasNode(id));
      _byFrame.removeWhere((_, n) => !evaluation.hasNode(n.id));
    }

    for (final ref in moved) {
      if (ref.kind != .frame) continue;

      if (ref.asFrame == .root) {
        final oldChildren = children;
        final newChildren = _buildSubtree(null);

        _children = newChildren;
        if (!listEquals(oldChildren, newChildren)) changed = true;
      } else {
        final node = _byFrame[ref.asFrame];
        if (node == null) continue;
        final oldChildren = node._children;
        final newChildren = _buildSubtree(node);
        node._children = newChildren;

        if (oldChildren == null || !listEquals(oldChildren, newChildren)) {
          changed = true;
        }
      }
    }

    if (!changed) return;
    _flattened = null;
    notifyListeners();
  }

  void onMovedFrames(Set<FrameRef> movedFrames) => _onChanged(movedFrames, .empty());
  void attach(Commit c) => _onChanged(c.moved, c.deleted);
  void detach(Commit c) => _onChanged(c.moved, c.added);
}

final class ObjectNode {
  ObjectNode._(this.tree, this._parent, this.id);

  final ObjectTree tree;
  final StatementId id;

  ObjectNode? get parent => _parent;
  ObjectNode? _parent;

  Statement get statement => tree.evaluation.statement(id)!;
  StatementId get root => tree.evaluation.rootOf(id);
  bool get generated => root != id;

  int get depth => parent != null ? parent!.depth + 1 : 1;

  /// If present, this is a frame that can host child objects.
  FrameRef? get frame => switch (statement) {
    FramedStatement(isLeaf: false, :final frame) => frame,
    _ => null,
  };

  bool get isLeaf => frame == null;

  var cells = <CellRef>[];

  List<ObjectNode> get children => !isLeaf ? (_children ??= tree._buildSubtree(this)) : const [];
  List<ObjectNode>? _children;

  List<ObjectNode> get _parentChildren => parent?._children ?? tree._children;
  int? get index => parent?._children?.indexOf(this) ?? tree.indexOf(id);

  ObjectNode? get siblingPrev {
    if (index == null) return null;
    if (index! > 0) return _parentChildren[index! - 1];
    return null;
  }

  ObjectNode? get siblingNext {
    if (index == null) return null;
    if (index! < (_parentChildren.length - 1)) return _parentChildren[index! + 1];
    return null;
  }
}
