part of '../program.dart';

final class CircleStatement({
  super.id,
  super.transform,
  super.size,
  super.parent,
  CircleObjectShape? shape,
  super.edgeStyle,
  super.faceStyle,
}) extends ShapeStatement<CircleObjectShape> {
  this : super(shape: shape ?? .new());

  late final top = Ref.vertex(id, #t);
  late final right = Ref.vertex(id, #r);
  late final bottom = Ref.vertex(id, #b);
  late final left = Ref.vertex(id, #l);

  late final topRightArc = Ref.edge(id, #tr);
  late final bottomRightArc = Ref.edge(id, #rb);
  late final bottomLeftArc = Ref.edge(id, #bl);
  late final topLeftArc = Ref.edge(id, #lt);

  @override
  CircleStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    CircleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  }) {
    return CircleStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      parent: parent ?? this.parent?.ref,
      edgeStyle: edgeStyle ?? this.edgeStyle,
      faceStyle: faceStyle ?? this.faceStyle,
      id: id,
    );
  }
}

