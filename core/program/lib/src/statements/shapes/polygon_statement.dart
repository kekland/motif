part of '../../_program.dart';

final class PolygonStatement extends ShapeStatement<PolygonObjectShape> {
  PolygonStatement({
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
  PolygonStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    LayoutSize? size,
    Mat4? transform,
    PolygonObjectShape? shape,
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
