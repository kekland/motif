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

  late final top = Ref.vertex(id, #top);
  late final bottomLeft = Ref.vertex(id, #bl);
  late final bottomRight = Ref.vertex(id, #br);

  late final rightEdge = Ref.edge(id, #right);
  late final leftEdge = Ref.edge(id, #left);
  late final bottomEdge = Ref.edge(id, #bottom);

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

  @override
  TriangleStatementPartial partial({
    Mat4? transform,
    LayoutSizePartial? size,
    TriangleObjectShape? shape,
    EdgeStylePartial? edgeStyle,
    FaceStylePartial? faceStyle,
    FrameRef? parent,
  }) => .new(
    transform: transform,
    size: size,
    shape: shape,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
    parent: parent,
  );
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
    size: size?.apply(statement.size),
    shape: shape,
    parent: parent,
    edgeStyle: statement.edgeStyle.updateWith(edgeStyle),
    faceStyle: statement.faceStyle.updateWith(faceStyle),
  );
}
