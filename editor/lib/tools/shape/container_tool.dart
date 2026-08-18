import 'package:editor/imports.dart';

class const ContainerTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.container();

  @override
  String get key => 'container';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreateContainerActivity.new;

  @override
  MouseCursor get cursor => Cursors.toolContainer;
}
