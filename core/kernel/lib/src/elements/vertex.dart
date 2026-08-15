part of '../kernel.dart';

extension type const VertexIndex(int i) implements ElementIndex {
  static const none = VertexIndex(kNone);

  CellIndex get cell => isNone? .none : .from(i, .vertex);
}

final class VertexIdTable extends IdTable<VertexIndex> {
  VertexIdTable() : super('vertex');

  @override
  VertexIndex? wrapIndex(int? i) => i != null ? .new(i) : null;
}

final class VertexStorage extends ArenaStorage<VertexIndex, VertexHandle, VertexStorage> {
  var position = Vec2Storage<VertexIndex>();
  var diskStart = CovertexIndexStorage<VertexIndex>();
  var parent = FrameIndexStorage<VertexIndex>();
  var siblingPrev = CellIndexStorage<VertexIndex>();
  var siblingNext = CellIndexStorage<VertexIndex>();

  final id = VertexIdTable();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (position.length < atLeast) {
      position = position.grow(atLeast);
      diskStart = diskStart.grow(atLeast);
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
    }
  }

  @override
  void copyFrom(VertexStorage other) {
    super.copyFrom(other);
    position = .copyFrom(other.position);
    diskStart = .copyFrom(other.diskStart);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    id.copyFrom(other.id);
  }

  VertexHandle? handleForId(CellId id) {
    final i = this.id.indexOf(id);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  VertexHandle _handleFor(int i) => .make(.new(i), gen[i]);

  @override
  VertexIndex _wrapIndex(int i) => .new(i);
}
