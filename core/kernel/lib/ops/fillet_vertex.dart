part of '../kernel.dart';

final class FilletVertexResult(
  final VertexHandle vertex,
  final EdgeHandle a,
  final EdgeHandle b,
);

final class FilletVertexOp extends Op<FilletVertexResult> {
  FilletVertexOp(
    this.target, {
    required this.a,
    required this.b,
  });

  final VertexRef target;
  final (EdgeRef edge, double setback) a, b;

  @override
  FilletVertexResult? _execute(Transaction t, bool produceResult) {
    final bundle = t.bundle;

    final v = t.vertexFor(target.id);
    final space = bundle.parentOf(v)!;

    final sa = cutSide(t, v, a.$1, a.$2);
    final sb = cutSide(t, v, b.$1, b.$2);

    final pa = bundle.vertexPosition(sa.vertex, space: space);
    final pb = bundle.vertexPosition(sb.vertex, space: space);
    final k = filletHandleFactor(sa.tangent, sb.tangent);
    final (left, right) = Cubic2(
      pa,
      pb,
      p1: pa + sa.tangent * (k * a.$2),
      p2: pb + sb.tangent * (k * b.$2),
    ).split(0.5);

    final vNew = t._addVertex(left.p3, parent: space);
    t._repointEdgeEndpoint(sa.arc, isStart: sa.vAtStart, to: vNew);
    t._repointEdgeEndpoint(sb.arc, isStart: sb.vAtStart, to: vNew);
    t._deleteVertex(v);

    if (sa.vAtStart) left.reverse();
    if (!sb.vAtStart) right.reverse();

    t._setEdgeCubic(sa.arc, left, space: space);
    t._setEdgeCubic(sb.arc, right, space: space);
    t._recordLineage(.vertex(v.ref(bundle), same: [vNew.ref(bundle)]));

    if (produceResult) return FilletVertexResult(vNew, sa.arc, sb.arc);
    return null;
  }

  static ({Vec2 tangent, VertexHandle vertex, EdgeHandle arc, bool vAtStart}) cutSide(
    Transaction t,
    VertexHandle v,
    EdgeRef e,
    double setback,
  ) {
    final bundle = t.bundle;
    final eHandle = t.edgeFor(e.id);
    final vAtStart = bundle.edgeStart(eHandle) == v;
    assert(vAtStart || bundle.edgeEnd(eHandle) == v);

    final cubic = bundle.edgeCubic(eHandle);
    final arcIndex = bundle.edgeCubicArcIndex(eHandle);
    final tu = arcIndex.tAt(vAtStart ? setback : arcIndex.length - setback).clamp(1e-6, 1 - 1e-6);
    final tangent = cubic.tangent(tu);
    final cut = CutEdgeOp(e, [tu]).result(t).single;

    return (
      tangent: vAtStart ? -tangent : tangent,
      arc: vAtStart ? cut.edge0 : cut.edge1,
      vertex: cut.vertex,
      vAtStart: vAtStart,
    );
  }

  static double filletHandleFactor(Vec2 ta, Vec2 tb) {
    final s = (ta - tb).length / 2;
    return 4 / 3 * s / (1 + s);
  }

  @override
  bool topologyEquals(Op other) {
    if (other is! FilletVertexOp) return false;
    if (other.target != target) return false;
    if (other.a.$1 != a.$1 || other.b.$1 != b.$1) return false;
    return true;
  }
}

extension FilletVertexTransaction on Transaction {
  FilletVertexResult filletVertex(
    VertexHandle v, {
    required (EdgeHandle edge, double setback) a,
    required (EdgeHandle edge, double setback) b,
  }) => _applyWithResult(
    FilletVertexOp(
      v.ref(bundle),
      a: (a.$1.ref(bundle), a.$2),
      b: (b.$1.ref(bundle), b.$2),
    ),
  );
}
