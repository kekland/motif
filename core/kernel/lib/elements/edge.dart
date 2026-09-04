part of '../kernel.dart';

extension type const EdgeIndex(int i) implements ElementIndex {
  static const none = EdgeIndex(kNone);
  CellIndex get cell => isNone ? .none : .from(i, .edge);
}

extension type const EdgeHandle._(CellHandle h) implements CellHandle {
  EdgeHandle.make(EdgeIndex index, int gen) : h = .make(.edge, index, gen);
  EdgeIndex get index => .new(_index);
  EdgeRef ref(Bundle bundle) => bundle.ref(this) as EdgeRef;
}

final class EdgeStorage extends ArenaStorage<EdgeIndex, EdgeHandle, EdgeStorage> {
  var vStart = VertexIndexStorage<EdgeIndex>();
  var vEnd = VertexIndexStorage<EdgeIndex>();
  var cvStart = CovertexIndexStorage<EdgeIndex>();
  var cvEnd = CovertexIndexStorage<EdgeIndex>();
  var radialStart = CoedgeIndexStorage<EdgeIndex>();
  var cubic = Cubic2Storage<EdgeIndex>();
  var cubicVersion = Int32Storage<EdgeIndex>();
  var cubicEpoch = Int32Storage<EdgeIndex>();
  var cubicArcIndex = ObjectStorage<EdgeIndex, CubicArcIndex>();
  var parent = FrameIndexStorage<EdgeIndex>();
  var siblingPrev = CellIndexStorage<EdgeIndex>();
  var siblingNext = CellIndexStorage<EdgeIndex>();

  final id = IdTable<EdgeIndex>('edge');

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (vStart.length < atLeast) {
      vStart = vStart.grow(atLeast);
      vEnd = vEnd.grow(atLeast);
      cvStart = cvStart.grow(atLeast);
      cvEnd = cvEnd.grow(atLeast);
      radialStart = radialStart.grow(atLeast);
      cubic = cubic.grow(atLeast);
      cubicVersion = cubicVersion.grow(atLeast);
      cubicEpoch = cubicEpoch.grow(atLeast);
      cubicArcIndex = cubicArcIndex.grow(atLeast);
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
    cubic = .copyFrom(other.cubic);
    cubicVersion = .copyFrom(other.cubicVersion);
    cubicEpoch = .copyFrom(other.cubicEpoch);
    cubicArcIndex = .copyFrom(other.cubicArcIndex);
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
  EdgeHandle handleFor(EdgeIndex i) => .make(i, gen[i.i]);

  @override
  EdgeIndex _wrapIndex(int i) => .new(i);
}
