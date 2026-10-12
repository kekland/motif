import 'package:css/css.dart' as css;

part 'src/math.dart';
part 'src/geometry.dart';
part 'src/nodes.dart';
part 'src/style.dart';

final class const Document({
  required final double width,
  required final double height,
  required final ViewBox viewBox,
  required final List<Node> children,
});

final class const ViewBox({
  required final double x,
  required final double y,
  required final double width,
  required final double height,
});
