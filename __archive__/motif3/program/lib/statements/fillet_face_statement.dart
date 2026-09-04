part of '../program.dart';

final class FilletFaceStatement extends Statement {
  new(
    FaceSelector face, {
    List<(VertexSelector, Vec2)>? corners,
    this.radius,
    super.id,
    super.modifiers,
  }) : face = face.copyWith(),
       corners = corners?.map((e) => (e.$1.copyWith(), e.$2)).toList() ?? [];

  final FaceSelector face;
  final Vec2? radius;
  final List<(VertexSelector, Vec2)> corners;

  @override
  Iterable<Selector> get selectors => [face, for (final (v, _) in corners) v];

  @override
  void performExecute(EvalContext context) {
    final face = this.face.resolve(context);
    final overrides = <VertexHandle, Vec2>{};
    for (final (v, r) in corners) {
      final vertex = v.resolve(context);
      overrides[vertex] = r;
    }

    final perVertex = <VertexHandle, Vec2>{};
    for (final cycle in context.bundle.faceBoundary(face)) {
      for (final coedge in cycle) {
        final v = context.bundle.coedgeEnd(coedge);
        final radius = overrides[v] ?? this.radius;
        perVertex[v] = radius ?? .zero();
      }
    }

    context.transaction.filletFace(face, perVertex);
  }

  @override
  FilletFaceStatement copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    FaceSelector? face,
    Vec2? radius,
    List<(VertexSelector, Vec2)>? corners,
  }) => .new(
    face ?? this.face,
    radius: radius ?? this.radius,
    corners: corners ?? this.corners,
    id: id ?? this.id,
    modifiers: modifiers ?? this.modifiers,
  );
}
