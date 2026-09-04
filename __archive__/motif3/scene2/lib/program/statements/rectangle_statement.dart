part of '../program.dart';

final class RectangleStatement extends ShapeStatement<RectangleObjectShape> {
  RectangleStatement({
    super.size,
    super.transform,
    super.shape = .default_,
    super.edgeStyle,
    super.faceStyle,
    super.parent,
    super.id,
    super.scope,
  });

  @override
  RectangleStatement copyWith({
    StatementId? id,
    Scope? scope,
    LayoutSize? size,
    Mat4? transform,
    RectangleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) => .new(
    id: id ?? this.id,
    scope: scope ?? this.scope,
    size: size ?? this.size,
    transform: transform ?? this.transform,
    shape: shape ?? this.shape,
    edgeStyle: edgeStyle ?? this.edgeStyle,
    faceStyle: faceStyle ?? this.faceStyle,
    parent: parent ?? this.parent?.ref,
  );
}
