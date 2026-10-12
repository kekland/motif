part of '../_program.dart';

final class PrefabOriginStatement extends ContainerStatement {
  PrefabOriginStatement({
    super.layout,
    super.size,
    super.transform,
    super.shape,
    super.vertexStyle,
    super.edgeStyle,
    super.faceStyle,
    super.parent,
    super.id,
    super.modifiers,
    super.name,
    this.isDeleted = false,
  });

  PrefabOriginStatement.fromContainer({required ContainerStatement container})
    : this(
        layout: container.layout,
        size: container.size,
        transform: container.transform,
        shape: container.shape,
        vertexStyle: container.vertexStyle,
        edgeStyle: container.edgeStyle,
        faceStyle: container.faceStyle,
        parent: container.parent?.ref,
        modifiers: container.modifiers,
        name: container.name,
        id: container.id,
        isDeleted: false,
      );

  final bool isDeleted;

  @override
  PrefabOriginStatement copyWith({
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
    bool? isDeleted,
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
    isDeleted: isDeleted ?? this.isDeleted,
  );

  @override
  PrefabOriginStatement applyPartial(StatementPartial partial) => copyWith(
    modifiers: partial.field(#modifiers),
    name: partial.field(#name),
    layout: partial.field(#layout),
    size: partial.field(#layoutSize),
    transform: partial.field(#transform),
    shape: partial.field(#shape),
    vertexStyle: partial.field(#vertexStyle),
    edgeStyle: partial.field(#edgeStyle),
    faceStyle: partial.field(#faceStyle),
  );
}
