import 'package:ui/ui.dart';
import 'package:stack_mouse_cursor/stack_mouse_cursor.dart';

final _c = assets.cursors;
final _pointerHotSpot = Offset(10, 10);
const _steps = 64;

class _PointerCursor extends VectorGraphicsMouseCursor {
  _PointerCursor({required super.loader}) : super(hotSpot: _pointerHotSpot);
}

class Cursors {
  static final toolCursor = _PointerCursor(loader: _c.toolCursor);
  static final toolMove = _PointerCursor(loader: _c.toolMove);
  static final toolMarquee = _PointerCursor(loader: _c.toolMarquee);
  static final toolRectangle = VectorGraphicsMouseCursor(loader: _c.toolRectangle);
  static final toolEllipse = VectorGraphicsMouseCursor(loader: _c.toolEllipse);
  static final toolContainer = VectorGraphicsMouseCursor(loader: _c.toolContainer);

  static final toolCursorVertex = _PointerCursor(loader: _c.toolCursorVertex);
  static final toolCursorKnot = _PointerCursor(loader: _c.toolCursorKnot);
  static final toolCursorControlPoint = _PointerCursor(loader: _c.toolCursorControlPoint);
  static final toolCursorEdge = _PointerCursor(loader: _c.toolCursorEdge);
  static final toolCursorFace = _PointerCursor(loader: _c.toolCursorFace);

  static final toolPenVertex = VectorGraphicsMouseCursor(loader: _c.toolPenVertex);
  static final toolPenEdge = VectorGraphicsMouseCursor(loader: _c.toolPenEdge);

  static final toolFill = VectorGraphicsMouseCursor(loader: _c.toolFill);

  static final resize = RotatingMouseCursor.vg(loader: _c.resize, steps: _steps);
  static final rotate = RotatingMouseCursor.vg(loader: _c.rotate, steps: _steps);
  static final precise = VectorGraphicsMouseCursor(loader: _c.precise);
}
