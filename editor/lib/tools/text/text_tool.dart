import 'package:editor/imports.dart';

class const TextTool() extends LayoutBoxTool {
  @override
  Widget buildIcon(BuildContext context) => Icons.text();

  @override
  String get key => 'text';

  @override
  String resolveName(BuildContext context) => 'Text';

  @override
  CreateLayoutBoxActivityFactory get activityFactory => CreateTextActivity.new;

  @override
  MouseCursor get cursor => Cursors.precise;

  @override
  SingleActivator? get shortcut => .new(.keyT);
}
