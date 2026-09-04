part of '../program.dart';

final class Container extends ShapeStatement<RectangleObjectShape> implements LayoutContainer {
  Container({
    this.layout = .default_,
    super.size,
    super.transform,
    super.shape = .default_,
    super.vertexStyle,
    super.edgeStyle,
    super.faceStyle,
    super.parent,
    super.id,
    super.modifiers,
  });

  @override
  final Layout layout;

  @override
  Container copyWith({
    StatementId? id,
    List<Statement>? modifiers,
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
    modifiers: modifiers ?? this.modifiers,
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
