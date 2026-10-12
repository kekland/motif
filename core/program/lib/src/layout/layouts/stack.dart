part of '../../_program.dart';

final class StackLayout extends Layout {
  const StackLayout({
    this.alignHorizontal = .none,
    this.alignVertical = .none,
    super.padding,
  });

  final LayoutAlign alignHorizontal;
  final LayoutAlign alignVertical;

  @override
  LayoutKind get kind => .stack;

  @override
  StackLayout copyWith({
    LayoutAlign? alignHorizontal,
    LayoutAlign? alignVertical,
    LayoutInsets? padding,
  }) => .new(
    alignHorizontal: alignHorizontal ?? this.alignHorizontal,
    alignVertical: alignVertical ?? this.alignVertical,
    padding: padding ?? this.padding,
  );

  @override
  bool operator ==(Object other) =>
      other is StackLayout &&
      other.alignHorizontal == alignHorizontal &&
      other.alignVertical == alignVertical &&
      other.padding == padding;

  @override
  int get hashCode => Object.hash(alignHorizontal, alignVertical, padding);
}

extension _StackLayoutImpl on LayoutTree {
  Size2 _measureStack(List<_LayoutNode> children, Size2 intrinsic, StackLayout l) {
    var out = intrinsic;
    for (final c in children) out = out.hull(c.naturalBounds);
    return out;
  }

  List<Placement> _placeStack(List<_LayoutNode> children, Size2 inner, StackLayout l) {
    final out = <Placement>[];
    for (final c in children) {
      final size = c.fitSize(inner);
      final alignX = l.alignHorizontal;
      final alignY = l.alignVertical;

      if (alignX == .none && alignY == .none) {
        out.add(.new(null, size));
        continue;
      }

      final bounds = c.bounds(size);
      final translation = c.box.transform.translation2;

      final x = alignX == .none ? translation.x : alignX.offset(inner.width, bounds.width) - bounds.min.x;
      final y = alignY == .none ? translation.y : alignY.offset(inner.height, bounds.height) - bounds.min.y;

      out.add(.new(l.padding.origin + .new(x, y), size));
    }
    return out;
  }
}
