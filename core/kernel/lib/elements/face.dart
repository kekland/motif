part of '../kernel.dart';

extension type const FaceIndex(int i) implements ElementIndex {
  static const none = FaceIndex(kNone);
  CellIndex get cell => isNone ? .none : .from(i, .face);
}

extension type const FaceHandle._(CellHandle h) implements CellHandle {
  FaceHandle.make(FaceIndex index, int gen) : h = .make(.face, index, gen);
  FaceIndex get index => .new(_index);
  FaceRef ref(Bundle bundle) => bundle.ref(this);
}

final class FaceStorage extends ArenaStorage<FaceIndex, FaceHandle, FaceStorage> {
  var boundary = BoundaryListStorage<FaceIndex>();
  var parent = FrameIndexStorage<FaceIndex>();
  var siblingPrev = CellIndexStorage<FaceIndex>();
  var siblingNext = CellIndexStorage<FaceIndex>();
  var crossStart = CoframeIndexStorage<FaceIndex>();

  final id = IdTable<FaceIndex>('face');

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    boundary.grow(atLeast);
    if (parent.length < atLeast) {
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
      crossStart = crossStart.grow(atLeast);
    }
  }

  @override
  void copyFrom(FaceStorage other) {
    super.copyFrom(other);
    boundary.copyFrom(other.boundary);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    crossStart = .copyFrom(other.crossStart);
    id.copyFrom(other.id);
  }

  FaceHandle? handleForId(CellId id) {
    final i = this.id.indexOf(id);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  FaceHandle handleFor(FaceIndex i) => .make(i, gen[i.i]);

  @override
  FaceIndex _wrapIndex(int i) => .new(i);
}
