part of '../scene.dart';

extension EmbedEdgeTransaction on SceneTransaction {
  List<EdgeRef> embedEdge(
    VertexRef startVertex,
    VertexRef endVertex,
    Cubic2 cubicWorld, {
    EdgeStyle? style,
  }) {
    final bundle = evaluation.bundle;
    final parent = bundle.query.lca(startVertex, endVertex);

    final selfIntersection = cubicWorld.selfIntersect();
    if (selfIntersection == null) {
      return _commitSubCubic(this, cubicWorld, startVertex, endVertex, parent);
    } else {
      final (ta, tb) = (selfIntersection.ta, selfIntersection.tb);
      final pieces = cubicWorld.splitMultiple([ta, tb]);

      final toParent = bundle.query.worldToLocal(parent);
      final vertex = insert(VertexStatement(toParent.transform2(selfIntersection.point), parent: parent)).ref;
      flush();

      return [
        ..._commitSubCubic(this, pieces[0], startVertex, vertex, parent),
        ..._commitSubCubic(this, pieces[1], vertex, vertex, parent),
        ..._commitSubCubic(this, pieces[2], vertex, endVertex, parent),
      ];
    }
  }
}

List<EdgeRef> _commitSubCubic(
  SceneTransaction txn,
  Cubic2 cubic,
  VertexRef start,
  VertexRef end,
  FrameRef parent,
) {
  final bundle = txn.evaluation.bundle;

  final rawIntersections = bundle.intersections.withCubic(
    cubic,
    start: bundle.vertex(start)!,
    end: bundle.vertex(end)!,
  );

  final intersections = <(int, EdgeHandle, Intersection)>[];
  final intersectionsByEdge = <EdgeHandle, List<(int, Intersection)>>{};
  final indexToVertex = <int, VertexRef>{};
  var count = 0;

  for (final entry in rawIntersections.entries) {
    final edge = entry.key;
    intersectionsByEdge[edge] = [];
    for (final i in entry.value.intersections) {
      intersections.add((count, edge, i));

      final v = i.resolveEndpointsB(() => bundle.edgeStart(edge), () => bundle.edgeEnd(edge));
      if (v != null) {
        indexToVertex[count] = bundle.ref(v);
      } else {
        intersectionsByEdge[edge]!.add((count, i));
      }

      count++;
    }
    intersectionsByEdge[edge]!.sort((a, b) => a.$2.tb.compareTo(b.$2.tb));
  }

  intersections.sort((a, b) => a.$3.ta.compareTo(b.$3.ta));

  final seen = <VertexRef>{};
  intersections.retainWhere((x) {
    final v = indexToVertex[x.$1];
    return v == null || seen.add(v);
  });

  for (final entry in intersectionsByEdge.entries) {
    final edge = entry.key, intersections = entry.value;
    final edgeTs = intersections.map((e) => e.$2.tb).toList();

    if (edgeTs.length == 1) {
      final stmt = txn.insert(CutEdgeStatement(bundle.edgeRef(edge).selector(), t: edgeTs.single));
      indexToVertex[intersections.single.$1] = stmt.vertex;
    } else {
      final stmt = txn.insert(MultiCutEdgeStatement(bundle.edgeRef(edge).selector(), ts: edgeTs));
      for (var i = 0; i < intersections.length; i++) {
        final (index, _) = intersections[i];
        indexToVertex[index] = stmt.vertex(i);
      }
    }
  }

  txn.flush();

  final ts = intersections.map((e) => e.$3.ta).toList();
  final pieces = cubic.splitMultiple(ts);
  final out = <EdgeRef>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[intersections[i - 1].$1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[intersections[i].$1]!;
    final piece = pieces[i];

    final startTransform = bundle.query.worldToLocal(s);
    final endTransform = bundle.query.worldToLocal(e);

    final stmt = EdgeStatement(
      s.selector(),
      e.selector(),
      parent: parent,
      startTangent: startTransform.transformDelta2(piece.p1 - piece.p0),
      endTangent: endTransform.transformDelta2(piece.p2 - piece.p3),
    );

    out.add(stmt.ref);
    txn.insert(stmt);
    txn.flush();
  }

  return out;
}
