import 'package:editor/imports.dart';

class const CircleTool() extends ShapeTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.circle();

  @override
  String get key => 'circle';

  @override
  CreateShapeActivity Function(Editor editor) get activityFactory => CreateCircleActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;
}
