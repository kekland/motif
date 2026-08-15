part of '../program.dart';

final class ContainerStatement extends RectangleStatement {
  ContainerStatement({
    super.transform,
    super.size,
    super.parent,
    this.childLayout = .default_,
    super.shape,
    super.id,
  });

  @override
  final ChildLayout childLayout;

  @override
  ContainerStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    ChildLayout? childLayout,
    FrameRef? parent,
  }) {
    return ContainerStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      childLayout: childLayout ?? this.childLayout,
      parent: parent ?? this.parent?.ref,
      id: id,
    );
  }
}
