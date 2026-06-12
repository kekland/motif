import 'package:color/color.dart';
import 'package:geometry/geometry.dart';
import 'package:vector/imports.dart';
import 'package:vector_math/vector_math_64.dart';

part 'controller/stroke_properties.dart';
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
  Offset artworkLocalToGlobal(Offset point) => artworkRender!.localToGlobal(point);

  double computeScale() => artworkRender!.getTransformTo(null).getMaxScaleOnAxis();

  CellHitTestTolerance computeHitTestTolerance() {
    final transform = artworkRender!.getTransformTo(null);
    return .defaultTolerance.scaled(1 / transform.getMaxScaleOnAxis());
  }

  List<CellHitTestEntry> hitTestCells(Offset globalPosition, {CellHitTestTolerance? tolerance}) {
    final localPosition = globalToArtworkLocal(globalPosition);
    return artworkRender!.hitTestCells(localPosition, tolerance: computeHitTestTolerance());
  }

  CellHitTestEntry? hitTestCell(Offset globalPosition, {CellHitTestTolerance? tolerance}) {
    final localPosition = globalToArtworkLocal(globalPosition);
    return artworkRender!.hitTestCell(localPosition, tolerance: computeHitTestTolerance());
  }

  CellHitTestEntry? hitTestCellLocal(Offset localPosition, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return artworkRender!.hitTestCell(localPosition, tolerance: tolerance);
  }

  late final strokeProperties = $disposable(StrokeProperties());
  late final transientEdges = $disposable(TransientEdges(this));
  late final transientStrokes = $disposable(TransientStrokes(this));
  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final complex = $customDisposable(VectorComplex(), (v) => v.dispose());
  late final selection = $customDisposable(SelectionController(), (v) => v.dispose());
}
