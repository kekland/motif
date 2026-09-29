part of '../kernel.dart';

extension ZOrderQueries on TopologyQuery {
  ZAnchor _zAnchorBottomFor(FrameHandle handle) {
    var bottom = bundle.frameChildrenHead(handle);
    if (bottom == null) return .bottom(1);

    while (true) {
      final anchor = bundle.zAnchorOf(bottom!);
      if (anchor is! ZBelow) break;
      bottom = bundle.handle(anchor.sibling)!;
    }

    return switch (bundle.zAnchorOf(bottom)) {
      ZBottom(:final rank) => .bottom(rank + 1),
      _ => .bottom(1),
    };
  }

  ZAnchor _zAnchorTopFor(FrameHandle handle) {
    var top = bundle.frameChildrenTail(handle);
    if (top == null) return .top(1);

    while (true) {
      final anchor = bundle.zAnchorOf(top!);
      if (anchor is! ZAbove) break;
      top = bundle.handle(anchor.sibling)!;
    }

    return switch (bundle.zAnchorOf(top)) {
      ZTop(:final rank) => .top(rank + 1),
      _ => .top(1),
    };
  }

  ZAnchor zAnchorBottomForTarget(CellRef cell) => _zAnchorBottomFor(bundle.parentOf(bundle.handle(cell)!)!);
  ZAnchor zAnchorTopForTarget(CellRef cell) => _zAnchorTopFor(bundle.parentOf(bundle.handle(cell)!)!);
}
