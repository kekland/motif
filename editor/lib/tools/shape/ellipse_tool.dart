import 'package:editor/imports.dart';

class const EllipseTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.circle();

  @override
  String get key => 'ellipse';

  @override
  String resolveName(BuildContext context) => 'Ellipse';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreateEllipseActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
