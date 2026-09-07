part of '../../program.dart';

sealed class ShapeStatement<S extends ObjectShape> extends Statement with PlacedStatement, LayoutBoxStatement {
  ShapeStatement({
    required this.shape,
    LayoutSize? size,
    Mat4? transform,
    this.vertexStyle = .default_,
    this.edgeStyle = .default_,
    this.faceStyle = .default_,
    FrameRef? parent,
    super.id,
    super.modifiers,
  }) : size = size ?? .zero,
       transform = transform ?? .identity(),
       parent = .of(parent);

  @override
  final LayoutSize size;

  @override
  final Mat4 transform;

  @override
  Size2 get intrinsicSize => .zero();

  final VertexStyle vertexStyle;
  final EdgeStyle edgeStyle;
  final FaceStyle faceStyle;
  final S shape;

  @override
  final ParentSelector? parent;

  @override
  late final selectors = [?parent];

  late final frame = shape.frameOf(id);
  late final face = shape.faceOf(id);

  @override
  Iterable<Op> execute(EvalContext context) {
    final (transform, size) = resolveBox(context);

    return shape.execute(
      context,
      transform,
      size,
      parent: context.maybeResolve(parent),
      vertexStyle: vertexStyle,
      edgeStyle: edgeStyle,
      faceStyle: faceStyle,
    );
  }

  @override
  ShapeStatement<S> copyWith({
    StatementId? id,
    List<Statement>? modifiers,
    LayoutSize? size,
    Mat4? transform,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    FrameRef? parent,
  });

  @override
  DissolveIntent routeDissolve(Set<CellRef<CellHandle>> targeted) => .new({frame});

  @override
  TransformResult routeTransform(EvalContext context, Set<CellRef> targets) {
    final bundle = context.bundle;
    final space = context.handle(frame);
    final oldSize = context.placementOf(id).size;

    if (targets.any((t) => t.kind == .frame || t.kind == .face)) return _absorbWhole(context, oldSize);

    final points = <Vec2>[];
    for (final t in targets) {
      if (t.kind == .vertex) {
        points.add(bundle.vertexPosition(context.handle(t).asVertex, space: space));
      } else if (t.kind == .edge) {
        final h = context.handle(t).asEdge;
        points.add(bundle.vertexPosition(bundle.edgeStart(h), space: space));
        points.add(bundle.vertexPosition(bundle.edgeEnd(h), space: space));
      } else {
        throw ArgumentError('invalid target ${t.kind} for shape transform');
      }
    }

    final pointsX = points.map((p) => p.x).toList();
    final pointsY = points.map((p) => p.y).toList();

    final x = _ResizeAxis.resolve(pointsX, oldSize.width);
    final y = _ResizeAxis.resolve(pointsY, oldSize.height);
    if (x.min && x.max && y.min && y.max) return _absorbWhole(context, oldSize);

    final inParent = <Vec2>[];
    for (final p in points) inParent.add(transform.transform2(p));
    final toLocal = transform.inverted();

    return .absorb(
      (m) {
        final to = <Vec2>[];
        for (final p in inParent) to.add(toLocal.transform2(m.transform2(p)));
        final toX = to.map((p) => p.x).toList();
        final toY = to.map((p) => p.y).toList();

        final (w, dx) = x.solve(pointsX, toX, oldSize.width);
        final (h, dy) = y.solve(pointsY, toY, oldSize.height);
        return copyWith(
          transform: transform.translated(dx, dy),
          size: .fixed(w, h),
        );
      },
      frame,
    );
  }

  TransformResult _absorbWhole(EvalContext context, Size2 oldSize) {
    return .absorb(
      (m) {
        final composed = m * transform;
        final size = oldSize.scale(composed.scaleX, composed.scaleY);
        return copyWith(
          transform: composed.withNormalizedScale(),
          size: .fixed(size.width, size.height),
        );
      },
      frame,
    );
  }
}

final class _ResizeAxis(final bool min, final bool max, final bool inside) {
  static const _eps = 1e-6;

  static _ResizeAxis resolve(Iterable<double> points, double extent) {
    var min = false, max = false, inside = false;
    for (final p in points) {
      final u = extent <= _eps ? 0.5 : p / extent;
      if (u.abs() < _eps) {
        min = true;
      } else if ((u - 1).abs() < _eps) {
        max = true;
      } else {
        inside = true;
      }
    }

    return _ResizeAxis(min, max, inside);
  }

  (double, double) solve(List<double> points, List<double> to, double extent) {
    final d = to.first - points.first;
    var rigid = true;
    for (var i = 1; i < points.length; i++) {
      rigid = (to[i] - points[i] - d).abs() < _eps;
      if (!rigid) break;
    }
    if (rigid) return (extent, d);

    var lo = 0.0, hi = extent;
    var shift = 0.0;
    var n = 0;

    for (var i = 0; i < points.length; i++) {
      final u = extent <= _eps ? 0.5 : points[i] / extent;
      if (u.abs() < _eps) {
        lo = to[i];
      } else if ((u - 1).abs() < _eps) {
        hi = to[i];
      } else {
        shift += to[i] - points[i];
        n++;
      }
    }

    if (!min && !max) return (extent, n == 0 ? 0 : shift / n);
    return (math.max(hi - lo, 0), lo);
  }
}
