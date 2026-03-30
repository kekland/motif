import 'package:ui/ui.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';

final _c = assets.cursors;
final _pointerHotSpot = Offset(10, 10);
const _steps = 64;

class Cursors {
  static final toolCursor = VectorGraphicsMouseCursor(loader: _c.toolCursor, hotSpot: _pointerHotSpot);
  static final toolMove = VectorGraphicsMouseCursor(loader: _c.toolMove, hotSpot: _pointerHotSpot);
  static final toolMarquee = VectorGraphicsMouseCursor(loader: _c.toolMarquee, hotSpot: _pointerHotSpot);
  static final toolRectangle = VectorGraphicsMouseCursor(loader: _c.toolRectangle);
  static final toolEllipse = VectorGraphicsMouseCursor(loader: _c.toolEllipse);
  static final toolContainer = VectorGraphicsMouseCursor(loader: _c.toolContainer);

  static final resize = RotatingMouseCursor.vg(loader: _c.resize, steps: _steps);
  static final rotate = RotatingMouseCursor.vg(loader: _c.rotate, steps: _steps);
}
