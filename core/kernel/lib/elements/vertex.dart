part of '../kernel.dart';

extension type const VertexIndex(int i) implements ElementIndex {
  static const none = VertexIndex(kNone);
  CellIndex get cell => isNone ? .none : .from(i, .vertex);
}

extension type const VertexHandle.raw(CellHandle h) implements CellHandle {
  VertexHandle.make(VertexIndex index, int gen) : h = .make(.vertex, index, gen);
  VertexIndex get index => .new(rawIndex);
  VertexRef ref(Bundle bundle) => bundle.ref(this);
}

final class VertexStorage extends ArenaStorage<VertexIndex, VertexHandle, VertexStorage> {
  var position = Vec2Storage<VertexIndex>();
  var diskStart = CovertexIndexStorage<VertexIndex>();
  var positionWorld = Vec2Storage<VertexIndex>();
  var positionVersion = Int32Storage<VertexIndex>();
  var positionEpoch = Int32Storage<VertexIndex>();
  var parent = FrameIndexStorage<VertexIndex>();
  var siblingPrev = CellIndexStorage<VertexIndex>();
  var siblingNext = CellIndexStorage<VertexIndex>();

  final id = IdTable<VertexRef, VertexIndex>('vertex');

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (position.length < atLeast) {
      position = position.grow(atLeast);
      diskStart = diskStart.grow(atLeast);
      positionWorld = positionWorld.grow(atLeast);
      positionVersion = positionVersion.grow(atLeast);
      positionEpoch = positionEpoch.grow(atLeast);
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
    positionWorld = .copyFrom(other.positionWorld);
    positionVersion = .copyFrom(other.positionVersion);
    positionEpoch = .copyFrom(other.positionEpoch);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    id.copyFrom(other.id);
  }

  VertexHandle? handleForRef(VertexRef ref) {
    final i = id.indexOf(ref);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  VertexHandle handleFor(VertexIndex i) => .make(i, gen[i.i]);

  @override
  VertexIndex _wrapIndex(int i) => .new(i);
}
