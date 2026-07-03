import 'package:flutter/rendering.dart' hide Selectable;

import 'imports.dart';

part 'controller/selection.dart';
part 'controller/transient_edges.dart';
part 'controller/transient_strokes.dart';

class VectorController extends Controller {
  VectorController() : super(logger: Logger('VectorController'));

  static VectorController of(BuildContext context) => context.read<VectorController>();
  static VectorController watch(BuildContext context) => context.watch<VectorController>();

  final canvasKey = GlobalKey();
  final renderKey = GlobalKey();

  RenderBox get canvas => canvasKey.currentContext!.findRenderObject() as RenderBox;
  RenderVectorComplex get render => renderKey.currentContext!.findRenderObject() as RenderVectorComplex;

  double computeRenderScale() => render.getTransformTo(null).getMaxScaleOnAxis();
  CellHitTestTolerance computeHitTestTolerance() {
    final transform = render.getTransformTo(null);
    return .defaultTolerance.scaled(1 / transform.getMaxScaleOnAxis());
  }

  BoxHitTestEntry? hitTest(Offset globalPosition, {CellHitTestTolerance? tolerance}) {
    final localPosition = render.globalToLocal(globalPosition);

    final result = BoxHitTestResult();
    if (render.hitTest(result, position: localPosition, tolerance: computeHitTestTolerance())) {
      return result.path.last as BoxHitTestEntry;
    }

    return null;
  }

  CellHitTestEntry? hitTestCell(Offset globalPosition, {CellHitTestTolerance? tolerance}) {
    final localPosition = render.globalToLocal(globalPosition);
    return render.hitTestCell(localPosition, tolerance: computeHitTestTolerance());
  }

  List<CellHitTestEntry> hitTestCells(Offset globalPosition, {CellHitTestTolerance? tolerance}) {
    final localPosition = render.globalToLocal(globalPosition);
    return render.hitTestCells(localPosition, tolerance: computeHitTestTolerance());
  }

  List<CellHitTestEntry> rectHitTestCells(Rect globalRect, {CellHitTestTolerance? tolerance}) {
    final transform = render.getTransformTo(null);
    final localRect = MatrixUtils.inverseTransformRect(transform, globalRect);
    return render.rectHitTestCells(localRect);
  }

  late final complex = $disposable(VectorComplex(context: .new(generatorManager: generatorManager)));
  // late final symbolManager = $disposable(SymbolManager({}));
  late final generatorManager = $disposable(GeneratorManager());
  late final transientEdges = $disposable(TransientEdges(this));
  late final transientStrokes = $disposable(TransientStrokes(this));
  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final selection = $disposable(SelectionController());
}
