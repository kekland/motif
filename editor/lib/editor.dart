import 'package:editor/imports.dart';

export 'widgets/editor.dart';

part 'modules/selection.dart';

final class Editor with ChangeNotifier, ChangeNotifierDisposable {
  Editor() {
    final r1 = RectangleObject(size: .fixed(100.0, 100.0));
    final r2 = RectangleObject(
      size: .fixed(50.0, 50.0),
      transform: .new(translation: .new(150.0, 150.0)),
    );

    scene.root.addChild(r1);
    scene.root.addChild(r2);

    final edge = Edge(r1.bottomRight, r2.topLeft);
    scene.root.addChild(edge);
  }

  static Editor of(BuildContext context) => context.read<Editor>();
  static Editor watch(BuildContext context) => context.watch<Editor>();

  late final scene = $disposable(Scene());
  late final selection = $disposable(SelectionController());
  late final tool = $disposable(ToolController(initialToolset: toolset));

  final sceneKey = GlobalKey();
  RenderScene get render => sceneKey.currentContext!.findRenderObject() as RenderScene;
  RenderSceneNode getRenderNode(SceneNode node) => render.getRenderNode(node);

  SceneHitTestResult hitTestScene(Offset globalPosition) {
    final localPosition = render.globalToLocal(globalPosition);
    final transform = render.getTransformTo(null)..invert();
    return scene.hitTest(.new(localPosition.dx, localPosition.dy), globalToLocal: transform);
  }

  SceneHitTestResult hitTestRect(Rect globalRect, {RectHitTestMode mode = .normal}) {
    final localRect = MatrixUtils.inverseTransformRect(render.getTransformTo(null), globalRect);
    return scene.hitTestRect(.minMax(localRect.topLeft.vec2, localRect.bottomRight.vec2), mode: mode);
  }
}

extension EditorBuildContextExtensions on BuildContext {
  Editor get editor => Editor.of(this);
  Scene get scene => editor.scene;
  SelectionController get selection => editor.selection;
  ToolController get tool => editor.tool;
}
