part of '../program.dart';

final class ContainerStatement extends ShapeStatement<RectangleObjectShape> implements LayoutContainer {
  ContainerStatement({
    this.layout = .default_,
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
  final Layout layout;

  @override
  ContainerStatement copyWith({
    StatementId? id,
    bool? enabled,
    Layout? layout,
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
    layout: layout ?? this.layout,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );
}
