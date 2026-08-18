import 'package:editor/imports.dart';

class const TriangleTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.polygon();

  @override
  String get key => 'triangle';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreateTriangleActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
