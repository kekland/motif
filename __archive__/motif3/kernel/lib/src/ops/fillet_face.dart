part of '../kernel.dart';

final class FilletFaceOp(final CellId face, final List<(CellId, Vec2)> radii, super.children) extends CompositeOp;

extension FilletFaceTransaction on TopologyTransaction {
  Map<VertexHandle, FilletVertexResult> filletFace(FaceHandle face, Map<VertexHandle, Vec2> radii) {
    _checkOpen();
    final faceId = bundle.faceId(face);
    final resultRadii = radii.entries.map((e) => (bundle.vertexId(e.key), e.value)).toList();

    double filletSetback(Vec2 ta, Vec2 tb, double radius) {
      final s = ta.cross(tb).abs();
      if (s <= 1e-12) return 0;
      return radius * (1 + ta.dot(tb)) / s;
    }

    Vec2 awayTangent(EdgeHandle e, VertexHandle v) {
      final c = bundle.edgeCubic(e);
      return bundle.edgeStart(e) == v ? c.tangent(0) : c.reversed().tangent(0);
    }

    return _compositeOp(
      (children) => FilletFaceOp(faceId, resultRadii, children),
      () {
        final results = <VertexHandle, FilletVertexResult>{};

        for (final cycle in bundle.faceBoundary(face).toList()) {
          final walk = cycle.toList();
          final corners = <(VertexHandle, EdgeHandle, EdgeHandle, Vec2)>[];
          for (var i = 0; i < walk.length; i++) {
            final eIn = walk[i], eOut = walk[(i + 1) % walk.length];
            final v = bundle.coedgeEnd(eIn);
            final r = radii[v];
            if (r == null || (r.x <= 0 && r.y <= 0)) continue;

            final ta = awayTangent(eIn.edge, v), tb = awayTangent(eOut.edge, v);
            corners.add((
              v,
              eIn.edge,
              eOut.edge,
              Vec2(filletSetback(ta, tb, r.x), filletSetback(ta, tb, r.y)),
            ));
          }

          if (corners.isEmpty) continue;

          final total = <EdgeHandle, double>{};
          for (final (_, a, b, setback) in corners) {
            total[a] = (total[a] ?? 0) + setback.x;
            total[b] = (total[b] ?? 0) + setback.y;
          }

          double factor(EdgeHandle e) {
            final sum = total[e]!;
            if (sum <= 0) return 1;
            return math.min(1, bundle.edgeCubic(e).arcLength / sum);
          }

          final factors = {for (final e in total.keys) e: factor(e)};

          final current = <EdgeHandle, EdgeHandle>{};
          EdgeHandle live(EdgeHandle e) => current[e] ?? e;
          EdgeHandle remainder(CutEdgeResult r, VertexHandle v) =>
              bundle.edgeStart(r.edge0) == v || bundle.edgeEnd(r.edge0) == v ? r.edge1 : r.edge0;

          for (final (v, a, b, d) in corners) {
            final k = math.min(factors[a]!, factors[b]!);
            if (k <= 0 || (d.x <= 0 && d.y <= 0)) continue;
            final res = filletVertex(v, a: (live(a), d.x * k), b: (live(b), d.y * k));
            current[a] = remainder(res.a, v);
            current[b] = remainder(res.b, v);
            results[v] = res;
          }
        }

        return (results, []);
      },
    );
  }
}
