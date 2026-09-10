part of '../program.dart';

final class FilletFaceStatement extends Statement {
  FilletFaceStatement._(
    this.face,
    this._corners, {
    this.corners = const [],
    this.radius,
    super.id,
    super.enabled,
  });

  factory FilletFaceStatement(
    FaceSelector face, {
    List<(VertexSelector, CornerRadius)> corners = const [],
    CornerRadius? radius,
    StatementId? id,
    bool enabled = true,
  }) {
    final f = face.clone();
    return ._(
      f,
      .new(f),
      corners: corners.map((e) => (e.$1.clone(), e.$2)).toList(),
      radius: radius,
      id: id,
      enabled: enabled,
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
    yield FilletFaceOp(
      context.resolve(face),
      corners: context.resolve(_corners),
      radius: radius,
      radii: corners.isNotEmpty ? {for (final (v, r) in corners) context.resolve(v): r} : {},
    );
  }

  @override
  FilletFaceStatement copyWith({
    StatementId? id,
    bool? enabled,
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
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  TransformRoute routeTransform(EvalContext context, Ref target) => .forward([
    context.resolve(face),
  ]);
}
