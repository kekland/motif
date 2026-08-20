part of '../program.dart';

sealed class ShapeStatement<S extends ObjectShape> extends PlacedStatement
    with LayoutBoxStatement
    implements FrameStatement {
  new({
    required this.shape,
    Mat4? transform,
    super.parent,
    super.id,
    LayoutSize? size,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
  }) : size = size ?? .zero,
       transform = transform ?? .identity();

  @override
  final LayoutSize size;

  @override
  final Mat4 transform;

  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;

  final S shape;

  @override
  Iterable<Arg<Ref<CellHandle>>> get _args => [?parent];

  @override
  late final _products = [frame, face, ...shape.produceRefs(id)];

  @override
  late final frame = Ref.frame(id, #frame);

  late final face = Ref.face(id, #face);

  @override
  ChildLayout get childLayout => .default_;

  @override
  Size2 get naturalSize => .zero();

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
      context.bind(.vertex(id, key), v);
    }

    final eHandles = <Symbol, EdgeHandle>{};
    for (final (key, s, e, t0, t1) in t.edges) {
      final start = vHandles[t.resolve(s)]!;
      final end = vHandles[t.resolve(e)]!;
      final edge = txn.addEdge(cellId(key.name), start, end, parent: frame, startTangent: t0, endTangent: t1);
      eHandles[key] = edge;
      handles[key] = edge;
      context.bind(.edge(id, key), edge, decoration: edgeStyle);
    }

    for (final entry in t.aliases.entries) {
      final key = entry.key, target = entry.value;
      final handle = handles[t.resolve(target)];
      if (handle == null) continue;

      final _ = switch (handle.kind) {
        .frame => context.bind(.frame(id, key), handle.asFrame),
        .vertex => context.bind(.vertex(id, key), handle.asVertex),
        .edge => context.bind(.edge(id, key), handle.asEdge),
        .face => context.bind(.face(id, key), handle.asFace),
      };
    }

    final boundary = t.boundary.map((key) => eHandles[t.resolve(key)]!).toList();
    final faceHandle = txn.makeFace(cellId('face'), boundary, parent: frame);
    txn.setFrameClip(frame, faceHandle);

    context.bind(face, faceHandle, decoration: faceStyle);
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
  ShapeStatement<S> copyWith({
    StatementId? id,
    Mat4? transform,
    LayoutSize? size,
    S? shape,
    FrameRef? parent,
    FaceStyle? faceStyle,
    EdgeStyle? edgeStyle,
  });
}
