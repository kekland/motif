part of '../kernel.dart';

enum ZPlacement {
  top,
  bottom,
  above,
  below,
}

sealed class ZAnchor {
  const ZAnchor();

  const factory top(int rank) = ZTop;
  const factory bottom(int rank) = ZBottom;
  const factory above(CellRef sibling) = ZAbove;
  const factory below(CellRef sibling) = ZBelow;

  int? get rank => null;
  CellRef? get sibling => null;

  ZAnchor remap(CellRef ref) => switch (this) {
    ZAbove() => .above(ref),
    ZBelow() => .below(ref),
    _ => this,
  };

  ZPlacement get placement => switch (this) {
    ZTop() => .top,
    ZBottom() => .bottom,
    ZAbove() => .above,
    ZBelow() => .below,
  };
}

final class const ZTop(@override final int rank) extends ZAnchor;
final class const ZBottom(@override final int rank) extends ZAnchor;
final class const ZAbove(@override final CellRef sibling) extends ZAnchor;
final class const ZBelow(@override final CellRef sibling) extends ZAnchor;
