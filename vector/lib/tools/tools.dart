import 'package:vector/imports.dart';

export 'bend/bend_tool.dart';
export 'cursor/cursor_tool.dart';
export 'eraser/eraser_tool.dart';
export 'fill/fill_tool.dart';
export 'pen/pen_tool.dart';
export 'pencil/pencil_tool.dart';
export 'marquee/marquee_tool.dart';
export 'weight/weight_tool.dart';

const List<Tool> toolset = [
  CursorTool(),
  MarqueeTool(),
  PenTool(),
  PencilTool(),
  EraserTool(),
  FillTool(),
  WeightTool(),
  BendTool(),
];
