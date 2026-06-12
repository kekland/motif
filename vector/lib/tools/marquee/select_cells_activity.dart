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
  }

  @override
  void onUpdate(DragUpdateDetails details) {
    super.onUpdate(details);
    onMarqueeRectChanged(.fromPoints(startDetails.localPosition, details.localPosition));
  }

  @override
  void onEnd(DragEndDetails? details) {
    super.onEnd(details);
    onMarqueeRectChanged(null);
  }
}
