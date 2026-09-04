part of '../kernel.dart';

extension type const FrameIndex(int i) implements ElementIndex {
  static const none = FrameIndex(kNone);
  static const root = FrameIndex(0);
  CellIndex get cell => isNone ? .none : .from(i, .frame);
}

extension type const FrameHandle._(CellHandle h) implements CellHandle {
  FrameHandle.make(FrameIndex index, int gen) : h = .make(.frame, index, gen);
  FrameIndex get index => .new(_index);

  static final root = FrameHandle.make(.root, 0);
  FrameRef ref(Bundle bundle) => bundle.ref(this) as FrameRef;
}

final class FrameStorage extends ArenaStorage<FrameIndex, FrameHandle, FrameStorage> {
  var parent = FrameIndexStorage<FrameIndex>();
  var siblingPrev = CellIndexStorage<FrameIndex>();
  var siblingNext = CellIndexStorage<FrameIndex>();
  var childHead = CellIndexStorage<FrameIndex>();
  var transform = Mat4Storage<FrameIndex>();
  var size = Size2Storage<FrameIndex>();
  var hasSize = BoolStorage<FrameIndex>();
  var worldTransform = Mat4Storage<FrameIndex>();
  var inverseWorldTransform = Mat4Storage<FrameIndex>();
  var clip = FaceIndexStorage<FrameIndex>();
  var composedAt = Int32Storage<FrameIndex>();

  final id = IdTable<FrameIndex>('frame');

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (parent.length < atLeast) {
      parent = parent.grow(atLeast);
      siblingPrev = siblingPrev.grow(atLeast);
      siblingNext = siblingNext.grow(atLeast);
      childHead = childHead.grow(atLeast);
      transform = transform.grow(atLeast);
      size = size.grow(atLeast);
      hasSize = hasSize.grow(atLeast);
      worldTransform = worldTransform.grow(atLeast);
      inverseWorldTransform = inverseWorldTransform.grow(atLeast);
      clip = clip.grow(atLeast);
      composedAt = composedAt.grow(atLeast);
    }
  }

  @override
  void copyFrom(FrameStorage other) {
    super.copyFrom(other);
    parent = .copyFrom(other.parent);
    siblingPrev = .copyFrom(other.siblingPrev);
    siblingNext = .copyFrom(other.siblingNext);
    childHead = .copyFrom(other.childHead);
    transform = .copyFrom(other.transform);
    size = .copyFrom(other.size);
    hasSize = .copyFrom(other.hasSize);
    worldTransform = .copyFrom(other.worldTransform);
    inverseWorldTransform = .copyFrom(other.inverseWorldTransform);
    clip = .copyFrom(other.clip);
    composedAt = .copyFrom(other.composedAt);
    id.copyFrom(other.id);
  }

  FrameHandle? handleForId(CellId id) {
    final i = this.id.indexOf(id);
    if (i == null) return null;
    return handleFor(i);
  }

  @override
  FrameHandle handleFor(FrameIndex i) => .make(i, gen[i.i]);

  @override
  FrameIndex _wrapIndex(int i) => .new(i);
}
