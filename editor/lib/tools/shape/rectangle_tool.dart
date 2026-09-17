import 'package:editor/imports.dart';

class const RectangleTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.square();

  @override
  String get key => 'rectangle';

  @override
  String resolveName(BuildContext context) => 'Rectangle';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreateRectangleActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolRectangle;

  @override
  SingleActivator? get shortcut => .new(.keyR);
}
