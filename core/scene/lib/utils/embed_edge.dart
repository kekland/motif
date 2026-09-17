part of '../scene.dart';

extension EmbedEdgeTransaction on SceneTransaction {
  List<EdgeRef> embedEdge(
    VertexRef startVertex,
    VertexRef endVertex,
    Cubic2 cubicWorld, {
    EdgeStyle? style,
    bool topological = true,
    bool destructive = true,
  }) {
    final bundle = evaluation.bundle;
    final parent = bundle.query.lca(startVertex, endVertex);
    final style_ = style ?? .default_;

    if (!topological) return [_insertPiece(this, cubicWorld, startVertex, endVertex, parent, style_)];

    final cuts = <StatementId>{};
    final List<EdgeRef> edges;

    final selfIntersection = cubicWorld.selfIntersect();
    if (selfIntersection == null) {
      edges = _commitSubCubic(this, cubicWorld, startVertex, endVertex, parent, cuts, edgeStyle: style_);
    } else {
      final (ta, tb) = (selfIntersection.ta, selfIntersection.tb);
      final pieces = cubicWorld.splitMultiple([ta, tb]);

      final toParent = bundle.query.worldToLocal(parent);
      final vertex = insert(VertexStatement(toParent.transform2(selfIntersection.point), parent: parent)).ref;
      flush();

      edges = [
        ..._commitSubCubic(this, pieces[0], startVertex, vertex, parent, cuts, edgeStyle: style_),
        ..._commitSubCubic(this, pieces[1], vertex, vertex, parent, cuts, edgeStyle: style_),
        ..._commitSubCubic(this, pieces[2], vertex, endVertex, parent, cuts, edgeStyle: style_),
      ];
    }

    if (!destructive || cuts.isEmpty) return edges;

    final plainEdgeCuts = cuts.where((c) {
      final target = evaluation.consumedOf(c).single;
      return evaluation.rootStatement(target.statementId) is EdgeStatement;
    });

    if (plainEdgeCuts.isEmpty) return edges;

    final remap = flatten(plainEdgeCuts);
    return [for (final e in edges) remap.one(e).$2];
  }
}

List<EdgeRef> _commitSubCubic(
  SceneTransaction txn,
  Cubic2 cubic,
  VertexRef start,
  VertexRef end,
  FrameRef parent,
  Set<StatementId> cuts, {
  EdgeStyle edgeStyle = .default_,
}) {
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

  final splits = <(int, EdgeHandle, Intersection)>[];
  for (final x in intersections) {
    final ta = x.$3.ta;
    if (ta <= 1e-6 || ta >= 1 - 1e-6) continue;
    if (splits.isNotEmpty && (ta - splits.last.$3.ta).abs() < 1e-6) continue;
    splits.add(x);
  }

  for (final entry in intersectionsByEdge.entries) {
    final edge = entry.key, intersections = entry.value;
    final edgeTs = intersections.map((e) => e.$2.tb).toList();

    if (edgeTs.length == 1) {
      final stmt = txn.insert(CutEdgeStatement(bundle.edgeRef(edge).selector(), t: edgeTs.single));
      indexToVertex[intersections.single.$1] = stmt.vertex;
      cuts.add(stmt.id);
    } else {
      final stmt = txn.insert(MultiCutEdgeStatement(bundle.edgeRef(edge).selector(), ts: edgeTs));
      cuts.add(stmt.id);
      for (var i = 0; i < intersections.length; i++) {
        final (index, _) = intersections[i];
        indexToVertex[index] = stmt.vertex(i);
      }
    }
  }

  txn.flush();

  final ts = splits.map((e) => e.$3.ta).toList();
  final pieces = cubic.splitMultiple(ts);
  final out = <EdgeRef>[];
  for (var i = 0; i < pieces.length; i++) {
    final s = i == 0 ? start : indexToVertex[splits[i - 1].$1]!;
    final e = i == pieces.length - 1 ? end : indexToVertex[splits[i].$1]!;
    out.add(_insertPiece(txn, pieces[i], s, e, parent, edgeStyle));
    txn.flush();
  }

  return out;
}

EdgeRef _insertPiece(
  SceneTransaction txn,
  Cubic2 piece,
  VertexRef s,
  VertexRef e,
  FrameRef parent,
  EdgeStyle style,
) {
  final bundle = txn.evaluation.bundle;
  final startTransform = bundle.query.worldToLocal(s);
  final endTransform = bundle.query.worldToLocal(e);
  final stmt = EdgeStatement(
    s.selector(),
    e.selector(),
    parent: parent,
    startTangent: startTransform.transformDelta2(piece.p1 - piece.p0),
    endTangent: endTransform.transformDelta2(piece.p2 - piece.p3),
    style: style,
  );
  txn.insert(stmt);
  return stmt.ref;
}
