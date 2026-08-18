part of '../program.dart';

final class ContainerStatement extends ShapeStatement<ObjectShape> {
  ContainerStatement({
    super.transform,
    super.size,
    super.parent,
    this.childLayout = .default_,
    ObjectShape? shape,
    super.id,
    super.edgeStyle,
    super.faceStyle,
  }) : super(shape: shape ?? .default_);

  @override
  final ChildLayout childLayout;

  @override
  ContainerStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    ObjectShape? shape,
    ChildLayout? childLayout,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) {
    return ContainerStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      childLayout: childLayout ?? this.childLayout,
      parent: parent ?? this.parent?.ref,
      edgeStyle: edgeStyle ?? this.edgeStyle,
      faceStyle: faceStyle ?? this.faceStyle,
      id: id,
    );
  }

  @override
  ContainerStatement updateWith(ContainerStatementPartial partial) => partial.apply(this);
}

final class ContainerStatementPartial({
  super.transform,
  super.size,
  super.parent,
  super.edgeStyle,
  super.faceStyle,
  final ChildLayout? childLayout,
  final ObjectShape? shape,
}) extends ShapeStatementPartial<ContainerStatement> {
  @override
  ContainerStatement apply(ContainerStatement statement) => statement.copyWith(
    transform: transform,
    size: size,
    shape: shape,
    childLayout: childLayout,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
    parent: parent,
  );
}
