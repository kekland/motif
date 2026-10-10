part of '../../_program.dart';

mixin LayoutBoxStatement on PlacedStatement, FramedStatement implements LayoutBox {
  // Mat4? get transientTransform;

  @override
  StatementId? get parentId {
    final p = parent;
    return p?.ref.statementId;
  }

  (Mat4, Size2) resolveBox(EvalContext context) {
    final p = context.placementOf(id);
    final t = transform.copy();

    final offset = p.offset;
    if (offset != null) t.setTranslation(offset.x, offset.y);
    return (t, p.size);
  }

  @override
  LayoutBoxStatement copyWith({
    StatementId? id,
    ModifierStack? modifiers,
    String? name,
    FrameRef? parent,
    LayoutSize? size,
    Mat4? transform,
  });

  @override
  ReparentRoute routeReparent(CellRef target) => target == frame ? .accept : .forward(frame);

  @override
  Statement absorbReparent(FrameRef to, Mat4 parentTransform) => copyWith(
    parent: to,
    transform: parentTransform * transform,
  );
}
