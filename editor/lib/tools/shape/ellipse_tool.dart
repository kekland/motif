import 'package:editor/imports.dart';

class const EllipseTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.circle();

  @override
  String get key => 'ellipse';

  @override
  String resolveName(BuildContext context) => 'Ellipse';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreateEllipseActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolEllipse;

  @override
  SingleActivator? get shortcut => .new(.keyE);
}
