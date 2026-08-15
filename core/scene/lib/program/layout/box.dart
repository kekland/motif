part of '../program.dart';

abstract interface class LayoutBox {
  StatementId get id;
  StatementId? get parentId;

  Mat4 get transform;
  LayoutSize get size;
  ChildLayout get childLayout;
  Size2 get naturalSize;
}

mixin LayoutBoxStatement on PlacedStatement implements LayoutBox {
  @override
  StatementId? get parentId => parent?.ref.statement;

  @override
  Mat4 get transform;

  Size2 _effectiveSize(LayoutResult? layout) {
    if (layout?.size != null) return layout!.size!;
    assert(size.isFullyFixed, 'size must be fully fixed if no layout is provided');
    return size.fixedOrZero();
  }

  Mat4 _effectiveTransform(LayoutResult? layout) {
    final t = transform.copy();
    final offset = layout?.offset;
    if (offset != null) t.setTranslation(offset.x, offset.y);
    return t;
  }

  @override
  void execute(EvalContext context) {
    final layout = context.layoutOf(id);

    performExecute(
      context,
      _effectiveTransform(layout),
      _effectiveSize(layout),
    );
  }

  void performExecute(EvalContext context, Mat4 transform, Size2 size);
}
