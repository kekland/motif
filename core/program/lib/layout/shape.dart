part of '../program.dart';

sealed class ObjectShape {
  const ObjectShape();

  static const default_ = ObjectShape.rectangle();

  const factory ObjectShape.rectangle() = RectangleObjectShape;

  FrameRef frameOf(StatementId id) => id.cell<FrameHandle>(.frame, frameTag);
  FaceRef faceOf(StatementId id) => id.cell<FaceHandle>(.face, faceTag);

  int get frameTag;
  int get faceTag;

  Iterable<Op> produce(StatementId id, Mat4 transform, Size2 size, FrameRef? parent) {
    final builder = ShapeBuilder(id);
    performProduce(builder, transform, size, parent);
    return builder.ops;
  }

  void performProduce(ShapeBuilder builder, Mat4 transform, Size2 size, FrameRef? parent);
}

final class ShapeBuilder(final StatementId id) {
  final ops = <Op>[];

  CellRef<H> _next<H extends CellHandle>(CellKind kind, Op op) {
    final ref = id.cell<H>(kind, ops.length);
    ops.add(op);
    return ref;
  }

  FrameRef frame(Mat4 transform, {Size2? size, FrameRef? parent}) => _next(
    .frame,
    AddFrameOp(transform, size: size, parent: parent),
  );

  VertexRef vertex(Vec2 position, {FrameRef? parent}) => _next(
    .vertex,
    AddVertexOp(position, parent: parent),
  );

  EdgeRef edge(VertexRef start, VertexRef end, {FrameRef? parent}) => _next(
    .edge,
    AddEdgeOp(start, end, parent: parent),
  );

  FaceRef face(List<EdgeRef> edges, {FrameRef? parent}) => _next(
    .face,
    MakeFaceOp(edges, parent: parent),
  );
}

final class RectangleObjectShape extends ObjectShape {
  const RectangleObjectShape();
  static const default_ = RectangleObjectShape();

  @override
  @override
  int get frameTag => 0;

  @override
  int get faceTag => 9;

  @override
  void performProduce(ShapeBuilder builder, Mat4 transform, Size2 size, FrameRef? parent) {
    final corners = [
      Vec2.zero(),
      Vec2(size.width, 0),
      Vec2(size.width, size.height),
      Vec2(0, size.height),
    ];

    final frame = builder.frame(transform, size: size, parent: parent);

    final v = [
      for (final c in corners) builder.vertex(c, parent: frame),
    ];

    final e = [
      for (var i = 0; i < v.length; i++) builder.edge(v[i], v[(i + 1) % v.length], parent: frame),
    ];

    builder.face(e, parent: frame);
  }
}
