part of '../program.dart';

final class RectangleStatement extends ShapeStatement<RectangleObjectShape> {
  RectangleStatement({
    super.size,
    super.transform,
    super.shape = .default_,
    super.vertexStyle,
    super.edgeStyle,
    super.faceStyle,
    super.parent,
    super.id,
    super.enabled,
  });

  @override
  RectangleStatement copyWith({
    StatementId? id,
    bool? enabled,
    LayoutSize? size,
    Mat4? transform,
    RectangleObjectShape? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );
}
