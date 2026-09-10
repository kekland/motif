import 'package:editor/imports.dart';
import 'package:editor/widgets/handles/cell_handles_painters.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CellHandlesWidget extends LeafRenderObjectWidget {
  const CellHandlesWidget({
    super.key,
    required this.scene,
    required this.paintTransform,
    required this.primaryColor,
    required this.secondaryColor,
    this.refs = const {},
  });

  final Scene scene;
  final Matrix4 paintTransform;
  final Color primaryColor;
  final Color secondaryColor;
  final Set<Ref> refs;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CellHandlesRenderObject(
      scene: scene,
      paintTransform: paintTransform,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      refs: refs,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant CellHandlesRenderObject renderObject) {
    renderObject
      ..scene = scene
      ..paintTransform = paintTransform
      ..primaryColor = primaryColor
      ..secondaryColor = secondaryColor
      ..refs = refs;
  }
}

class CellHandlesRenderObject extends RenderBox {
  CellHandlesRenderObject({
    required this._scene,
    required this._paintTransform,
    required this._primaryColor,
    required this._secondaryColor,
    this._refs = const {},
  }) : _extendedRefs = {} {
    _updateChildList(_refs);
  }

  Scene _scene;
  Scene get scene => _scene;
  Bundle get bundle => scene.bundle;
  set scene(Scene value) {
    if (_scene == value) return;
    _scene = value;
    markNeedsPaint();
  }

  Set<Ref> _refs;
  Set<Ref> get refs => _refs;
  set refs(Set<Ref> value) {
    if (setEquals(_refs, value)) return;
    _updateChildList(value);
    _refs = value;
    markNeedsPaint();
  }

  Matrix4 _paintTransform;
  Matrix4 get paintTransform => _paintTransform;
  set paintTransform(Matrix4 value) {
    if (_paintTransform == value) return;
    _paintTransform = value;
    markNeedsPaint();
  }

  Color _primaryColor;
  Color get primaryColor => _primaryColor;
  set primaryColor(Color value) {
    if (_primaryColor == value) return;
    _primaryColor = value;
    markNeedsPaint();
  }

  Color _secondaryColor;
  Color get secondaryColor => _secondaryColor;
  set secondaryColor(Color value) {
    if (_secondaryColor == value) return;
    _secondaryColor = value;
    markNeedsPaint();
  }

  Set<Ref> _extendRefs(Set<Ref> refs) {
    final extendedRefs = <Ref>{};

    for (final ref in refs) {
      if (ref is CovertexRef) {
        extendedRefs.add(ref);
        extendedRefs.add(ref.resolveVertex(bundle));
      } else if (ref is CellRef) {
        final kind = ref.kind;

        if (kind == .vertex) {
          final handle = bundle.vertex(ref.asVertex)!;
          extendedRefs.add(ref);
          final covertices = bundle.vertexUses(handle).map((cv) => cv.ref(bundle));
          extendedRefs.addAll(covertices);
        } else if (kind == .edge) {
          final handle = bundle.edge(ref.asEdge)!;
          extendedRefs.add(ref);
          extendedRefs.addAll(bundle.cellDependencies(ref));
          final covertices = bundle.edgeCovertices(handle).map((cv) => cv.ref(bundle));
          extendedRefs.addAll(covertices);
        } else if (kind == .face) {
          extendedRefs.add(ref);
          extendedRefs.addAll(bundle.cellDependencies(ref));
        } else {
          final handle = bundle.frame(ref.asFrame)!;
          final children = bundle.frameChildren(handle).where((c) => c.kind != .frame);
          final childRefs = children.map((c) => c.ref(bundle));
          for (final r in childRefs) {
            extendedRefs.add(r);
            if (r.kind == .face) {
              extendedRefs.addAll(bundle.cellDependencies(r));
            }
          }
        }
      }
    }

    return extendedRefs;
  }

  void _updateChildList(Set<Ref> newCells) {
    final extendedNewCells = _extendRefs(newCells);

    final incoming = extendedNewCells.difference(_extendedRefs);
    final gone = _extendedRefs.difference(extendedNewCells);

    for (final ref in gone) {
      final child = _children.remove(ref);
      if (child == null) continue;
      dropChild(child);
      child.dispose();
      _refArray(ref).remove(child);
    }

    for (final ref in incoming) {
      final child = HandleRenderObject.create(ref);
      adoptChild(child);
      _children[ref] = child;
      _refArray(ref).add(child);
    }

    _extendedRefs = extendedNewCells;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    for (final child in _children.values) child.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    for (final child in _children.values) child.detach();
  }

  @override
  void redepthChildren() {
    _children.values.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _faces.forEach(visitor);
    _edges.forEach(visitor);
    _covertices.forEach(visitor);
    _vertices.forEach(visitor);
  }

  Set<Ref> _extendedRefs;
  final Map<Object, HandleRenderObject> _children = {};
  final Set<VertexHandleRenderObject> _vertices = {};
  final Set<CovertexHandleRenderObject> _covertices = {};
  final Set<EdgeHandleRenderObject> _edges = {};
  final Set<FaceHandleRenderObject> _faces = {};

  Set<HandleRenderObject> _refArray(Ref ref) => switch (ref) {
    CovertexRef() => _covertices,
    CellRef(kind: .vertex) => _vertices,
    CellRef(kind: .edge) => _edges,
    CellRef(kind: .face) => _faces,
    _ => throw UnimplementedError('unsupported type: ${ref.runtimeType}'),
  };

  @override
  void performLayout() {
    size = constraints.biggest;
    for (final child in _children.values) child.layout(constraints, parentUsesSize: false);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);

    for (final face in _faces) context.paintChild(face, offset);
    for (final covertex in _covertices) covertex.paintTangent(context.canvas);
    for (final edge in _edges) context.paintChild(edge, offset);
    for (final covertex in _covertices) context.paintChild(covertex, offset);
    for (final vertex in _vertices) context.paintChild(vertex, offset);

    context.canvas.restore();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintTransform(
      transform: paintTransform,
      position: position,
      hitTest: (result, position) {
        for (final vertex in _vertices) {
          if (vertex.hitTest(result, position: position)) return true;
        }

        for (final covertex in _covertices) {
          if (covertex.hitTest(result, position: position)) return true;
        }

        for (final edge in _edges) {
          if (edge.hitTest(result, position: position)) return true;
        }

        return false;
      },
    );
  }
}

abstract class HandleRenderObject<R extends Ref> extends RenderBox implements MouseTrackerAnnotation {
  HandleRenderObject(this.ref);
  final R ref;
  var enabled = true;

  static HandleRenderObject create(Ref ref) => switch (ref) {
    CovertexRef() => CovertexHandleRenderObject(ref),
    CellRef(kind: .vertex) => VertexHandleRenderObject(ref as VertexRef),
    CellRef(kind: .edge) => EdgeHandleRenderObject(ref as EdgeRef),
    CellRef(kind: .face) => FaceHandleRenderObject(ref as FaceRef),
    _ => throw UnimplementedError('unsupported type: ${ref.runtimeType}'),
  };

  @override
  CellHandlesRenderObject? get parent => super.parent as CellHandlesRenderObject?;

  Scene get scene => parent!.scene;
  Bundle get bundle => parent!.bundle;
  Matrix4 get paintTransform => parent!.paintTransform;
  Color get primaryColor => parent!.primaryColor;
  Color get secondaryColor => parent!.secondaryColor;

  @override
  PointerEnterEventListener? get onEnter => null;

  @override
  PointerExitEventListener? get onExit => null;

  @override
  bool get validForMouseTracker => true;

  @override
  MouseCursor get cursor => .defer;

  late ChangeNotifier _sceneNotifier;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _sceneNotifier = scene.notifier.forRef(ref);
    _sceneNotifier.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _sceneNotifier.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    performPaint(canvas);
  }

  void performPaint(Canvas canvas);
}

final class CovertexHandleRenderObject extends HandleRenderObject<CovertexRef> {
  CovertexHandleRenderObject(super.ref);

  late Vec2 vertexPosition;
  late Vec2 tangent;

  @override
  MouseCursor get cursor => Cursors.toolCursorControlPoint;

  @override
  void performLayout() {
    size = .square(8.0);
    _refresh();
  }

  void _refresh() {
    final cv = ref.resolve(bundle);
    if (cv == null) {
      enabled = false;
      return;
    }

    final vertex = bundle.covertexVertex(cv);
    vertexPosition = bundle.vertexPosition(vertex, space: .root);
    tangent = bundle.covertexTangent(cv, space: .root);
  }

  void paintTangent(Canvas canvas) {
    if (!enabled) return;
    if (tangent.isZero()) return;

    paintCovertexTangent(
      canvas,
      MatrixUtils.transformPoint(paintTransform, vertexPosition.offset),
      MatrixUtils.transformPoint(paintTransform, (vertexPosition + tangent).offset),
      secondaryColor,
    );
  }

  @override
  void performPaint(Canvas canvas) {
    if (!enabled) return;
    if (tangent.isZero()) return;

    paintCovertexHandle(
      canvas,
      MatrixUtils.transformPoint(paintTransform, (vertexPosition + tangent).offset),
      primaryColor,
      secondaryColor,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final distance = (vertexPosition + tangent).distanceTo(position.vec2);
    if (distance > 8.0) return false;
    result.add(BoxHitTestEntry(this, position));
    return true;
  }
}

final class VertexHandleRenderObject extends HandleRenderObject<VertexRef> {
  VertexHandleRenderObject(super.ref);

  late Vec2 position;

  @override
  void performLayout() {
    size = .square(8.0);
    _refresh();
  }

  void _refresh() {
    final handle = bundle.vertex(ref);
    if (handle == null) {
      enabled = false;
      return;
    }
    position = bundle.vertexPosition(handle, space: .root);
  }

  @override
  void performPaint(Canvas canvas) {
    if (!enabled) return;
    paintVertexHandle(
      canvas,
      MatrixUtils.transformPoint(paintTransform, position.offset),
      primaryColor,
      secondaryColor,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final distance = this.position.distanceTo(position.vec2);
    if (distance > 8.0) return false;
    result.add(BoxHitTestEntry(this, position));
    return true;
  }
}

final class EdgeHandleRenderObject extends HandleRenderObject<EdgeRef> {
  EdgeHandleRenderObject(super.ref);

  late Cubic2 cubic;

  @override
  void performLayout() {
    size = .zero;
    _refresh();
  }

  void _refresh() {
    final handle = bundle.edge(ref);
    if (handle == null) {
      enabled = false;
      return;
    }
    cubic = bundle.edgeCubic(handle, space: .root);
  }

  @override
  void performPaint(Canvas canvas) {
    if (!enabled) return;
    final cubic = this.cubic.transformed(.fromListFloat64(paintTransform.storage));

    paintEdgeHandle(
      canvas,
      cubic,
      primaryColor,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final closest = cubic.closestPoint(position.vec2);
    if (closest.distance > 8.0) return false;
    result.add(BoxHitTestEntry(this, closest.point.offset));
    return true;
  }
}

final class FaceHandleRenderObject extends HandleRenderObject<FaceRef> {
  FaceHandleRenderObject(super.ref);

  @override
  void performLayout() {
    size = .zero;
  }

  @override
  void performPaint(Canvas canvas) {}
}
