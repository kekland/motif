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
  int handleFor(CovertexIndex i) => i.i;

  @override
  CovertexIndex _wrapIndex(int i) => .new(i);
}

extension type const Covertex._((EdgeHandle, bool) v) implements Object {
  const Covertex(EdgeHandle edge, {required bool isStart}) : this._((edge, isStart));
  const Covertex.start(EdgeHandle edge) : this._((edge, true));
  const Covertex.end(EdgeHandle edge) : this._((edge, false));

  EdgeHandle get edge => v.$1;
  bool get isStart => v.$2;
  bool get isEnd => !v.$2;

  Covertex get opposite => Covertex._((edge, !isStart));

  CovertexRef ref(Bundle bundle) => .new(bundle.edgeRef(edge), isStart: isStart);
}

final class CovertexRef extends Ref {
  CovertexRef(this.edge, {required this.isStart}) : hashCode = Mix64.hash32(edge.hashCode, isStart ? 1 : 0);
  CovertexRef.start(EdgeRef edge) : this(edge, isStart: true);
  CovertexRef.end(EdgeRef edge) : this(edge, isStart: false);

  final EdgeRef edge;
  final bool isStart;
  bool get isEnd => !isStart;

  CovertexRef get opposite => CovertexRef(edge, isStart: !isStart);

  @override
  final int hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CovertexRef && other.edge == edge && other.isStart == isStart;

  VertexRef resolveVertex(Bundle bundle) {
    final e = bundle.edge(edge)!;
    return isStart ? bundle.edgeStart(e).ref(bundle) : bundle.edgeEnd(e).ref(bundle);
  }

  Covertex? resolve(Bundle bundle) {
    final e = bundle.edge(edge);
    if (e == null) return null;
    return Covertex._((e, isStart));
  }
}
