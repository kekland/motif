import 'package:editor/imports.dart';

class const ContainerTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.container();

  @override
  String get key => 'container';

  @override
  String resolveName(BuildContext context) => 'Container';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreateContainerActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolContainer;

  @override
  SingleActivator? get shortcut => .new(.keyC);
}
