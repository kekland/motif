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

  late final top = VertexRef(id, #t);
  late final right = VertexRef(id, #r);
  late final bottom = VertexRef(id, #b);
  late final left = VertexRef(id, #l);

  late final topRightArc = EdgeRef(id, #tr);
  late final bottomRightArc = EdgeRef(id, #rb);
  late final bottomLeftArc = EdgeRef(id, #bl);
  late final topLeftArc = EdgeRef(id, #lt);

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

  @override
  CircleStatement updateWith(CircleStatementPartial partial) => partial.apply(this);
}

final class CircleStatementPartial({
  super.transform,
  super.size,
  super.parent,
  super.edgeStyle,
  super.faceStyle,
  final CircleObjectShape? shape,
}) extends ShapeStatementPartial<CircleStatement> {
  @override
  CircleStatement apply(CircleStatement statement) => statement.copyWith(
    transform: transform,
    size: size,
    shape: shape,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
    parent: parent,
  );
}
