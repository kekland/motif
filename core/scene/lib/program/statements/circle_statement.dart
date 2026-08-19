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

  @override
  CircleStatement updateWith(CircleStatementPartial partial) => partial.apply(this);

  @override
  CircleStatementPartial partial({
    Mat4? transform,
    LayoutSizePartial? size,
    CircleObjectShape? shape,
    EdgeStylePartial? edgeStyle,
    FaceStylePartial? faceStyle,
    FrameRef? parent,
  }) => .new(
    transform: transform,
    size: size,
    shape: shape,
    edgeStyle: edgeStyle,
    faceStyle: faceStyle,
    parent: parent,
  );
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
    size: size?.apply(statement.size),
    shape: shape,
    parent: parent,
    edgeStyle: statement.edgeStyle.updateWith(edgeStyle),
    faceStyle: statement.faceStyle.updateWith(faceStyle),
  );
}
