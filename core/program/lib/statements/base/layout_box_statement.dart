part of '../../program.dart';

mixin LayoutBoxStatement on PlacedStatement implements LayoutBox {
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
}
