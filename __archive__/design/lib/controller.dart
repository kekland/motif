import 'package:design/imports.dart';

part 'controller/global_key_cache.dart';
part 'controller/transient_transforms.dart';

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
          layout: .fixed(400.0, 100.0, childLayout: NodeChildLayout.flex(direction: .row)),
          name: 'container 1',
          children: [
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .red,
              name: 'node 1',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .green,
              name: 'node 2',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .blue,
              name: 'node 3',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .red,
              name: 'node 4',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .green,
              name: 'node 5',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .blue,
              name: 'node 6',
            ),
          ],
        ),
        MutableContainerNode(
          transform: .new(translation: Offset(300, 400)),
          layout: .fixed(400.0, 100.0, childLayout: NodeChildLayout.flex(direction: .row)),
          name: 'container 1',
          children: [
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .red,
              name: 'node 1',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .green,
              name: 'node 2',
            ),
            MutableContainerNode(
              layout: .fixed(50.0, 50.0),
              fill: .blue,
              name: 'node 3',
            ),
            MutableTextNode(
              layout: .new(size: .contain()),
              spans: [
                .new('Hello, '),
                .new('world!', style: .new(color: .blue)),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  late final tool = $disposable(ToolController(initialToolset: toolset));
  late final globalKeyCache = $disposable(GlobalKeyCache());
  late final localTransientTransforms = $disposable(TransientTransforms());
  late final globalTransientTransforms = $disposable(TransientTransforms());
}
