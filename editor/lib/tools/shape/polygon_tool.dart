import 'package:editor/imports.dart';

class const PolygonTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.polygon();

  @override
  String get key => 'polygon';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreatePolygonActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
