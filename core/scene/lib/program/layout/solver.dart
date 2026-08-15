part of '../program.dart';

LayoutOverrides solveLayout(Iterable<LayoutBox> boxes) {
  final overrides = LayoutOverrides();

  for (final root in _buildForest(boxes)) {
    _measure(root);
    _arrange(root, root.natural, overrides, offset: null);
  }

  return overrides;
}

final class _Node {
  _Node(this.box);

  final LayoutBox box;
  final children = <_Node>[];

  var natural = Size2.zero();
  var size = Size2.zero();

  double resolve(LayoutDimension d, double measured, double available) => d.clamp(d.isExpand ? available : measured);

  Size2 resolveSize(Size2 available) => .new(
    resolve(box.size.width, natural.width, available.width),
    resolve(box.size.height, natural.height, available.height),
  );

  double resolveMain(FlexDirection dir, double available) => resolve(
    dir.mainOf(box.size),
    dir.mainOfSize(natural),
    available,
  );

  double resolveCross(FlexDirection dir, double available) => resolve(
    dir.crossOf(box.size),
    dir.crossOfSize(natural),
    available,
  );

  Size2 get orientedNatural => natural.transformed(box.transform);
  Size2 orientedSize(Size2 size) => size.transformed(box.transform);

  Vec2 transformShift(Size2 localSize) {
    final transform = box.transform.copy()..setTranslation(0, 0);
    final aabb = localSize.toAabb().transformed(transform);
    return aabb.min;
  }
}

List<_Node> _buildForest(Iterable<LayoutBox> boxes) {
  final nodes = <StatementId, _Node>{};
  for (final box in boxes) {
    assert(!nodes.containsKey(box.id), 'duplicate box id: ${box.id}');
    nodes[box.id] = _Node(box);
  }

  final roots = <_Node>[];
  for (final node in nodes.values) {
    final parentId = node.box.parentId;
    final parent = parentId == null ? null : nodes[parentId];
    if (parent == null) {
      roots.add(node);
    } else {
      parent.children.add(node);
    }
  }

  assert(_isAcyclic(nodes.values, roots), 'cycle detected in layout tree');
  return roots;
}

bool _isAcyclic(Iterable<_Node> all, List<_Node> roots) {
  var reachable = 0;
  final stack = [...roots];
  while (stack.isNotEmpty) {
    reachable++;
    stack.addAll(stack.removeLast().children);
  }
  return reachable == all.length;
}

void _measure(_Node node) {
  for (final c in node.children) _measure(c);

  final childLayout = node.box.childLayout;
  final content = switch (childLayout) {
    StackChildLayout() => _measureStack(node, childLayout),
    FlexChildLayout() => _measureFlex(node, childLayout),
  };

  final padding = childLayout.padding;
  node.natural = node.box.size.natural(content.inflate(padding.horizontal, padding.vertical));
}

void _arrange(_Node node, Size2 size, LayoutOverrides out, {required Vec2? offset}) {
  node.size = size;
  out.set(node.box.id, .new(offset: offset, size: size));
  if (node.children.isEmpty) return;

  final padding = node.box.childLayout.padding;
  final inner = size.deflate(padding.horizontal, padding.vertical);

  final placements = switch (node.box.childLayout) {
    StackChildLayout l => _placeStack(node, inner, l),
    FlexChildLayout l => _placeFlex(node, inner, l),
  };

  for (var i = 0; i < node.children.length; i++) {
    final c = node.children[i];
    final p = placements[i];
    if (p.offset != null) {
      _arrange(c, p.size!, out, offset: padding.origin + p.offset!);
    } else {
      _arrange(c, p.size!, out, offset: null);
    }
  }
}
