part of '../kernel.dart';

extension type const CornerRadius._(Vec2 _v) {
  CornerRadius(double x, double y) : _v = .new(x, y);
  static final zero = CornerRadius._(.zero());

  double get x => _v.x;
  double get y => _v.y;
}

typedef FilletCorner = ({VertexRef v, EdgeRef a, EdgeRef b, CornerRadius radius});
typedef FilletFaceResult = Map<VertexHandle, FilletVertexResult>;

final class FilletFaceOp extends Op<FilletFaceResult> {
  new(this.face, {required this.corners});

  final FaceRef face;
  final List<FilletCorner> corners;

  @override
  FilletFaceResult? _execute(Transaction t, bool produceResult) {
    final bundle = t.bundle;

    final resolved = [
      for (final c in corners)
        (
          v: t.vertexFor(c.v.id),
          a: t.edgeFor(c.a.id),
          b: t.edgeFor(c.b.id),
          radius: c.radius,
        ),
    ];

    final setbacks = <Vec2>[];
    final total = <EdgeHandle, double>{};
    final arcIndices = <EdgeHandle, CubicArcIndex>{};
    for (final c in resolved) {
      final ta = awayTangent(t, c.a, c.v), tb = awayTangent(t, c.b, c.v);
      final d = Vec2(setback(ta, tb, c.radius.x), setback(ta, tb, c.radius.y));
      setbacks.add(d);
      total[c.a] = (total[c.a] ?? 0) + d.x;
      total[c.b] = (total[c.b] ?? 0) + d.y;

      arcIndices[c.a] = bundle.edgeCubicArcIndex(c.a);
      arcIndices[c.b] = bundle.edgeCubicArcIndex(c.b);
    }

    final factors = {
      for (final e in total.keys) e: total[e]! <= 0 ? 1.0 : math.min(1, arcIndices[e]!.length / total[e]!),
    };

    final ts = <EdgeHandle, List<double>>{};
    final ta = List<double>.filled(resolved.length, 0);
    final tb = List<double>.filled(resolved.length, 0);

    double cutAt(EdgeHandle e, VertexHandle v, double s) {
      final index = arcIndices[e]!;
      final tu = index.tAt(bundle.edgeStart(e) == v ? s : index.length - s).clamp(1e-6, 1 - 1e-6);
      ts[e] ??= [];
      ts[e]!.add(tu);
      return tu;
    }

    for (var i = 0; i < resolved.length; i++) {
      final c = resolved[i];
      final k = math.min(factors[c.a]!, factors[c.b]!);
      ta[i] = cutAt(c.a, c.v, setbacks[i].x * k);
      tb[i] = cutAt(c.b, c.v, setbacks[i].y * k);
    }

    for (final list in ts.values) {
      list.sort();

      // adjust for near-coincident values (large radius)
      for (var i = 1; i < list.length; i++) {
        if (list[i] - list[i - 1] < 1e-6) list[i] = list[i - 1] + 1e-6;
      }
    }

    final cuts = {for (final e in ts.keys) e: CutEdgeOp(e.ref(bundle), ts[e]!).result(t)};

    final results = <VertexHandle, FilletVertexResult>{};
    for (var i = 0; i < resolved.length; i++) {
      final c = resolved[i];
      final k = math.min(factors[c.a]!, factors[c.b]!);
      final space = bundle.parentOf(c.v)!;

      final cutA = cuts[c.a]!, cutB = cuts[c.b]!;
      final aAtStart = bundle.edgeStart(c.a) == c.v, bAtStart = bundle.edgeStart(c.b) == c.v;

      final va = aAtStart ? cutA.vertices.first : cutA.vertices.last;
      final vb = bAtStart ? cutB.vertices.first : cutB.vertices.last;
      final arcA = aAtStart ? cutA.edges.first : cutA.edges.last;
      final arcB = bAtStart ? cutB.edges.first : cutB.edges.last;

      final da = bundle.edgeCubic(c.a, space: space).tangent(ta[i]) * (aAtStart ? -1 : 1);
      final db = bundle.edgeCubic(c.b, space: space).tangent(tb[i]) * (bAtStart ? -1 : 1);

      final pa = bundle.vertexPosition(va, space: space), pb = bundle.vertexPosition(vb, space: space);
      final h = FilletVertexOp.filletHandleFactor(da, db) * k;

      final (left, right) = Cubic2(
        pa,
        pb,
        p1: pa + da * (h * setbacks[i].x),
        p2: pb + db * (h * setbacks[i].y),
      ).split(0.5);

      final vNew = t._addVertex(left.p3, parent: space);
      t._repointEdgeEndpoint(arcA, isStart: aAtStart, to: vNew);
      t._repointEdgeEndpoint(arcB, isStart: bAtStart, to: vNew);
      t._deleteVertex(c.v);
      if (aAtStart) left.reverse();
      if (!bAtStart) right.reverse();

      t._setEdgeCubic(arcA, left, space: space);
      t._setEdgeCubic(arcB, right, space: space);
      t._recordLineage(.vertex(c.v.ref(bundle), same: [vNew.ref(bundle)]));
      if (produceResult) results[c.v] = FilletVertexResult(vNew, arcA, arcB);
    }

    if (produceResult) return results;
    return null;
  }

  static Vec2 awayTangent(Transaction t, EdgeHandle e, VertexHandle v) {
    final bundle = t.bundle;
    final atStart = bundle.edgeStart(e) == v;
    final c = bundle.edgeCubic(e, space: bundle.parentOf(v));
    var d = atStart ? c.p1 - c.p0 : c.p2 - c.p3;
    if (d.length <= 1e-18) d = atStart ? c.p3 - c.p0 : c.p0 - c.p3;
    return d.normalized();
  }

  static double setback(Vec2 ta, Vec2 tb, double radius) {
    final s = ta.cross(tb).abs();
    return s <= 1e-12 ? 0 : radius * (1 + ta.dot(tb)) / s;
  }

  @override
  bool topologyEquals(Op other) {
    if (other is! FilletFaceOp) return false;
    if (other.face != face || other.corners.length != corners.length) return false;

    for (final (i, c) in corners.indexed) {
      final o = other.corners[i];
      if (o.v != c.v || o.a != c.a || o.b != c.b) return false;
    }

    return true;
  }
}

extension FilletFaceTransaction on Transaction {
  Map<VertexHandle, FilletVertexResult> filletFace(
    FaceHandle face,
    List<(VertexHandle v, EdgeHandle a, EdgeHandle b, CornerRadius radius)> corners,
  ) => _applyWithResult(
    FilletFaceOp(
      face.ref(bundle),
      corners: corners
          .map((c) => (v: c.$1.ref(bundle), a: c.$2.ref(bundle), b: c.$3.ref(bundle), radius: c.$4))
          .toList(),
    ),
  );
}
