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
}
