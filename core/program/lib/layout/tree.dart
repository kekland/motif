part of '../program.dart';

final class LayoutTree {
  LayoutTree(this._indexOf);

  final int? Function(StatementId) _indexOf;

  final _nodes = <StatementId, _LayoutNode>{};
  final _children = <StatementId, List<_LayoutNode>>{};
  final _dirty = <_LayoutNode>{};

  Placement placementOf(StatementId id) => _nodes[id]!.placement!;

  _LayoutNode? _parentOf(_LayoutNode n) {
    final p = n.box.parentId;
    if (p == null) return null;
    final parent = _nodes[p];
    if (parent == null) return null;

    assert(parent.box is LayoutContainer, 'parent of ${n.box.id} is not a container');
    return parent;
  }

  @pragma('vm:prefer-inline')
  int indexOf(StatementId id) => _indexOf(id)!;

  List<_LayoutNode> _childrenOf(_LayoutNode n) {
    assert(n.box is LayoutContainer, 'node ${n.box.id} is not a container');
    return _children[n.box.id] ?? const [];
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Attachment/detachment
  // -------------------------------------------------------------------------------------------------------------------

  void attachOrUpdate(LayoutBox box) {
    if (_nodes.containsKey(box.id)) {
      update(box);
    } else {
      attach(box);
    }
  }

  void attach(LayoutBox box) {
    final node = _LayoutNode(box);
    _nodes[box.id] = node;

    final parent = box.parentId;
    if (parent != null) _insertChild(parent, node);

    _dirty.add(node);
    _dirtyParent(node);
  }

  void detach(StatementId id) {
    final n = _nodes.remove(id)!;
    final parent = n.box.parentId;
    if (parent != null) _children[parent]!.remove(n);

    _dirtyParent(n);
    _dirty.remove(n);
    for (final c in _childrenOf(n)) _dirty.add(c);
  }

  void update(LayoutBox box) {
    final n = _nodes[box.id]!;
    if (n.box.parentId != box.parentId) {
      detach(n.box.id);
      attach(box);
      return;
    }

    n.box = box;
    _dirty.add(n);
    _dirtyParent(n);
  }

  void _insertChild(StatementId parent, _LayoutNode child) {
    final siblings = _children.putIfAbsent(parent, () => []);
    final index = indexOf(child.box.id);
    var at = siblings.length;
    for (var i = 0; i < siblings.length; i++) {
      if (indexOf(siblings[i].box.id) > index) {
        at = i;
        break;
      }
    }

    siblings.insert(at, child);
  }

  void _dirtyParent(_LayoutNode n) {
    final p = _parentOf(n);
    if (p != null) _dirty.add(p);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Measure
  // -------------------------------------------------------------------------------------------------------------------

  Size2 _measure(_LayoutNode n) {
    final box = n.box;
    if (box is! LayoutContainer) return box.size.fit(box.intrinsicSize, box.intrinsicSize);

    final layout = box.layout;
    final children = _childrenOf(n);

    final content = switch (layout) {
      StackLayout l => _measureStack(children, n.box.intrinsicSize, l),
      FlexLayout l => _measureFlex(children, n.box.intrinsicSize, l),
    };

    final own = content.inflate(layout.padding.horizontal, layout.padding.vertical);
    return n.box.size.fit(own, own);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // Solver
  // -------------------------------------------------------------------------------------------------------------------

  Map<StatementId, Placement> solve() {
    final changed = <StatementId, Placement>{};
    if (_dirty.isEmpty) return changed;

    final queue = SplayTreeSet<_LayoutNode>((a, b) => indexOf(b.box.id).compareTo(indexOf(a.box.id)));
    queue.addAll(_dirty);

    final replace = <_LayoutNode>{..._dirty};
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

    final done = <_LayoutNode>{};
    final work = replace.toList()..sort((a, b) => indexOf(a.box.id).compareTo(indexOf(b.box.id)));
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
    _LayoutNode n,
    Set<_LayoutNode> replace,
    Set<_LayoutNode> done,
    Map<StatementId, Placement> changed,
  ) {
    final box = n.box;
    if (box is! LayoutContainer) return;

    final children = _childrenOf(n);
    final placement = n.placement;
    if (children.isEmpty || placement == null) return;

    final layout = box.layout;
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
