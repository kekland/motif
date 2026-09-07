part of '../program.dart';

sealed class ObjectShape {
  const ObjectShape();

  static const default_ = ObjectShape.rectangle();

  const factory ObjectShape.rectangle() = RectangleObjectShape;

  FrameRef frameOf(StatementId id) => id.cell<FrameHandle>(.frame, frameTag);
  FaceRef faceOf(StatementId id) => id.cell<FaceHandle>(.face, faceTag);

  int get frameTag => 0;
  int get faceTag;

  Iterable<Op> execute(
    EvalContext context,
    Mat4 transform,
    Size2 size, {
    FrameRef? parent,
    VertexStyle vertexStyle = .default_,
    EdgeStyle edgeStyle = .default_,
    FaceStyle faceStyle = .default_,
  }) {
    final builder = ShapeBuilder(context, vertexStyle: vertexStyle, edgeStyle: edgeStyle, faceStyle: faceStyle);
    final frame = builder.frame(transform, size: size, parent: parent);
    performProduce(builder, size, frame);
    return builder.ops;
  }

  void performProduce(ShapeBuilder builder, Size2 size, FrameRef frame);
}

final class ShapeBuilder {
  ShapeBuilder(
    this.context, {
    this.vertexStyle = .default_,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
  });

  final EvalContext context;
  final VertexStyle vertexStyle;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final ops = <Op>[];

  CellRef<H> _next<H extends CellHandle>(CellKind kind, Op op, {CellStyle? style}) {
    final ref = context.id.cell<H>(kind, ops.length);
    ops.add(op);
    if (style != null) context.style(ref, style);
    return ref;
  }

  FrameRef frame(Mat4 transform, {Size2? size, FrameRef? parent}) => _next(
    .frame,
    AddFrameOp(transform, size: size, parent: parent),
  );

  VertexRef vertex(Vec2 position, {FrameRef? parent}) => _next(
    .vertex,
    AddVertexOp(position, parent: parent),
    style: vertexStyle,
  );

  EdgeRef edge(
    VertexRef start,
    VertexRef end, {
    Vec2? startTangent,
    Vec2? endTangent,
    FrameRef? parent,
  }) => _next(
    .edge,
    AddEdgeOp(start, end, startTangent: startTangent, endTangent: endTangent, parent: parent),
    style: edgeStyle,
  );

  FaceRef face(List<EdgeRef> edges, {FrameRef? parent}) => _next(
    .face,
    MakeFaceOp(edges, parent: parent),
    style: faceStyle,
  );
}
