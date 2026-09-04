part of '../kernel.dart';

extension type const CovertexIndex(int i) implements ElementIndex {
  static const none = CovertexIndex(kNone);
}

final class CovertexStorage extends ArenaStorage<CovertexIndex, int, CovertexStorage> {
  var vertex = VertexIndexStorage<CovertexIndex>();
  var isStart = BoolStorage<CovertexIndex>();
  var edge = EdgeIndexStorage<CovertexIndex>();
  var diskNext = CovertexIndexStorage<CovertexIndex>();
  var tangent = Vec2Storage<CovertexIndex>();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (vertex.length < atLeast) {
      vertex = vertex.grow(atLeast);
      isStart = isStart.grow(atLeast);
      edge = edge.grow(atLeast);
      diskNext = diskNext.grow(atLeast);
      tangent = tangent.grow(atLeast);
    }
  }

  @override
  void copyFrom(CovertexStorage other) {
    super.copyFrom(other);
    vertex = .copyFrom(other.vertex);
    isStart = .copyFrom(other.isStart);
    edge = .copyFrom(other.edge);
    diskNext = .copyFrom(other.diskNext);
    tangent = .copyFrom(other.tangent);
  }

  @override
  int _handleFor(int i) => i;

  @override
  CovertexIndex _wrapIndex(int i) => .new(i);
}

extension type const Covertex._((EdgeHandle, bool) v) {
  const Covertex(EdgeHandle edge, {required bool isStart}) : this._((edge, isStart));
  const Covertex.start(EdgeHandle edge) : this._((edge, true));
  const Covertex.end(EdgeHandle edge) : this._((edge, false));

  EdgeHandle get edge => v.$1;
  bool get isStart => v.$2;
  bool get isEnd => !v.$2;

  Covertex get opposite => Covertex._((edge, !isStart));

  CovertexRef asRef(TopologyBundle bundle) => .new(bundle.edgeId(edge), isStart: isStart);
}

extension type const CovertexRef._((CellId, bool) v) {
  const CovertexRef(CellId edge, {required bool isStart}) : this._((edge, isStart));
  const CovertexRef.start(CellId edge) : this._((edge, true));
  const CovertexRef.end(CellId edge) : this._((edge, false));

  CellId get edge => v.$1;
  bool get isStart => v.$2;
  bool get isEnd => !v.$2;

  Covertex? resolve(TopologyBundle bundle) {
    final e = bundle.edge(edge);
    if (e == null) return null;
    return Covertex._((e, isStart));
  }
}
