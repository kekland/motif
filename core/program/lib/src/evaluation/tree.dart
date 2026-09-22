part of '../_program.dart';

/// Represents the evaluation tree of [Statement]s within a program.
final class EvalTree {
  EvalTree(this._evaluation);
  final Evaluation _evaluation;

  final _nodes = <StatementId, EvalNode>{};
  EvalNode? operator [](StatementId id) => _nodes[id];

  EvalNode _nodeFor(Statement statement, EvalNode? parent) {
    final id = statement.id;
    var node = _nodes[id];
    if (node == null) {
      node = ._(statement, parent);
      _nodes[id] = node;
    } else {
      node.update(statement);
    }

    return node;
  }

  /// Returns the root node for the given statement, creating it if necessary.
  EvalNode root(Statement s) => _nodeFor(s, null);

  /// Adopts the given [produced] statements as children of the specified [node]
  List<EvalNode> adopt(EvalNode node, List<Statement> produced) {
    final children = <EvalNode>[];
    for (final p in produced) children.add(_nodeFor(p, node));
    assert(children.toSet().length == children.length);

    for (var i = 0; i < children.length; i++) children[i].index = i;
    node.lastProduced = node.statement;
    node.children = children;
    return children;
  }

  /// Removes [node] and its subtree.
  void remove(EvalNode node) {
    for (final c in node.children) remove(c);
    node.children.clear();
    node.markClean();
    _nodes.remove(node.id);
  }

  /// Returns the list of child nodes of [node] that are not present in the [produced] statements.
  List<EvalNode> difference(EvalNode node, List<Statement> produced) {
    final ids = produced.map((s) => s.id).toSet();
    final out = <EvalNode>[];
    for (final c in node.children) {
      if (!ids.contains(c.id)) out.add(c);
    }
    return out;
  }

  /// Returns [node] and everything in its subtree in evaluation order
  Iterable<EvalNode> subtree(EvalNode node) sync* {
    yield node;
    for (final child in node.children) yield* subtree(child);
  }

  /// Returns the IDs of [node] and all nodes in its subtree.
  Iterable<StatementId> subtreeIds(StatementId id) => subtree(_nodes[id]!).map((n) => n.id);

  /// Whether [a] is evaluated after [b].
  bool isAfter(EvalNode a, EvalNode b) => order(a, b) > 0;

  /// Returns the relative evaluation order of [a] and [b]
  int order(EvalNode a, EvalNode b) {
    if (a.root != b.root) return _evaluation.indexOf(a.root.id)!.compareTo(_evaluation.indexOf(b.root.id)!);
    var x = a, y = b;
    while (x.depth > y.depth) x = x.parent!;
    while (y.depth > x.depth) y = y.parent!;
    if (x == y) return a.depth.compareTo(b.depth);

    while (x.parent != y.parent) {
      x = x.parent!;
      y = y.parent!;
    }
    return x.index.compareTo(y.index);
  }
}

/// A [Statement]'s place in the evaluation tree.
///
/// The evaluation forms a tree, because statements can produce "child" statements.
final class EvalNode {
  EvalNode._(this.statement, this.parent) : children = [], index = 0 {
    markDirty();
  }

  Statement statement;
  StatementId get id => statement.id;

  final EvalNode? parent;
  late final EvalNode root = parent?.root ?? this;
  late final int depth = parent != null ? parent!.depth + 1 : 0;

  Commit? commit;

  List<EvalNode> children;
  int index;
  bool dirty = false;
  int dirtyBelow = 0;
  Statement? lastProduced;

  bool get childrenStale => !identical(lastProduced, statement);

  void update(Statement newStatement) {
    if (identical(statement, newStatement)) return;
    statement = newStatement;
    markDirty();
  }

  void markDirty() {
    if (dirty) return;
    dirty = true;
    for (var p = parent; p != null; p = p.parent) p.dirtyBelow++;
  }

  void markClean() {
    if (!dirty) return;
    dirty = false;
    for (var p = parent; p != null; p = p.parent) p.dirtyBelow--;
  }
}
