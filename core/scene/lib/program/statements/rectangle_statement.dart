part of '../program.dart';

final class RectangleStatement extends FrameStatement with LayoutBoxStatement {
  RectangleStatement({
    super.transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    super.parent,
    super.id,
  }) : size = size ?? .zero,
       shape = shape ?? .new();

  @override
  final LayoutSize size;

  final RectangleObjectShape shape;

  @override
  Iterable<Arg<Ref<CellHandle>>> get _args => [?parent];

  @override
  late final _products = [
    frame,
    ...topLeft.all,
    ...topRight.all,
    ...bottomRight.all,
    ...bottomLeft.all,
    top,
    right,
    bottom,
    left,
    face,
  ];

  @override
  ChildLayout get childLayout => .default_;

  @override
  Size2 get naturalSize => .zero();

  late final topLeft = RectangleCorner._for(id, #tl);
  late final topRight = RectangleCorner._for(id, #tr);
  late final bottomRight = RectangleCorner._for(id, #br);
  late final bottomLeft = RectangleCorner._for(id, #bl);

  late final top = EdgeRef(id, #top);
  late final right = EdgeRef(id, #right);
  late final bottom = EdgeRef(id, #bottom);
  late final left = EdgeRef(id, #left);
  late final face = FaceRef(id, #face);

  @override
  void performExecute(EvalContext context, Mat4 transform, Size2 size) {
    final txn = context.transaction;
    final parent = context.resolveOptional(this.parent);

    final frame = txn.addFrame(cellId('frame'), parent: parent, transform: transform, size: size);
    context.bind(this.frame, frame);
    _emitShape(context, frame, shape.produceTopology(size));
  }

  void _emitShape(EvalContext context, FrameHandle frame, ShapeTopology t) {
    final txn = context.transaction;

    final handles = <Symbol, CellHandle>{};

    final vHandles = <Symbol, VertexHandle>{};
    for (final (key, pos) in t.vertices) {
      final v = txn.addVertex(cellId(key.name), pos, parent: frame);
      vHandles[key] = v;
      handles[key] = v;
      context.bind(VertexRef(id, key), v);
    }

    final eHandles = <Symbol, EdgeHandle>{};
    for (final (key, s, e, t0, t1) in t.edges) {
      final start = vHandles[t.resolve(s)]!;
      final end = vHandles[t.resolve(e)]!;
      final edge = txn.addEdge(cellId(key.name), start, end, parent: frame, startTangent: t0, endTangent: t1);
      eHandles[key] = edge;
      handles[key] = edge;
      context.bind(EdgeRef(id, key), edge);
    }

    for (final entry in t.aliases.entries) {
      final key = entry.key, target = entry.value;
      final handle = handles[t.resolve(target)];
      if (handle == null) continue;

      final _ = switch (handle.kind) {
        .frame => context.bind(FrameRef(id, key), handle.asFrame),
        .vertex => context.bind(VertexRef(id, key), handle.asVertex),
        .edge => context.bind(EdgeRef(id, key), handle.asEdge),
        .face => context.bind(FaceRef(id, key), handle.asFace),
      };
    }

    final boundary = t.boundary.map((key) => eHandles[t.resolve(key)]!).toList();
    final faceHandle = txn.makeFace(cellId('face'), boundary, parent: frame);
    txn.setFrameClip(frame, faceHandle);

    context.bind(FaceRef(id, #face), faceHandle);
  }

  @override
  TransformResult routeTransform(TransformContext context, Symbol product) {
    return .absorbed(
      (transform) {
        final composed = transform * this.transform;

        final sx = composed.scaleX, sy = composed.scaleY;
        final oldSize = context.evaluation.layout!.of(id)!.size!;
        final newSize = oldSize.scale(sx, sy);

        return copyWith(
          transform: composed.withNormalizedScale(),
          size: .fixed(newSize.width, newSize.height),
        );
      },
      context.handle(frame),
    );
  }

  @override
  RectangleStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    FrameRef? parent,
  }) {
    return RectangleStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      parent: parent ?? this.parent?.ref,
      id: id,
    );
  }
}

extension type RectangleCorner._((VertexRef, VertexRef, VertexRef, EdgeRef) _) {
  RectangleCorner._for(StatementId id, Symbol base)
    : this._((
        VertexRef(id, base),
        VertexRef(id, base / 'a'),
        VertexRef(id, base / 'b'),
        EdgeRef(id, base / 'arc'),
      ));

  VertexRef get vertex => _.$1;
  VertexRef get a => _.$2;
  VertexRef get b => _.$3;
  EdgeRef get arc => _.$4;

  Iterable<Ref> get all => [vertex, a, b, arc];
}
