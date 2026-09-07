part of '../kernel.dart';

extension type const CoframeIndex(int i) implements ElementIndex {
  static const none = CoframeIndex(kNone);
}

final class CoframeStorage extends ArenaStorage<CoframeIndex, int, CoframeStorage> {
  var cell = CellIndexStorage<CoframeIndex>();
  var frame = FrameIndexStorage<CoframeIndex>();
  var dependentNext = CoframeIndexStorage<CoframeIndex>();
  var crossNext = CoframeIndexStorage<CoframeIndex>();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (cell.length < atLeast) {
      cell = cell.grow(atLeast);
      frame = frame.grow(atLeast);
      dependentNext = dependentNext.grow(atLeast);
      crossNext = crossNext.grow(atLeast);
    }
  }

  @override
  void copyFrom(CoframeStorage other) {
    super.copyFrom(other);
    cell = .copyFrom(other.cell);
    frame = .copyFrom(other.frame);
    dependentNext = .copyFrom(other.dependentNext);
    crossNext = .copyFrom(other.crossNext);
  }

  @override
  int handleFor(CoframeIndex i) => i.i;

  @override
  CoframeIndex _wrapIndex(int i) => .new(i);
}
