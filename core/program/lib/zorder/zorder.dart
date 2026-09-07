part of '../program.dart';

sealed class ZAnchor {
  const ZAnchor();

  const factory ZAnchor.top() = ZTop;
  const factory ZAnchor.bottom() = ZBottom;
  const factory ZAnchor.above(CellRef sibling) = ZAbove;
  const factory ZAnchor.below(CellRef sibling) = ZBelow;
}

final class const ZTop() extends ZAnchor;
final class const ZBottom() extends ZAnchor;
final class const ZAbove(final CellRef sibling) extends ZAnchor;
final class const ZBelow(final CellRef sibling) extends ZAnchor;

final class _ZOrderEntry extends LinkedListEntry<_ZOrderEntry> {
  _ZOrderEntry(this.ref);
  final CellRef ref;
}
