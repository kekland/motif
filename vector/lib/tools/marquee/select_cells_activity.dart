import 'package:flutter/gestures.dart';
import 'package:vector/imports.dart';

class SelectCellsActivity extends DragActivity {
  SelectCellsActivity({
    required this.controller,
    required this.onMarqueeRectChanged,
  });

  final VectorController controller;
  final void Function(Rect?) onMarqueeRectChanged;

  @override
  void onStart(PositionedGestureDetails details) {
    super.onStart(details);
    onMarqueeRectChanged(.fromPoints(details.localPosition, details.localPosition));
    controller.selection.clear();
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    onMarqueeRectChanged(.fromPoints(startDetails.localPosition, details.localPosition));

    final globalRect = Rect.fromPoints(
      startDetails.globalPosition,
      details.globalPosition,
    );
    
    final selection = controller.rectHitTestCells(globalRect);
    final objects = selection.map((p) => p.hitObject);
    controller.selection.setSelection(objects.toSet());
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);
    onMarqueeRectChanged(null);
  }
}
