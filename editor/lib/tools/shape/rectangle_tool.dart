import 'package:editor/imports.dart';

class const RectangleTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.square();

  @override
  String get key => 'rectangle';

  @override
  String resolveName(BuildContext context) => 'Rectangle';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreateRectangleActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolRectangle;

  @override
  SingleActivator? get shortcut => .new(.keyR);
}
