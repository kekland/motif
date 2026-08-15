import 'package:editor/imports.dart';

export 'cursor/cursor_tool.dart';
export 'marquee/marquee_tool.dart';
export 'fill/fill_tool.dart';
export 'pen/pen_tool.dart';
export 'container/container_tool.dart';
export 'rectangle/rectangle_tool.dart';

const toolset = <Tool>[
  CursorTool(),
  MarqueeTool(),
  PenTool(),
  FillTool(),
  ContainerTool(),
  RectangleTool(),
];
