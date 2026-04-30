import 'package:vector/imports.dart';

export 'cursor/cursor_tool.dart';
export 'fill/fill_tool.dart';
export 'pen/pen_tool.dart';
export 'pencil/pencil_tool.dart';

const List<Tool> toolset = [CursorTool(), PenTool(), PencilTool(), FillTool()];
