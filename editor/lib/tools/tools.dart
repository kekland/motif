import 'package:editor/imports.dart';

export 'cursor/cursor_tool.dart';
export 'marquee/marquee_tool.dart';
export 'fill/fill_tool.dart';
export 'pen/pen_tool.dart';
export 'shape/shape_tool.dart';
export 'shape/container_tool.dart';
export 'shape/rectangle_tool.dart';
export 'shape/circle_tool.dart';
export 'shape/triangle_tool.dart';

const toolset = <Tool>[
  CursorTool(),
  MarqueeTool(),
  PenTool(),
  FillTool(),
  ContainerTool(),
  RectangleTool(),
  CircleTool(),
  TriangleTool(),
];

const tools = (
  cursor: CursorTool(),
  marquee: MarqueeTool(),
  pen: PenTool(),
  fill: FillTool(),
  container: ContainerTool(),
  rectangle: RectangleTool(),
  circle: CircleTool(),
  triangle: TriangleTool(),
);