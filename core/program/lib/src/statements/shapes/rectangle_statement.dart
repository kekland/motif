part of '../../_program.dart';

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
    super.modifiers,
    super.name,
  });

  @override
  RectangleStatement copyWith({
    StatementId? id,
    List<Modifier>? modifiers,
    String? name,
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
    name: name ?? this.name,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );
}
