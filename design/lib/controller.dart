import 'package:design/imports.dart';

class DesignController extends Controller {
  DesignController() : super(logger: Logger('DesignController'));

  static DesignController of(BuildContext context) => context.read<DesignController>();
  static DesignController watch(BuildContext context) => context.watch<DesignController>();

  final canvasKey = GlobalKey();
  RenderBox? get canvasRenderBox => canvasKey.currentContext?.findRenderObject() as RenderBox?;

  RenderRootNode? _renderRootNode;
  RenderRootNode get renderRootNode => _renderRootNode!;
  late final selection = $disposable(SelectionController());

  void onRootNodeCreated(RenderRootNode renderRootNode) {
    _renderRootNode = renderRootNode;
    selection.root = renderRootNode;
  }

  late final root = $disposable(
    MutableRootNode(
      children: [
        MutableContainerNode(
          layout: .fixed(100.0, 100.0),
          name: 'red rectangle',
        ),
        MutableContainerNode(
          transform: .new(translation: Offset(150, 150)),
          layout: .fixed(100.0, 100.0),
          name: 'blue ellipse',
        ),
        MutableContainerNode(
          transform: .new(translation: Offset(300, 300)),
          layout: .fixed(200.0, 200.0),
          name: 'container 1',
          children: [
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              name: 'green rectangle',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              transform: .new(translation: Offset(100, 100)),
              name: 'yellow ellipse',
            ),
          ],
        ),
      ],
    ),
  );

  late final tool = $disposable(ToolController(initialToolset: toolset));

  final _globalKeyCache = <Node, GlobalKey>{};
  GlobalKey keyForNode(Node node) {
    return _globalKeyCache[node] ??= GlobalKey();
  }
}
