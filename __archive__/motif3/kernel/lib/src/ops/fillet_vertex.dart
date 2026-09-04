part of '../kernel.dart';

final class FilletVertexOp(
  final CellId target,
  final (CellId, double) a,
  final (CellId, double) b,
  super.children,
) extends CompositeOp;

final class FilletVertexResult(final CutEdgeResult a, final CutEdgeResult b);

extension FilletVertexTransaction on TopologyTransaction {
  FilletVertexResult filletVertex(
    VertexHandle target, {
    required (EdgeHandle, double) a,
    required (EdgeHandle, double) b,
  }) {
    _checkOpen();

    final targetId = bundle.vertexId(target);
    final aId = bundle.edgeId(a.$1);
    final bId = bundle.edgeId(b.$1);

    final space = bundle.parentOf(target)!;

    ({CutEdgeResult cut, EdgeHandle arc, bool vAtStart, double setback, Vec2 tangent}) _cut(
      VertexHandle v,
      EdgeHandle e,
      double dist,
    ) {
      final vAtStart = bundle.edgeStart(e) == v;

      var cubic = bundle.edgeCubic(e);
      cubic = vAtStart ? cubic : cubic.reversed();
      final t = cubic.tAtDistance(dist).clamp(1e-6, 1 - 1e-6);
      final tangent = -cubic.tangent(t);

      final cut = cutEdge(e, vAtStart ? t : 1 - t);
      final arc = vAtStart ? cut.edge0 : cut.edge1;
      return (cut: cut, arc: arc, vAtStart: vAtStart, setback: dist, tangent: tangent.normalized());
    }

    double _filletHandleFactor(Vec2 ta, Vec2 tb) {
      final s = (ta - tb).length / 2;
      return 4 / 3 * s / (1 + s);
    }

    return _compositeOp(
      (children) => FilletVertexOp(targetId, (aId, a.$2), (bId, b.$2), children),
      () {
        final ca = _cut(target, a.$1, a.$2);
        final cb = _cut(target, b.$1, b.$2);

        final pa = bundle.vertexPosition(ca.cut.vertex, space: space);
        final pb = bundle.vertexPosition(cb.cut.vertex, space: space);

        final ta = ca.tangent, tb = cb.tangent;
        final k = _filletHandleFactor(ta, tb);
        final (left, right) = Cubic2(
          pa,
          pb,
          p1: pa + ta * k * ca.setback,
          p2: pb + tb * k * cb.setback,
        ).split(0.5);

        setVertexPosition(target, left.p3);
        setEdgeCubic(ca.arc, ca.vAtStart ? left.reversed() : left, space: space);
        setEdgeCubic(cb.arc, cb.vAtStart ? right : right.reversed(), space: space);

        return (FilletVertexResult(ca.cut, cb.cut), []);
      },
    );
  }
}
