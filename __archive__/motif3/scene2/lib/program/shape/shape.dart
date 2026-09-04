part of '../program.dart';

sealed class ObjectShape {
  const ObjectShape();

  static const default_ = ObjectShape.rectangle();

  const factory ObjectShape.rectangle() = RectangleObjectShape;

  Iterable<Statement> produce(
    Size2 size, {
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  });
}

final class RectangleObjectShape extends ObjectShape {
  const RectangleObjectShape();
  static const default_ = RectangleObjectShape();

  @override
  Iterable<Statement> produce(
    Size2 size, {
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    final frame = FrameStatement();
    final vertices = <VertexStatement>[
      .new(.zero(), scope: .new('tl'), parent: frame.ref),
      .new(.new(size.width, 0), scope: .new('tr'), parent: frame.ref),
      .new(.new(size.width, size.height), scope: .new('br'), parent: frame.ref),
      .new(.new(0, size.height), scope: .new('bl'), parent: frame.ref),
    ];

    final edges = <EdgeStatement>[
      .new(vertices[0].ref, vertices[1].ref, scope: .new('top'), parent: frame.ref),
      .new(vertices[1].ref, vertices[2].ref, scope: .new('right'), parent: frame.ref),
      .new(vertices[2].ref, vertices[3].ref, scope: .new('bottom'), parent: frame.ref),
      .new(vertices[3].ref, vertices[0].ref, scope: .new('left'), parent: frame.ref),
    ];

    final face = FaceStatement(
      edges.map((e) => e.ref).toList(),
      scope: .new('face'),
      parent: frame.ref,
    );

    return [
      frame,
      ...vertices,
      ...edges,
      face,
    ];
  }
}
