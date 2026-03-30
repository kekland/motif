import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:design/imports.dart';

class SelectNodesActivity extends DragActivity with ExclusiveCursorDragActivity {
  SelectNodesActivity({
    required this.root,
    required this.localRenderObject,
    required this.onMarqueeRectChanged,
    this.onSelectedNodesChanged,
  });

  final RenderRootNode root;
  final RenderObject localRenderObject;
  final ValueChanged<Rect?> onMarqueeRectChanged;
  final ValueChanged<List<Node>>? onSelectedNodesChanged;

  var _selectedNodes = <Node>[];

  @override
  MouseCursor get cursor => Cursors.toolMarquee;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    onMarqueeRectChanged(Rect.fromPoints(details.localPosition, details.localPosition));
    onSelectedNodesChanged?.call([]);
  }

  @override
  void onEnd(DragEndDetails? details) {
    onMarqueeRectChanged(null);
    super.onEnd(details);
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    final rect = Rect.fromPoints(startDetails.localPosition, details.localPosition);
    onMarqueeRectChanged(rect);

    final result = NodeHitTestResult();
    final transform = root.getTransformTo(localRenderObject);
    final transformedRect = MatrixUtils.inverseTransformRect(transform, rect);

    root.nodeHitTestRect(result, rect: transformedRect);
    final selectedNodes = result.path.map((e) => e.target.node).toList();
    if (listEquals(_selectedNodes, selectedNodes)) return;

    _selectedNodes = selectedNodes;
    onSelectedNodesChanged?.call(selectedNodes);

    super.onUpdate(details);
  }
}
