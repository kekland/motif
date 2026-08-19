part of '../program.dart';

final class RectangleStatement extends ShapeStatement<RectangleObjectShape> {
  RectangleStatement({
    super.transform,
    super.size,
    RectangleObjectShape? shape,
    super.parent,
    super.id,
    super.edgeStyle,
    super.faceStyle,
  }) : super(shape: shape ?? .new());

  late final topLeft = RectangleCorner._for(id, #tl);
  late final topRight = RectangleCorner._for(id, #tr);
  late final bottomRight = RectangleCorner._for(id, #br);
  late final bottomLeft = RectangleCorner._for(id, #bl);

  late final top = Ref.edge(id, #top);
  late final right = Ref.edge(id, #right);
  late final bottom = Ref.edge(id, #bottom);
  late final left = Ref.edge(id, #left);

  @override
  RectangleStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    FrameRef? parent,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    return RectangleStatement(
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
  RectangleStatement updateWith(RectangleStatementPartial partial) => partial.apply(this);

  @override
  RectangleStatementPartial partial({
    Mat4? transform,
    LayoutSizePartial? size,
    RectangleObjectShape? shape,
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

extension type RectangleCorner._((VertexRef, VertexRef, VertexRef, EdgeRef) _) {
  RectangleCorner._for(StatementId id, Symbol base)
    : this._((
        .vertex(id, base),
        .vertex(id, base / 'a'),
        .vertex(id, base / 'b'),
        .edge(id, base / 'arc'),
      ));

  VertexRef get vertex => _.$1;
  VertexRef get a => _.$2;
  VertexRef get b => _.$3;
  EdgeRef get arc => _.$4;

  Iterable<Ref> get all => [vertex, a, b, arc];
}

final class const RectangleStatementPartial({
  super.transform,
  super.size,
  super.parent,
  super.edgeStyle,
  super.faceStyle,
  final RectangleObjectShape? shape,
}) extends ShapeStatementPartial<RectangleStatement> {
  @override
  RectangleStatement apply(RectangleStatement statement) => statement.copyWith(
    transform: transform,
    size: size?.apply(statement.size),
    shape: shape,
    parent: parent,
    edgeStyle: statement.edgeStyle.updateWith(edgeStyle),
    faceStyle: statement.faceStyle.updateWith(faceStyle),
  );
}
