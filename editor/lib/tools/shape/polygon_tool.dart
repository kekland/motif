import 'package:editor/imports.dart';

class const PolygonTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.polygon();

  @override
  String get key => 'polygon';

  @override
  String resolveName(BuildContext context) => 'Polygon';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreatePolygonActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
