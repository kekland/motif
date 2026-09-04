part of '../kernel.dart';

extension type const EdgeIndex(int i) implements ElementIndex {
  static const none = EdgeIndex(kNone);

  CellIndex get cell => isNone ? .none : .from(i, .edge);
}

final class EdgeIdTable extends IdTable<EdgeIndex> {
  EdgeIdTable() : super('edge');

  @override
  EdgeIndex? wrapIndex(int? i) => i != null ? .new(i) : null;
}

final class EdgeStorage extends ArenaStorage<EdgeIndex, EdgeHandle, EdgeStorage> {
  var vStart = VertexIndexStorage<EdgeIndex>();
  var vEnd = VertexIndexStorage<EdgeIndex>();
  var cvStart = CovertexIndexStorage<EdgeIndex>();
  var cvEnd = CovertexIndexStorage<EdgeIndex>();
  var radialStart = CoedgeIndexStorage<EdgeIndex>();
  var parent = FrameIndexStorage<EdgeIndex>();
  var siblingPrev = CellIndexStorage<EdgeIndex>();
  var siblingNext = CellIndexStorage<EdgeIndex>();

  final id = EdgeIdTable();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (vStart.length < atLeast) {
      vStart = vStart.grow(atLeast);
      vEnd = vEnd.grow(atLeast);
      cvStart = cvStart.grow(atLeast);
      cvEnd = cvEnd.grow(atLeast);
      radialStart = radialStart.grow(atLeast);
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
    }
  }

  @override
  void copyFrom(EdgeStorage other) {
    super.copyFrom(other);
    vStart = .copyFrom(other.vStart);
    vEnd = .copyFrom(other.vEnd);
    cvStart = .copyFrom(other.cvStart);
    cvEnd = .copyFrom(other.cvEnd);
    radialStart = .copyFrom(other.radialStart);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    id.copyFrom(other.id);
  }

  EdgeHandle? handleForId(CellId id) {
    final i = this.id.indexOf(id);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  EdgeHandle _handleFor(int i) => .make(.new(i), gen[i]);

  @override
  EdgeIndex _wrapIndex(int i) => .new(i);
}
