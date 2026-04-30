import 'dart:typed_data';

import 'package:vector/imports.dart';

part 'controller/transient_edges.dart';
part 'controller/transient_strokes.dart';
part 'controller/selection.dart';

class VectorController extends Controller {
  VectorController() : super(logger: Logger('VectorController'));

  static VectorController of(BuildContext context) => context.read<VectorController>();
  static VectorController watch(BuildContext context) => context.watch<VectorController>();

  final canvasKey = GlobalKey();

  final artworkKey = GlobalKey();
  RenderVectorComplex? get artworkRender => artworkKey.currentContext?.findRenderObject() as RenderVectorComplex?;
  Offset globalToArtworkLocal(Offset point) => artworkRender!.globalToLocal(point);

  List<CellHitTestEntry> hitTestCells(Offset globalPosition, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final localPosition = globalToArtworkLocal(globalPosition);
    return artworkRender!.hitTestCells(localPosition, tolerance: tolerance);
  }

  CellHitTestEntry? hitTestCell(Offset globalPosition, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final localPosition = globalToArtworkLocal(globalPosition);
    return artworkRender!.hitTestCell(localPosition, tolerance: tolerance);
  }

  late final transientEdges = $disposable(TransientEdges());
  late final transientStrokes = $disposable(TransientStrokes());
  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final complex = $customDisposable(VectorComplex(), (v) => v.dispose());
  late final selection = $customDisposable(SelectionController(), (v) => v.dispose());
}
