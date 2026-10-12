part of '../../_program.dart';

final class ContainerStatement extends ShapeStatement implements LayoutContainer {
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
    super.modifiers,
    super.name,
  });

  @override
  bool get isLeaf => false;

  @override
  final Layout layout;

  @override
  ContainerStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    Layout? layout,
    LayoutSize? size,
    Mat4? transform,
    ObjectShape? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
    name: name ?? this.name,
    layout: layout ?? this.layout,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
    vertexStyle: vertexStyle ?? this.vertexStyle,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );

  @override
  ContainerStatement applyPartial(StatementPartial partial) => copyWith(
    modifiers: partial.field(#modifiers),
    name: partial.field(#name),
    layout: partial.field(#layout),
    size: partial.field(#layoutSize),
    transform: partial.field(#transform),
    shape: partial.field(#objectShape),
    vertexStyle: partial.field(#vertexStyle),
    edgeStyle: partial.field(#edgeStyle),
    faceStyle: partial.field(#faceStyle),
  );
}
