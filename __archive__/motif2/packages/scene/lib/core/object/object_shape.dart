part of '../core.dart';

extension type const CornerRadius._((double, double) value) {
  const CornerRadius(double x, double y) : value = (x, y);
  const CornerRadius.circular(double radius) : value = (radius, radius);
  static const zero = CornerRadius(0, 0);

  double get x => value.$1;
  double get y => value.$2;

  bool get isZero => x == 0 && y == 0;
}

sealed class ObjectShape {
  const ObjectShape();

  static const default_ = ObjectShape.rectangle();

  const factory ObjectShape.rectangle({
    CornerRadius topLeftRadius,
    CornerRadius topRightRadius,
    CornerRadius bottomLeftRadius,
    CornerRadius bottomRightRadius,
  }) = RectangleObjectShape;

  Topology produceTopology(ResolvedSize size);
}

final class RectangleObjectShape extends ObjectShape {
  const RectangleObjectShape({
    this.topLeftRadius = .zero,
    this.topRightRadius = .zero,
    this.bottomLeftRadius = .zero,
    this.bottomRightRadius = .zero,
  });

  RectangleObjectShape.circular(double radius)
    : this(
        topLeftRadius: .circular(radius),
        topRightRadius: .circular(radius),
        bottomLeftRadius: .circular(radius),
        bottomRightRadius: .circular(radius),
      );

  final CornerRadius topLeftRadius;
  final CornerRadius topRightRadius;
  final CornerRadius bottomLeftRadius;
  final CornerRadius bottomRightRadius;

  static const _kappa = 0.552284749831;
  static const _vertexThreshold = 1e-6;

  @override
  Topology produceTopology(ResolvedSize size) {
    final width = size.width, height = size.height;

    var tlX = topLeftRadius.x, tlY = topLeftRadius.y;
    var trX = topRightRadius.x, trY = topRightRadius.y;
    var blX = bottomLeftRadius.x, blY = bottomLeftRadius.y;
    var brX = bottomRightRadius.x, brY = bottomRightRadius.y;

    var scale = 1.0;
    void _checkOverflow(double a, double b, double d) {
      if (a + b > d && d > 0) {
        final s = d / (a + b);
        if (s < scale) scale = s;
      }
    }

    _checkOverflow(tlX, trX, width);
    _checkOverflow(blX, brX, width);
    _checkOverflow(tlY, blY, height);
    _checkOverflow(trY, brY, height);

    if (scale < 1.0) {
      // dart format off
      tlX *= scale; tlY *= scale;
      trX *= scale; trY *= scale;
      blX *= scale; blY *= scale;
      brX *= scale; brY *= scale;
      // dart format on
    }

    final topology = Topology();
    final vertices = <Vector2, Vertex>{};

    Vertex _getVertex(double x, double y, TopologyId tid) {
      final p = Vector2(x, y);
      for (final k in vertices.keys) {
        if ((k.x - x).abs() < _vertexThreshold && (k.y - y).abs() < _vertexThreshold) {
          return vertices[k]!;
        }
      }
      final v = Vertex(p, topologyId: tid);
      // v.constraints = VertexConstraints.fixed(x, y);
      vertices[p] = v;
      topology.add(v);
      return v;
    }

    // _getVertex(0, 0, .from('v_corner_tl'));
    // _getVertex(width, 0, .from('v_corner_tr'));
    // _getVertex(width, height, .from('v_corner_br'));
    // _getVertex(0, height, .from('v_corner_bl'));

    final tl = (
      left: _getVertex(0, tlY, .from('v_corner_tl_left')),
      top: _getVertex(tlX, 0, .from('v_corner_tl_top')),
    );

    final tr = (
      top: _getVertex(width - trX, 0, .from('v_corner_tr_top')),
      right: _getVertex(width, trY, .from('v_corner_tr_right')),
    );

    final br = (
      right: _getVertex(width, height - brY, .from('v_corner_br_right')),
      bottom: _getVertex(width - brX, height, .from('v_corner_br_bottom')),
    );

    final bl = (
      bottom: _getVertex(blX, height, .from('v_corner_bl_bottom')),
      left: _getVertex(0, height - blY, .from('v_corner_bl_left')),
    );

    void _addEdge(Vertex a, Vertex b, {Vector2? cOut, Vector2? cIn, TopologyId? tid}) {
      if (a == b) return;
      final startKnot = CubicKnot2(a.position, cOut: cOut);
      final endKnot = CubicKnot2(b.position, cIn: cIn);
      topology.add(Edge(a, b, path: .new([startKnot, endKnot]), topologyId: tid));
    }

    final oneMinusK = 1 - _kappa;

    _addEdge(
      tl.left,
      tl.top,
      cOut: tlY > 0 ? Vector2(0.0, tlY * oneMinusK) : null,
      cIn: tlX > 0 ? Vector2(tlX * oneMinusK, 0.0) : null,
      tid: .from('e_corner_tl'),
    );

    _addEdge(tl.top, tr.top, tid: .from('e_top'));

    _addEdge(
      tr.top,
      tr.right,
      cOut: trX > 0 ? Vector2(width - trX * oneMinusK, 0.0) : null,
      cIn: trY > 0 ? Vector2(width, trY * oneMinusK) : null,
      tid: .from('e_corner_tr'),
    );

    _addEdge(tr.right, br.right, tid: .from('e_right'));

    _addEdge(
      br.right,
      br.bottom,
      cOut: brY > 0 ? Vector2(width, height - brY * oneMinusK) : null,
      cIn: brX > 0 ? Vector2(width - brX * oneMinusK, height) : null,
      tid: .from('e_corner_br'),
    );

    _addEdge(br.bottom, bl.bottom, tid: .from('e_bottom'));

    _addEdge(
      bl.bottom,
      bl.left,
      cOut: blX > 0 ? Vector2(blX * oneMinusK, height) : null,
      cIn: blY > 0 ? Vector2(0.0, height - blY * oneMinusK) : null,
      tid: .from('e_corner_bl'),
    );

    _addEdge(bl.left, tl.left, tid: .from('e_left'));

    final edges = topology.cells.whereType<Edge>().toList();
    final cycle = Cycle(edges.map((e) => HalfEdge.from(e, true)).toList());
    final face = Face(geometry: .new([cycle]), topologyId: .from('f_face'));
    topology.add(face);

    return topology;
  }
}

mixin SceneObjectWithShape on SceneObject {
  ObjectShape _shape = .default_;
  ObjectShape get shape => _shape;
  set shape(ObjectShape value) {
    if (_shape == value) return;
    _shape = value;
    _markNeedsLayout(.shape);
  }
}
