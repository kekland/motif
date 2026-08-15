part of 'core.dart';

/// A scene node is a fundamental element in the scene graph.
///
/// Scene nodes, by default, only contain a name and an identifier.
///
/// The root scene node is unique and is always present in the scene graph. Other scene nodes can either be objects or
/// topological cells. Objects can also be topological, meaning that they will produce topological cells when they are
/// laid out. Topological cells are used to represent the topology of the scene, and they can be used to create complex
/// shapes or relationships between objects.
abstract interface class SceneNode {
  SceneNode() {
    _initialize();
  }

  /// Identifier of the node. This is guaranteed to be unique once the node is attached to the scene graph.
  NodeId get id;

  /// The name of the node. It's generated automatically, but can be supplied with a user-generated name later.
  String get name;
  set name(String? value);

  /// The type of the node.
  NodeType get type;

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Scene attachment and initialization
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Initializes this node. This is called when the node is created, and it is used to perform any additional
  /// setup.
  void _initialize();

  /// Attaches this node and its children to the scene.
  void _attachToScene(Scene scene);

  /// Detaches this node and its children from the scene.
  void _detachFromScene();

  /// Whether the node is attached to a scene.
  bool get isAttached;

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Scene graph relationships
  // @-----------------------------------------------------------------------------------------------------------------@

  /// The parent of the scene node. This is null either if:
  /// - The node is the root node of the scene graph.
  /// - The node is not attached to the scene graph.
  SceneNode? get parent;

  /// Sets the parent of the scene node. Setting it to `null` will detach the node from the scene graph.
  set parent(covariant SceneNode? value);

  /// Detaches the node from the scene graph. This is equivalent to `parent = null`.
  void detach();

  /// List of children of the scene node. Not all nodes can contain children, so this list is exposed in the subclasses
  /// that can contain children.
  List<SceneNode> get children;

  /// List of topological cells that are children of this node.
  Iterable<Cell> get cells;

  /// The owner of this scene node. The owner creates this node during its layout process. Usually the owner is a
  /// [TopologicalSceneObject] that creates cells during its layout.
  SceneNode? get owner;

  /// Whether the node is owned by another node. See [owner] for more information.
  bool get isOwned;

  void _setParent(SceneNode? parent);
  void _addChild(SceneNode child);
  void _insertChild(int index, SceneNode child);
  void _removeChild(SceneNode child);
  void _insertChildren(int index, Iterable<SceneNode> children);

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Tree traversal
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Depth of this node in the scene graph. The root node has a depth of `0`.
  int get depth;

  /// Whether this node is an ancestor of the given [node].
  bool isAncestorOf(SceneNode node);

  /// Whether this node is a descendant of the given [node].
  bool isDescendantOf(SceneNode node);

  /// Lowest common ancestor of this node and [other].
  SceneNode lca(SceneNode other);

  /// Whether this node is a virtual ancestor of the given [node]. Virtual ancestry respects the ownership of the nodes,
  /// meaning that if a node is owned by another node, it is considered a virtual descendant of that owner, i.e.:
  ///
  /// Node X owns 4 vertices (A, B, C, D). Node Y is a parent of Node X. Then:
  /// - A, B, C, D are virtual descendants of Y, but not descendants of Y.
  /// - Y is an ancestor of X, A, B, C, D.
  bool isVirtualAncestorOf(SceneNode node);

  /// Whether this node is a virtual descendant of the given [node]. See [isVirtualAncestorOf] for more information.
  bool isVirtualDescendantOf(SceneNode node);

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Invalidation and updates
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Whether this node needs to be laid out.
  bool get needsLayout;
  set _needsLayout(bool value);

  /// Marks this node as needing an update. The update type is specified by the [aspects] parameter.
  void _markNeedsUpdate(Set<NodeUpdateAspect> aspects);

  /// Marks this node as needing a layout update because of a specific [aspect].
  void _markNeedsLayout([NodeUpdateAspect? aspect]);

  /// Flushes this node's update flags into listeners.
  void _$flushUpdates(SceneNodeNotifier notifier);

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Layout and transformation
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Bounding box of the node in its local coordinate space. Only valid after layout.
  Aabb2 get bbox;

  /// Whether this node is a layout boundary. Layout boundaries are used to limit the bubbling of layout invalidation.
  bool get isLayoutBoundary;

  /// Constraints used to layout this node.
  LayoutConstraints? get constraints;
  set constraints(LayoutConstraints value);

  /// Performs the actual layout of this node. This should be implemented by subclasses to perform their layout logic.
  void performLayout(covariant LayoutConstraints constraints);

  /// Lays out this node and its children. This is called during the layout phase of the scene.
  /// 
  /// Constraints can be optionally supplied to override the last constraints used to layout this node.
  void layout([covariant LayoutConstraints? constraints]);

  /// Relayouts this node with the same constraints as the last layout.
  /// 
  /// This is similar to a reflow.
  void relayout();

  /// Whether this node's transformation is controlled by its parent. If true, the node's transformation is computed
  /// in the parent's layout process.
  bool get isTransformControlled;

  /// Applies a transformation to this node.
  void applyTransform(Matrix4 transform);

  /// Returns the transformation to a given node in the scene graph. If [target] is `null`, returns the transformation
  /// to the root node.
  Matrix4 getTransformTo(SceneNode? target);

  /// Cascades/multiplies the node's own transformation into the given [transform] matrix.
  void cascadeTransform(Matrix4 transform);

  /// Returns the paint-level transformation to a given node in the scene graph. If [target] is `null`, returns the
  /// transformation to the root node.
  Matrix4 getPaintTransformTo(SceneNode? target);

  /// Cascades/multiplies the node's own transformation into the given [transform] matrix.
  ///
  /// This is different from [cascadeTransform] in that it also applies the transient transformations.
  void cascadePaintTransform(Matrix4 transform);

  /// Transforms a point given in [ancestor]'s coordinate space into the local coordinate space.
  Vector2 sceneToLocal(Vector2 globalPosition, {SceneNode? ancestor});

  /// Transforms a point given in local coordinate space into [ancestor]'s coordinate space.
  Vector2 localToScene(Vector2 localPosition, {SceneNode? ancestor});

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Transient transformations
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Returns the transient transformation of this node. Transient transformations are temporary transformations that
  /// are only applied to the node during the rendering phase.
  ///
  /// Returns `null` if there is no transient transformation applied to this node (same as an identity transformation).
  TransientTransform? get transientTransform;
  set transientTransform(TransientTransform? value);

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Hit testing
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Performs a hit test on this node and its children. Returns [true] if the hit test was successful.
  ///
  /// [globalToScene] is the transformation from the screen-space to the scene-space. This is used to adjust the
  /// hit-test tolerance values for zero-size objects (e.g. vertices) based on the current zoom level of the scene.
  bool hitTest(
    SceneHitTestResult result,
    Vector2 localPosition, {
    Matrix4? globalToScene,
    List<SceneNode> ignore = const [],
  });

  /// Returns [true] if this node is hit by the given [localPosition]. Called by [hitTest].
  bool hitTestSelf(Vector2 localPosition, {Matrix4? globalToScene});

  /// Performs a rectangular hit test on this node and its children. Returns [true] if the hit test was successful.
  ///
  /// Rectangular hit testing is like a marquee selection. The [mode] parameter controls how to interpret total
  /// containment vs partial overlap of the node's bounding box.
  bool hitTestRect(SceneHitTestResult result, Aabb2 localRect, {HitTestRectMode mode = .normal});

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Snapshotting
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Creates a snapshot of this node. Snapshots are lightweight representations of the node's own state at a given
  /// point in time.
  NodeSnapshot snapshot();

  /// Applies a snapshot to this node. This is used to restore the node's state from a snapshot.
  void applySnapshot(covariant NodeSnapshot snapshot);

  // @-----------------------------------------------------------------------------------------------------------------@
  //    Other stuff
  // @-----------------------------------------------------------------------------------------------------------------@

  /// Returns a notifier that can be used to listen to changes in this node.
  ChangeNotifier call([NodeUpdateAspect aspect = .all]);
}
