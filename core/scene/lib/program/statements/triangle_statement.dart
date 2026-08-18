part of '../program.dart';

final class TriangleStatement({
  super.id,
  super.transform,
  super.size,
  super.parent,
  TriangleObjectShape? shape,
  super.edgeStyle,
  super.faceStyle,
}) extends ShapeStatement<TriangleObjectShape> {
  this : super(shape: shape ?? .new());

  late final top = VertexRef(id, #top);
  late final bottomLeft = VertexRef(id, #bl);
  late final bottomRight = VertexRef(id, #br);

  late final rightEdge = EdgeRef(id, #right);
  late final leftEdge = EdgeRef(id, #left);
  late final bottomEdge = EdgeRef(id, #bottom);

  @override
  TriangleStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    TriangleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) {
    return TriangleStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      parent: parent ?? this.parent?.ref,
      edgeStyle: edgeStyle ?? this.edgeStyle,
      faceStyle: faceStyle ?? this.faceStyle,
      id: id,
    );
  }

  @override
  TriangleStatement updateWith(TriangleStatementPartial partial) => partial.apply(this);
}

final class const TriangleStatementPartial({
  super.transform,
  super.size,
  super.parent,
  super.edgeStyle,
  super.faceStyle,
  final TriangleObjectShape? shape,
}) extends ShapeStatementPartial<TriangleStatement> {
  @override
  TriangleStatement apply(TriangleStatement statement) => statement.copyWith(
    transform: transform,
    size: size,
    shape: shape,
    parent: parent,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
  );
}
