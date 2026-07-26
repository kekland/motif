part of 'core.dart';

class RenderSceneWidget extends SingleChildRenderObjectWidget {
  const RenderSceneWidget({super.key, required this.scene, super.child});

  final Scene scene;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderScene(scene: scene);
  }

  @override
  void updateRenderObject(BuildContext context, RenderScene renderObject) {
    renderObject.scene = scene;
  }
}

class RenderScene extends RenderSceneObject {
  RenderScene({required this._scene}) : super(object: _scene.root);

  Scene _scene;
  Scene get scene => _scene;
  set scene(Scene value) {
    if (_scene == value) return;
    _scene = value;
    object = _scene.root;
    markNeedsLayout();
  }

  // dart format off
  @override RootObject get object => super.object as RootObject;
  // dart format on

  // final _nodes = <SceneNode, RenderSceneNode>{};

  // void _registerNode(RenderSceneNode renderNode) {
  //   final node = renderNode.node;
  //   assert(_nodes[node] == null, 'node is already registered.');
  //   _nodes[node] = renderNode;
  // }

  // void _unregisterNode(RenderSceneNode renderNode) {
  //   final node = renderNode.node;
  //   assert(_nodes[node] != null, 'node is not registered.');
  //   _nodes.remove(node);
  // }

  // RenderSceneNode getRenderNode(SceneNode node) {
  //   if (node is EdgeKnotControlPoint) {
  //     final edge = node.edge;
  //     return getRenderNode(edge);
  //   } else if (node is EdgeKnot) {
  //     final edge = node.parent;
  //     return getRenderNode(edge);
  //   }

  //   final renderNode = _nodes[node];
  //   assert(renderNode != null, 'node is not registered.');
  //   return renderNode!;
  // }

  @override
  void performLayout() {
    size = constraints.biggest;
    child!.layout(constraints);
    _maybeSortChildrenList();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void reassemble() {
    scene.reassemble();
    super.reassemble();
  }
}
