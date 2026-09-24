import 'package:editor/imports.dart';

class const PolygonTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.polygon();

  @override
  String get key => 'polygon';

  @override
  String resolveName(BuildContext context) => 'Polygon';

  @override
  CreateShapeActivityFactory get activityFactory => CreatePolygonActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
