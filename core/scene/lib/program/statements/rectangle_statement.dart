part of '../program.dart';

final class RectangleStatement extends ShapeStatement<RectangleObjectShape> {
  RectangleStatement({
    super.transform,
    super.size,
    RectangleObjectShape? shape,
    super.parent,
    super.id,
  }) : super(shape: shape ?? .new());

  late final topLeft = RectangleCorner._for(id, #tl);
  late final topRight = RectangleCorner._for(id, #tr);
  late final bottomRight = RectangleCorner._for(id, #br);
  late final bottomLeft = RectangleCorner._for(id, #bl);

  late final top = EdgeRef(id, #top);
  late final right = EdgeRef(id, #right);
  late final bottom = EdgeRef(id, #bottom);
  late final left = EdgeRef(id, #left);

  @override
  RectangleStatement copyWith({
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    FrameRef? parent,
  }) {
    return RectangleStatement(
      transform: transform ?? this.transform,
      size: size ?? this.size,
      shape: shape ?? this.shape,
      parent: parent ?? this.parent?.ref,
      id: id,
    );
  }
}

extension type RectangleCorner._((VertexRef, VertexRef, VertexRef, EdgeRef) _) {
  RectangleCorner._for(StatementId id, Symbol base)
    : this._((
        VertexRef(id, base),
        VertexRef(id, base / 'a'),
        VertexRef(id, base / 'b'),
        EdgeRef(id, base / 'arc'),
      ));

  VertexRef get vertex => _.$1;
  VertexRef get a => _.$2;
  VertexRef get b => _.$3;
  EdgeRef get arc => _.$4;

  Iterable<Ref> get all => [vertex, a, b, arc];
}
