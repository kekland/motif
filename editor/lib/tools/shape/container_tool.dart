import 'package:editor/imports.dart';

class const ContainerTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.container();

  @override
  String get key => 'container';

  @override
  String resolveName(BuildContext context) => 'Container';

  @override
  CreateShapeActivityFactory get activityFactory => CreateContainerActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolContainer;

  @override
  SingleActivator? get shortcut => .new(.keyC);
}
