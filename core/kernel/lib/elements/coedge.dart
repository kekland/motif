part of '../kernel.dart';

extension type const CoedgeIndex(int i) implements ElementIndex {
  static const none = CoedgeIndex(kNone);
}

final class CoedgeStorage extends ArenaStorage<CoedgeIndex, int, CoedgeStorage> {
  var edge = EdgeIndexStorage<CoedgeIndex>();
  var direction = BoolStorage<CoedgeIndex>();
  var cycleNext = CoedgeIndexStorage<CoedgeIndex>();
  var face = FaceIndexStorage<CoedgeIndex>();
  var radialNext = CoedgeIndexStorage<CoedgeIndex>();

  @override
  void grow(int atLeast) {
    super.grow(atLeast);
    if (edge.length < atLeast) {
      edge = edge.grow(atLeast);
      direction = direction.grow(atLeast);
      cycleNext = cycleNext.grow(atLeast);
      face = face.grow(atLeast);
      radialNext = radialNext.grow(atLeast);
    }
  }

  @override
  void copyFrom(CoedgeStorage other) {
    super.copyFrom(other);
    edge = .copyFrom(other.edge);
    direction = .copyFrom(other.direction);
    cycleNext = .copyFrom(other.cycleNext);
    face = .copyFrom(other.face);
    radialNext = .copyFrom(other.radialNext);
  }

  @override
  int handleFor(CoedgeIndex i) => i.i;

  @override
  CoedgeIndex _wrapIndex(int i) => .new(i);
}

extension type const Coedge._((EdgeHandle, bool) v) {
  const Coedge(EdgeHandle edge, {required bool forward}) : this._((edge, forward));
  const Coedge.forward(EdgeHandle edge) : this._((edge, true));
  const Coedge.reverse(EdgeHandle edge) : this._((edge, false));

  static List<Coedge> walk(List<EdgeHandle> edges, {bool forward = true}) {
    return edges.map((e) => Coedge._((e, forward))).toList();
  }

  static (List<Coedge>, List<Coedge>) walks(List<EdgeHandle> edges) {
    final fwd = <Coedge>[], rev = <Coedge>[];
    for (var i = 0; i < edges.length; i++) {
      final j = edges.length - 1 - i;
      fwd.add(Coedge._((edges[i], true)));
      rev.add(Coedge._((edges[j], false)));
    }
    return (fwd, rev);
  }

  EdgeHandle get edge => v.$1;
  bool get forward => v.$2;

  Coedge get reversed => Coedge._((edge, !forward));
  Coedge withEdge(EdgeHandle other, {bool flip = false}) => Coedge._((other, flip ? !forward : forward));

  CoedgeRef asRef(Bundle bundle) => .new(bundle.edgeId(edge), forward: forward);
}

extension type const CoedgeRef._((CellId, bool) v) {
  const CoedgeRef(CellId edge, {required bool forward}) : this._((edge, forward));
  const CoedgeRef.forward(CellId edge) : this._((edge, true));
  const CoedgeRef.reverse(CellId edge) : this._((edge, false));

  CellId get edge => v.$1;
  bool get forward => v.$2;

  CoedgeRef get reversed => CoedgeRef._((edge, !forward));

  Coedge? resolve(Bundle bundle) {
    final e = bundle.edge(edge);
    if (e == null) return null;
    return Coedge._((e, forward));
  }
}
