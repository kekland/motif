part of '../kernel.dart';

extension type const FaceIndex(int i) implements ElementIndex {
  static const none = FaceIndex(kNone);
  CellIndex get cell => isNone ? .none : .from(i, .face);
}

extension type const FaceHandle.raw(CellHandle h) implements CellHandle {
  FaceHandle.make(FaceIndex index, int gen) : h = .make(.face, index, gen);
  FaceIndex get index => .new(rawIndex);
  FaceRef ref(Bundle bundle) => bundle.ref(this);
}

typedef FaceCorner = ({VertexHandle v, EdgeHandle a, EdgeHandle b});

final class FaceStorage extends ArenaStorage<FaceIndex, FaceHandle, FaceStorage> {
  var boundary = BoundaryListStorage<FaceIndex>();
  var parent = FrameIndexStorage<FaceIndex>();
  var siblingPrev = CellIndexStorage<FaceIndex>();
  var siblingNext = CellIndexStorage<FaceIndex>();
  var crossStart = CoframeIndexStorage<FaceIndex>();
  var zPlacement = Int32Storage<FaceIndex>();
  var zSibling = CellIndexStorage<FaceIndex>();

  final id = IdTable<FaceRef, FaceIndex>('face');

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    boundary.grow(atLeast);
    if (parent.length < atLeast) {
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
      crossStart = crossStart.grow(atLeast);
      zPlacement = zPlacement.grow(atLeast);
      zSibling = zSibling.grow(atLeast);
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
    zPlacement = .copyFrom(other.zPlacement);
    zSibling = .copyFrom(other.zSibling);
    id.copyFrom(other.id);
  }

  FaceHandle? handleForRef(FaceRef ref) {
    final i = id.indexOf(ref);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  FaceHandle handleFor(FaceIndex i) => .make(i, gen[i.i]);

  @override
  FaceIndex _wrapIndex(int i) => .new(i);
}
