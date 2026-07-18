import 'package:editor/imports.dart';

export 'widgets/editor.dart';

part 'modules/selection.dart';
part 'modules/transient_edge.dart';

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
  late final transientEdges = $disposable(TransientEdges(this));

  final sceneKey = GlobalKey();
  RenderScene get render => sceneKey.currentContext!.findRenderObject() as RenderScene;
  RenderSceneNode getRenderNode(SceneNode node) => render.getRenderNode(node);

  Vector2 globalToScene(Vector2 globalPosition) {
    return render.globalToLocal(globalPosition.offset).vec2;
  }

  Vector2 sceneToGlobal(Vector2 scenePosition) {
    return render.localToGlobal(scenePosition.offset).vec2;
  }

  Vector2 globalToLocal(SceneNode node, Vector2 globalPosition) {
    final scenePosition = globalToScene(globalPosition);
    return node.sceneToLocal(scenePosition);
  }

  Vector2 localToGlobal(SceneNode node, Vector2 localPosition) {
    final scenePosition = node.localToScene(localPosition);
    return sceneToGlobal(scenePosition);
  }

  SceneHitTestResult hitTestScene(Vector2 globalPosition) {
    final localPosition = globalToScene(globalPosition);
    final transform = render.getTransformTo(null);
    return scene.hitTest(localPosition, globalToLocal: transform);
  }

  SceneHitTestResult hitTestRect(Rect globalRect, {HitTestRectMode mode = .normal}) {
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
