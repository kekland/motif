part of '../program.dart';

final class FilletFaceStatement extends Statement {
  FilletFaceStatement._(
    this.face,
    this._corners, {
    this.corners = const [],
    this.radius,
    super.id,
    super.modifiers,
  });

  factory FilletFaceStatement(
    FaceSelector face, {
    List<(VertexSelector, CornerRadius)> corners = const [],
    CornerRadius? radius,
    StatementId? id,
    List<Statement> modifiers = const [],
  }) {
    final f = face.clone();
    return ._(
      f,
      .new(f),
      corners: corners.map((e) => (e.$1.clone(), e.$2)).toList(),
      radius: radius,
      id: id,
      modifiers: modifiers,
    );
  }

  final FaceSelector face;
  final CornerRadius? radius;
  final List<(VertexSelector, CornerRadius)> corners;

  final CornersSelector _corners;

  @override
  Iterable<Selector> get selectors => [face, _corners, for (final (v, _) in corners) v];

  @override
  Iterable<Op> execute(EvalContext context) sync* {
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
  FilletFaceStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    FaceSelector? face,
    List<(VertexSelector, CornerRadius)>? corners,
    CornerRadius? radius,
  }) {
    final f = (face ?? this.face).clone();
    return ._(
      f,
      .new(f),
      corners: (corners ?? this.corners).map((e) => (e.$1.clone(), e.$2)).toList(),
      radius: radius ?? this.radius,
      id: id ?? this.id,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  TransformResult routeTransform(EvalContext context, CellRef target) => .forward([
    context.resolve(face),
  ]);
}
