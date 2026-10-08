import 'dart:async';
import 'dart:math';

import 'package:editor/imports.dart';
import 'package:editor/widgets/tree_panel/tree_panel.dart';

final class const SceneNodeDraggable({
  super.key,
  required final StatementId id,
  required final SceneTreeController controller,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) => controller.onStartDrag(id, details),
      onVerticalDragUpdate: controller.onUpdateDrag,
      onVerticalDragEnd: controller.onEndDrag,
      child: child,
    );
  }
}

// final class const SceneNodeDrag({
//   super.key,
//   required final List<ObjectSceneNode> nodes,
//   required final Set<StatementId> selection,
//   required final Widget child,
// }) extends StatefulWidget {
//   @override
//   State<SceneNodeDrag> createState() => SceneNodeDragState();
// }

// class SceneNodeDragState extends State<SceneNodeDrag> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

final class SceneTreeController with ChangeNotifier, ChangeNotifierDisposable {
  SceneTreeController(this.editor, this.tree, this.selection, this.listKey) {
    $listen(tree, _recomputeTree);
    _recomputeTree();
  }

  final Editor editor;
  final SceneTree tree;
  final SceneSelection selection;
  final GlobalKey listKey;

  RenderBox get listRenderBox => listKey.currentContext!.findRenderObject() as RenderBox;

  var _expanded = <StatementId>{};
  set expanded(Set<StatementId> value) {
    if (setEquals(_expanded, value)) return;
    _expanded = value;
    notifyListeners();
  }

  final _nodes = <ObjectSceneNode>[];
  List<ObjectSceneNode> get nodes => _nodes;

  final _nodeIndices = <StatementId, int>{};
  int indexOf(StatementId id) => _nodeIndices[id] ?? -1;

  bool isExpanded(StatementId id) => _expanded.contains(id);

  void expand(StatementId id) {
    if (!_expanded.contains(id)) {
      _expanded.add(id);
      _recomputeTree();
      notifyListeners();
    }
  }

  void toggleExpanded(StatementId id) {
    if (_expanded.contains(id)) {
      _expanded.remove(id);
    } else {
      _expanded.add(id);
    }

    _recomputeTree();
    notifyListeners();
  }

  void _recomputeTree() {
    _nodes.clear();
    _nodeIndices.clear();

    void walk(ObjectSceneNode node) {
      _nodeIndices[node.id] = _nodes.length;
      _nodes.add(node);

      if (isExpanded(node.statement.id)) {
        for (final c in node.children.whereType<ObjectSceneNode>()) walk(c);
      }
    }

    for (final n in tree.root.children.whereType<ObjectSceneNode>()) walk(n);
    notifyListeners();
  }

  SceneTreeDragController? _dragController;
  SceneTreeDragController? get dragController => _dragController;

  void onStartDrag(StatementId id, DragStartDetails details) {
    if (_dragController != null) return;
    if (!selection.statements.contains(id)) selection.setStatement(id);
    _dragController = SceneTreeDragController(this, selection.statements);
    notifyListeners();
  }

  void onUpdateDrag(DragUpdateDetails details) {
    _dragController?.onUpdate(details);
  }

  void onEndDrag(DragEndDetails details) {
    _dragController?.onEnd(details);
    _dragController?.dispose();
    _dragController = null;
    notifyListeners();
  }

  void reorder(Set<StatementId> selection, SceneTreeDragAnchor anchor) {
    editor.edit((txn) {
      final node = tree.nodeOf(anchor.id)!;
      final targets = selection.map((id) => editor.productsOf(id)).expand((e) => e).toSet();
      final into = switch (anchor) {
        SceneTreeDragAnchorInside() => node.frame!,
        SceneTreeDragAnchorBefore() => node.parent!.frame!,
        SceneTreeDragAnchorAfter() => node.parent!.frame!,
      };

      final before = switch (anchor) {
        SceneTreeDragAnchorBefore() => node.id,
        SceneTreeDragAnchorAfter() => node.siblingNext?.id,
        SceneTreeDragAnchorInside() => null,
      };

      txn.reparent(targets, into, before: before);
    });
  }
}

sealed class const SceneTreeDragAnchor(final StatementId id) {
  const factory before(StatementId id) = SceneTreeDragAnchorBefore;
  const factory inside(StatementId id) = SceneTreeDragAnchorInside;
  const factory after(StatementId id) = SceneTreeDragAnchorAfter;

  bool get isBefore => this is SceneTreeDragAnchorBefore;
  bool get isInside => this is SceneTreeDragAnchorInside;
  bool get isAfter => this is SceneTreeDragAnchorAfter;

  @override
  String toString() => switch (this) {
    SceneTreeDragAnchorBefore(:final id) => 'before($id)',
    SceneTreeDragAnchorInside(:final id) => 'inside($id)',
    SceneTreeDragAnchorAfter(:final id) => 'after($id)',
  };
}

final class const SceneTreeDragAnchorBefore(super.id) extends SceneTreeDragAnchor {
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  bool operator ==(Object other) => other is SceneTreeDragAnchorBefore && other.id == id;
}

final class const SceneTreeDragAnchorInside(super.id) extends SceneTreeDragAnchor {
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  bool operator ==(Object other) => other is SceneTreeDragAnchorInside && other.id == id;
}

final class const SceneTreeDragAnchorAfter(super.id) extends SceneTreeDragAnchor {
  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  bool operator ==(Object other) => other is SceneTreeDragAnchorAfter && other.id == id;
}

final class SceneTreeDragController with ChangeNotifier, ChangeNotifierDisposable {
  SceneTreeDragController(this.controller, this.selection);

  final SceneTreeController controller;
  final Set<StatementId> selection;

  Timer? _expandHoveredTimer;
  StatementId? _expandHoveredTimerId;
  void _updateExpandHoveredTimer(StatementId id) {
    if (_expandHoveredTimer != null && _expandHoveredTimerId == id) return;
    _expandHoveredTimer?.cancel();
    _expandHoveredTimerId = id;
    _expandHoveredTimer = Timer(const Duration(milliseconds: 500), () {
      if (_anchor != .inside(_expandHoveredTimerId!)) return;
      controller.expand(id);
    });
  }

  SceneTreeDragAnchor? _anchor;
  SceneTreeDragAnchor? get anchor => _anchor;

  void _setAnchor(SceneTreeDragAnchor anchor) {
    if (_anchor == anchor) return;
    _anchor = anchor;
    notifyListeners();
  }

  void onUpdate(DragUpdateDetails details) {
    final position = controller.listRenderBox.globalToLocal(details.globalPosition);
    var index = position.dy / TreePanel.itemHeight;
    final depth = max(0, (position.dx / TreePanel.depthPadding).round());

    index = index.clamp(0.0, controller.nodes.length - 0.001);

    final nodeIndex = index.floor();
    final node = controller.nodes[nodeIndex];
    final offset = index - nodeIndex;

    if (!node.isLeaf) {
      if (offset < 0.2) {
        _setAnchor(_resolveGapAnchor(nodeIndex - 1, nodeIndex, depth));
      } else if (offset > 0.8) {
        _setAnchor(_resolveGapAnchor(nodeIndex, nodeIndex + 1, depth));
      } else {
        _setAnchor(.inside(node.id));
        _updateExpandHoveredTimer(node.id);
      }
    } else {
      if (offset < 0.5) {
        _setAnchor(_resolveGapAnchor(nodeIndex - 1, nodeIndex, depth));
      } else {
        _setAnchor(_resolveGapAnchor(nodeIndex, nodeIndex + 1, depth));
      }
    }
  }

  SceneTreeDragAnchor _resolveGapAnchor(int i, int j, int targetDepth) {
    if (i < 0) return .before(controller.nodes.first.id);

    final a = controller.nodes[i];

    if (j >= controller.nodes.length) {
      final clampedDepth = targetDepth.clamp(0, a.depth);
      return .after(_findAncestorAtDepth(a, clampedDepth).id);
    }

    final b = controller.nodes[j];
    final isAExpanded = controller.isExpanded(a.id) || a.children.isEmpty;

    if (!a.isLeaf && isAExpanded) return .before(b.id);
    final clampedDepth = targetDepth.clamp(b.depth, a.depth);

    return .after(_findAncestorAtDepth(a, clampedDepth).id);
  }

  ObjectSceneNode _findAncestorAtDepth(ObjectSceneNode node, int targetDepth) {
    var current = node;
    while (current.depth > targetDepth && current.parent is! RootSceneNode) {
      current = current.parent! as ObjectSceneNode;
    }
    return current;
  }

  void onEnd(DragEndDetails details) {
    if (_anchor != null) controller.reorder(selection, _anchor!);
  }
}

final class const SceneTreeDragAnchorWidget({
  super.key,
  required final SceneTreeController controller,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final dragController = useListenableSelector(controller, () => controller._dragController);
    if (dragController == null) return const SizedBox.shrink();

    return CustomPaint(
      painter: SceneTreeDragAnchorPainter(
        dragController: dragController,
        primaryColor: context.colors.accent.primary,
        secondaryColor: context.colors.accent.secondary,
      ),
    );
  }
}

final class SceneTreeDragAnchorPainter extends CustomPainter {
  SceneTreeDragAnchorPainter({
    required this.dragController,
    required this.primaryColor,
    required this.secondaryColor,
  }) : super(repaint: dragController);

  final SceneTreeDragController dragController;
  SceneTreeController get controller => dragController.controller;

  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final anchor = dragController.anchor;
    if (anchor == null) return;

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final secondaryPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    if (anchor.isInside) {
      // Draw a box around the node
      final node = controller.tree.nodeOf(anchor.id)!;
      final offset = Offset(0, controller.indexOf(node.id) * TreePanel.itemHeight);
      final rect = offset & Size(size.width, TreePanel.itemHeight);
      final rrect = RRect.fromRectAndRadius(rect.deflate(4.0), Radius.circular(4.0));

      canvas.drawRRect(rrect, paint);
    } else if (anchor.isBefore || anchor.isAfter) {
      final node = controller.tree.nodeOf(anchor.id)!;
      final nodeIndex = controller.indexOf(anchor.id);
      final depth = node.depth - 1;

      int index = controller.indexOf(node.id);

      if (anchor.isAfter) {
        while (index + 1 < controller.nodes.length && controller.nodes[index + 1].depth > node.depth) {
          index++;
        }
        index++;
      }

      final offset = Offset(depth * TreePanel.depthPadding + 6.0, index * TreePanel.itemHeight);
      final p1 = offset;
      final p2 = Offset(size.width, offset.dy);

      canvas.drawCircle(p1, 4.0, paint);
      canvas.drawLine(Offset(p1.dx + 4.0, p1.dy), p2, paint);

      // If the index differs from the node index, draw a box around the anchor
      if (index != nodeIndex + 1 && index != nodeIndex) {
        final offset = Offset(0, controller.indexOf(node.id) * TreePanel.itemHeight);
        final rect = offset & Size(size.width, TreePanel.itemHeight);
        final rrect = RRect.fromRectAndRadius(rect.deflate(4.0), Radius.circular(4.0));

        canvas.drawRRect(rrect, secondaryPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
