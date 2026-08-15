part of '../kernel.dart';

extension type const FaceIndex(int i) implements ElementIndex {
  static const none = FaceIndex(kNone);

  CellIndex get cell => isNone ? .none : .from(i, .face);
}

final class FaceIdTable extends IdTable<FaceIndex> {
  FaceIdTable() : super('face');

  @override
  FaceIndex? wrapIndex(int? i) => i != null ? .new(i) : null;
}

final class FaceStorage extends ArenaStorage<FaceIndex, FaceHandle, FaceStorage> {
  var boundary = BoundaryListStorage<FaceIndex>();
  var parent = FrameIndexStorage<FaceIndex>();
  var siblingPrev = CellIndexStorage<FaceIndex>();
  var siblingNext = CellIndexStorage<FaceIndex>();

  final id = FaceIdTable();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    boundary.grow(atLeast);
    if (parent.length < atLeast) {
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
    }
  }

  @override
  void copyFrom(FaceStorage other) {
    super.copyFrom(other);
    boundary.copyFrom(other.boundary);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    id.copyFrom(other.id);
  }

  FaceHandle? handleForId(CellId id) {
    final i = this.id.indexOf(id);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  FaceHandle _handleFor(int i) => .make(.new(i), gen[i]);

  @override
  FaceIndex _wrapIndex(int i) => .new(i);
}
