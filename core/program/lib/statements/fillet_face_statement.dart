part of '../program.dart';

final class FilletFace extends Statement {
  new(
    this.face, {
    this.corners = const [],
    this.radius,
    super.id,
    super.modifiers,
  }) : _corners = CornersSelector(face);

  FilletFace._withCornersSelector(
    this.face,
    this._corners, {
    this.corners = const [],
    this.radius,
    super.id,
    super.modifiers,
  });

  final FaceSelector face;
  final CornerRadius? radius;
  final List<(VertexSelector, CornerRadius)> corners;

  final CornersSelector _corners;

  @override
  Iterable<Selector> get selectors => [_corners, for (final (v, _) in corners) v];

  @override
  Iterable<Op> ops(EvalContext context) sync* {
    final radii = {for (final (v, r) in corners) context.resolve(v): r};
    final list = <FilletCorner>[];

    for (final k in context.resolve(_corners)) {
      final r = radii[k.v] ?? radius;
      if (r == null || (r.x <= 0 && r.y <= 0)) continue;
      list.add((v: k.v, a: k.a, b: k.b, radius: r));
    }

    yield FilletFaceOp(context.resolve(face), corners: list);
  }

  @override
  FilletFace copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    FaceSelector? face,
    List<(VertexSelector, CornerRadius)>? corners,
    CornerRadius? radius,
  }) => ._withCornersSelector(
    face ?? this.face,
    face != null && face != this.face ? .new(face) : _corners,
    corners: corners ?? this.corners,
    radius: radius ?? this.radius,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );

  @override
  TransformResult routeTransform(EvalContext context, CellRef target) => .forward([
    context.resolve(face),
  ]);
}
