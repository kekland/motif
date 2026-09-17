import 'package:editor/imports.dart';

export 'options.dart';

export 'cursor/cursor_tool.dart';
export 'marquee/marquee_tool.dart';
export 'fill/fill_tool.dart';
export 'pen/pen_tool.dart';
export 'shape/shape_tool.dart';
export 'shape/container_tool.dart';
export 'shape/rectangle_tool.dart';
export 'shape/ellipse_tool.dart';
export 'shape/polygon_tool.dart';
export 'bend/bend_tool.dart';
export 'generator/generator_tool.dart';
export 'pencil/pencil_tool.dart';

const toolset = <Tool>[
  CursorTool(),
  MarqueeTool(),
  PenTool(),
  PencilTool(),
  BendTool(),
  FillTool(),
  ContainerTool(),
  RectangleTool(),
  EllipseTool(),
  PolygonTool(),
  GeneratorTool(),
];

const tools = (
  cursor: CursorTool(),
  marquee: MarqueeTool(),
  pen: PenTool(),
  pencil: PencilTool(),
  bend: BendTool(),
  fill: FillTool(),
  container: ContainerTool(),
  rectangle: RectangleTool(),
  ellipse: EllipseTool(),
  polygon: PolygonTool(),
  generator: GeneratorTool(),
);