import 'dart:typed_data';

import 'package:vector/imports.dart';
import 'package:vgc/vector_complex.dart';

part 'controller/transient_strokes.dart';

class VectorController extends Controller {
  VectorController() : super(logger: Logger('VectorController'));

  static VectorController of(BuildContext context) => context.read<VectorController>();
  static VectorController watch(BuildContext context) => context.watch<VectorController>();

  final canvasKey = GlobalKey();

  final artworkKey = GlobalKey();
  RenderBox? get artworkRender => artworkKey.currentContext?.findRenderObject() as RenderBox?;
  Offset globalToArtworkLocal(Offset point) => artworkRender!.globalToLocal(point);

  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final complex = $customDisposable(VectorComplex(), (v) => v.dispose());
  late final transientStrokes = $customDisposable(TransientStrokes(), (v) => v.dispose());
}
