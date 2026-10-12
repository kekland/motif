part of '../_program.dart';

final class LayoutTree {
  LayoutTree(this._evaluation);
  final Evaluation _evaluation;

  final _nodes = <StatementId, LayoutNode>{};
  final _children = <StatementId, List<LayoutNode>>{};
  final _dirty = <LayoutNode>{};
  bool get isDirty => _dirty.isNotEmpty;

  Layout? layoutOf(StatementId id) => _nodes[id]?.layout;
  Placement? placementOf(StatementId id) => _nodes[id]?.placement;

  LayoutNode? _parentOf(LayoutNode n) {
    final p = n.box.parentId;
    if (p == null) return null;
    final parent = _nodes[p];
    if (parent == null) return null;

    assert(parent.box is LayoutContainer, 'parent of ${n.box.id} is not a container');
    return parent;
  }

  Iterable<StatementId> ancestorsOf(StatementId id) sync* {
    var current = _nodes[id];
    while (current != null) {
      final parent = _parentOf(current);
      if (parent == null) break;
      yield parent.box.id;
      current = parent;
    }
  }

  @pragma('vm:prefer-inline')
  int compare(StatementId a, StatementId b) => _evaluation.evalOrder(a, b);

  List<LayoutNode> _childrenOf(LayoutNode n) {
    assert(n.box is LayoutContainer, 'node ${n.box.id} is not a container');
    return _children[n.box.id] ?? const [];
  }

  StatementId? parentOf(StatementId id) => _parentOf(_nodes[id]!)?.box.id;

  Iterable<StatementId> childrenOf(StatementId parent) {
    if (!_children.containsKey(parent)) return const [];
    return _children[parent]!.map((n) => n.box.id);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Attachment/detachment
  // -------------------------------------------------------------------------------------------------------------------

  void attachOrUpdate(EvalContext context, LayoutBox box) {
    if (_nodes.containsKey(box.id)) {
      update(context, box);
    } else {
      attach(context, box);
    }
  }

  void attach(EvalContext context, LayoutBox box) {
    final node = LayoutNode(box);
    _resolveNode(context, node);

    _nodes[box.id] = node;

    final parent = box.parentId;
    if (parent != null) _insertChild(parent, node);

    _dirty.add(node);
    _dirtyParent(node);
  }

  void detach(StatementId id) {
    final n = _nodes.remove(id);
    if (n == null) return;
    final parent = n.box.parentId;
    if (parent != null) _children[parent]!.remove(n);

    _dirtyParent(n);
    _dirty.remove(n);
    if (n is LayoutContainer) {
      for (final c in _childrenOf(n)) _dirty.add(c);
    }
  }

  void update(EvalContext context, LayoutBox box) {
    final n = _nodes[box.id]!;
    if (n.box.parentId != box.parentId) {
      detach(n.box.id);
      attach(context, box);
      return;
    }

    n.box = box;
    final parent = box.parentId;
    if (parent != null) {
      final siblings = _children[parent]!;
      final before = siblings.indexOf(n);
      siblings.removeAt(before);
      _insertChild(parent, n);
      if (siblings.indexOf(n) != before) _dirtyParent(n);
    }

    if (!LayoutBox.isLayoutEqual(context, n, box)) {
      _resolveNode(context, n);
      _dirty.add(n);
      _dirtyParent(n);
    }
  }

  void _resolveNode(EvalContext context, LayoutNode n) {
    final box = n.box;

    n.transform = box.transform;
    n.size = box.resolveSize(context);
    if (box is LayoutContainer) n.layout = box.resolveLayout(context);
  }

  void _insertChild(StatementId parent, LayoutNode child) {
    final siblings = _children.putIfAbsent(parent, () => []);
    final id = child.box.id;
    var at = siblings.length;
    for (var i = 0; i < siblings.length; i++) {
      if (compare(siblings[i].box.id, id) > 0) {
        at = i;
        break;
      }
    }

    siblings.insert(at, child);
  }

  void _dirtyParent(LayoutNode n) {
    final p = _parentOf(n);
    if (p != null) _dirty.add(p);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Measure
  // -------------------------------------------------------------------------------------------------------------------

  Size2 _measure(LayoutNode n) {
    final box = n.box;
    final intrinsic = box.intrinsicSize(_evaluation);
    n.intrinsicSize = intrinsic;
    if (box is! LayoutContainer) {
      return n.size.fit(intrinsic, intrinsic);
    }

    final layout = n.layout!;
    final children = _childrenOf(n);

    final content = switch (layout) {
      StackLayout l => _measureStack(children, intrinsic, l),
      FlexLayout l => _measureFlex(children, intrinsic, l),
    };

    final own = content.inflate(layout.padding.horizontal, layout.padding.vertical);
    return n.size.fit(own, own);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Solver
  // -------------------------------------------------------------------------------------------------------------------

  Map<StatementId, Placement> solve() {
    final changed = <StatementId, Placement>{};
    if (_dirty.isEmpty) return changed;

    final queue = SplayTreeSet<LayoutNode>((a, b) => compare(b.box.id, a.box.id));
    queue.addAll(_dirty);

    final replace = <LayoutNode>{..._dirty};
    while (queue.isNotEmpty) {
      final n = queue.first;
      queue.remove(n);

      final before = n.natural;
      n.natural = _measure(n);

      if (before != null && n.natural!.equals(before)) continue;
      final p = _parentOf(n);
      if (p != null) {
        replace.add(p);
        queue.add(p);
      } else {
        replace.add(n);
      }
    }

    final done = <LayoutNode>{};
    final work = replace.toList()..sort((a, b) => compare(a.box.id, b.box.id));
    for (final n in work) {
      if (!done.add(n)) continue;
      if (_parentOf(n) == null && n.placement?.size != n.natural) {
        n.placement = .new(null, n.natural!);
        changed[n.box.id] = n.placement!;
      }

      _placeChildren(n, replace, done, changed);
    }

    _dirty.clear();
    return changed;
  }

  void _placeChildren(
    LayoutNode n,
    Set<LayoutNode> replace,
    Set<LayoutNode> done,
    Map<StatementId, Placement> changed,
  ) {
    final box = n.box;
    if (box is! LayoutContainer) return;

    final children = _childrenOf(n);
    final placement = n.placement;
    if (children.isEmpty || placement == null) return;

    final layout = n.layout!;
    final inner = placement.size.deflate(layout.padding.horizontal, layout.padding.vertical);
    final placements = switch (layout) {
      StackLayout l => _placeStack(children, inner, l),
      FlexLayout l => _placeFlex(children, inner, l),
    };

    for (var i = 0; i < children.length; i++) {
      final c = children[i];
      final placement = placements[i];

      final moved = c.placement != placement;
      if (moved) {
        c.placement = placement;
        changed[c.box.id] = placement;
      }

      if ((moved || replace.contains(c)) && done.add(c)) _placeChildren(c, replace, done, changed);
    }
  }
}
