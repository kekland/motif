import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';

extension _OffsetExt on ui.Offset {
  Vector2 get v2 => Vector2(dx, dy);
}

(Cubic2, Cubic2, Vector2, Vector2, Vector2) _generateCubics(ui.Rect src, ui.Rect dst) {
  final centerDx = dst.center.dx - src.center.dx;
  final centerDy = dst.center.dy - src.center.dy;

  late final (Vector2, Vector2) srcEdge;
  late final (Vector2, Vector2) dstEdge;
  late final double dx, dy;

  if (centerDx.abs() > centerDy.abs()) {
    if (centerDx > 0) {
      // src to the left of dst
      srcEdge = (src.topLeft.v2, src.bottomLeft.v2);
      dstEdge = (dst.topRight.v2, dst.bottomRight.v2);
      dx = dst.right - src.left;
      dy = 0.0;
    } else {
      // src to the right of dst
      srcEdge = (src.topRight.v2, src.bottomRight.v2);
      dstEdge = (dst.topLeft.v2, dst.bottomLeft.v2);
      dx = dst.left - src.right;
      dy = 0.0;
    }
  } else {
    if (centerDy > 0) {
      // src above dst
      srcEdge = (src.topLeft.v2, src.topRight.v2);
      dstEdge = (dst.bottomLeft.v2, dst.bottomRight.v2);
      dx = 0.0;
      dy = dst.bottom - src.top;
    } else {
      // src below dst
      srcEdge = (src.bottomLeft.v2, src.bottomRight.v2);
      dstEdge = (dst.topLeft.v2, dst.topRight.v2);
      dx = 0.0;
      dy = dst.top - src.bottom;
    }
  }

  final m = Vector2(dx, dy);
  Cubic2 smooth(Vector2 s, Vector2 p) => .new(
    s,
    p,
    p1: s + m * (1 / 3),
    p2: p - m * (1 / 3),
  );

  return (
    smooth(srcEdge.$1, dstEdge.$1),
    smooth(srcEdge.$2, dstEdge.$2),
    (srcEdge.$1 + srcEdge.$2) * 0.5,
    (dstEdge.$1 + dstEdge.$2) * 0.5,
    .new(dx.sign, dy.sign),
  );
}

class GenieTransition extends StatelessWidget {
  const GenieTransition({
    super.key,
    required this.animation,
    required this.child,
    required this.src,
  });

  final Animation<double> animation;
  final Widget child;
  final Rect src;

  @override
  Widget build(BuildContext context) {
    const _t0 = Interval(0.65, 1.0, curve: Curves.easeInOut);
    const _t1 = Interval(0.0, 0.7, curve: Curves.easeInOut);
    const _tOpacity = Interval(0.15, 0.3, curve: Curves.easeInOut);

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = animation.value;
        final t0 = _t0.transform(t);
        final t1 = _t1.transform(t);
        final tOpacity = _tOpacity.transform(t);

        return _GenieTransitionWidget(
          src: src,
          t0: t0,
          t1: t1,
          tOpacity: tOpacity,
          child: child!,
        );
      },
    );
  }
}

ui.FragmentProgram? _fragmentProgram;
Future<ui.FragmentProgram>? _fragmentProgramFuture;
FutureOr<ui.FragmentProgram> _loadFragmentProgram() {
  if (_fragmentProgram != null) return _fragmentProgram!;
  if (_fragmentProgramFuture != null) return _fragmentProgramFuture!;

  _fragmentProgramFuture = ui.FragmentProgram.fromAsset('packages/genie/lib/genie.frag');
  _fragmentProgramFuture!.then((program) => _fragmentProgram = program);
  return _fragmentProgramFuture!;
}

class _GenieTransitionWidget extends SingleChildRenderObjectWidget {
  const _GenieTransitionWidget({
    super.key,
    required super.child,
    required this.src,
    this.t0 = 0.0,
    this.t1 = 0.0,
    this.tOpacity = 1.0,
  });

  final Rect src;
  final double t0;
  final double t1;
  final double tOpacity;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final overlay = Overlay.of(context).context.findRenderObject()!;

    return _GenieTransitionRenderObject(
      src: src,
      pixelRatio: pixelRatio,
      t0: t0,
      t1: t1,
      tOpacity: tOpacity,
      overlay: overlay,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _GenieTransitionRenderObject renderObject) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final overlay = Overlay.of(context).context.findRenderObject()!;

    renderObject.src = src;
    renderObject.pixelRatio = pixelRatio;
    renderObject.t0 = t0;
    renderObject.t1 = t1;
    renderObject.tOpacity = tOpacity;
    renderObject.overlay = overlay;
  }
}

const _kDebugShowGenieSplines = false;

class _GenieTransitionRenderObject extends RenderProxyBox {
  _GenieTransitionRenderObject({
    required this._src,
    required this._pixelRatio,
    required this._t0,
    required this._t1,
    required this._tOpacity,
    required this._overlay,
  }) {
    final programFutureOr = _loadFragmentProgram();
    if (programFutureOr is Future<ui.FragmentProgram>) {
      programFutureOr.then((_) => markNeedsPaint());
    }
  }

  Rect _src;
  Rect get src => _src;
  set src(Rect value) {
    if (_src == value) return;
    _src = value;
    markNeedsPaint();
  }

  double _pixelRatio;
  double get pixelRatio => _pixelRatio;
  set pixelRatio(double value) {
    if (_pixelRatio == value) return;
    _pixelRatio = value;
    markNeedsPaint();
  }

  double _t0;
  double get t0 => _t0;
  set t0(double value) {
    if (_t0 == value) return;
    _t0 = value;
    markNeedsPaint();
  }

  double _t1;
  double get t1 => _t1;
  set t1(double value) {
    if (_t1 == value) return;
    _t1 = value;
    markNeedsPaint();
  }

  double _tOpacity;
  double get tOpacity => _tOpacity;
  set tOpacity(double value) {
    if (_tOpacity == value) return;
    _tOpacity = value;
    markNeedsPaint();
  }

  RenderObject _overlay;
  RenderObject get overlay => _overlay;
  set overlay(RenderObject value) {
    if (_overlay == value) return;
    _overlay = value;
    markNeedsPaint();
  }

  ui.FragmentShader? _shader;

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  void _debugPaint(
    PaintingContext context,
    Rect src,
    Rect dst,
    (Cubic2, Cubic2) cubics,
    (Vector2, Vector2) edgeCenters,
  ) {
    final (c1, c2) = cubics;
    final canvas = context.canvas;

    // draw src/dst
    canvas.drawRect(
      src,
      Paint()
        ..color = const Color(0xFF0000FF)
        ..style = .stroke,
    );
    canvas.drawRect(
      dst,
      Paint()
        ..color = const Color(0xFFFF0000)
        ..style = .stroke,
    );

    // draw cubics
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = .stroke;

    final path1 = Path()
      ..moveTo(c1.p0.x, c1.p0.y)
      ..cubicTo(c1.p1.x, c1.p1.y, c1.p2.x, c1.p2.y, c1.p3.x, c1.p3.y);

    final path2 = Path()
      ..moveTo(c2.p0.x, c2.p0.y)
      ..cubicTo(c2.p1.x, c2.p1.y, c2.p2.x, c2.p2.y, c2.p3.x, c2.p3.y);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);

    // draw edge centers and line
    final paint2 = Paint()
      ..color = const Color(0xFFFFFF00)
      ..style = .stroke;

    final (srcEdgeCenter, dstEdgeCenter) = edgeCenters;
    canvas.drawLine(.new(srcEdgeCenter.x, srcEdgeCenter.y), .new(dstEdgeCenter.x, dstEdgeCenter.y), paint2);

    canvas.drawCircle(.new(srcEdgeCenter.x, srcEdgeCenter.y), 4.0, paint2);
    canvas.drawCircle(.new(dstEdgeCenter.x, dstEdgeCenter.y), 4.0, paint2);
  }

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    final src = MatrixUtils.transformRect(overlay.getTransformTo(this), this.src);
    final dst = child!.paintBounds;
    final totalRect = src.expandToInclude(dst);

    const shadowMargin = 16.0;
    final paddedTotalRect = totalRect.inflate(shadowMargin);

    final shift = paddedTotalRect.topLeft;

    final srcNormalized = src.shift(-shift);
    final dstNormalized = dst.shift(-shift);

    final (c1, c2, srcEdgeCenter, dstEdgeCenter, direction) = _generateCubics(srcNormalized, dstNormalized);

    if (_kDebugShowGenieSplines) {
      context.canvas.save();
      context.canvas.translate(offset.dx + shift.dx, offset.dy + shift.dy);
      _debugPaint(
        context,
        srcNormalized,
        dstNormalized,
        (c1, c2),
        (srcEdgeCenter, dstEdgeCenter),
      );
      context.canvas.restore();
    }

    if (t0 == 1.0 && t1 == 1.0 && tOpacity == 1.0) {
      context.paintChild(child!, offset);
      return;
    }

    // Shader
    if (_fragmentProgram == null) {
      return;
    } else {
      _shader ??= _fragmentProgram!.fragmentShader();
      final shader = _shader!;

      final transform = Matrix4.fromFloat64List(context.canvas.getTransform());
      final localOrigin = shift + offset;
      var physicalOrigin = MatrixUtils.transformPoint(transform, localOrigin);

      physicalOrigin = Offset(
        physicalOrigin.dx < 0.0 ? physicalOrigin.dx : 0.0,
        physicalOrigin.dy < 0.0 ? physicalOrigin.dy : 0.0,
      );

      // 0-1: u_size
      var i = 2;
      shader.setFloat(i++, pixelRatio);
      shader.setFloat(i++, physicalOrigin.dx);
      shader.setFloat(i++, physicalOrigin.dy);
      shader.setFloat(i++, 64.0);

      shader.setFloat(i++, srcNormalized.left);
      shader.setFloat(i++, srcNormalized.top);
      shader.setFloat(i++, srcNormalized.width);
      shader.setFloat(i++, srcNormalized.height);
      shader.setFloat(i++, dstNormalized.left);
      shader.setFloat(i++, dstNormalized.top);
      shader.setFloat(i++, dstNormalized.width);
      shader.setFloat(i++, dstNormalized.height);

      shader.setFloat(i++, paddedTotalRect.width);
      shader.setFloat(i++, paddedTotalRect.height);

      shader.setFloat(i++, c1.p0.x);
      shader.setFloat(i++, c1.p1.x);
      shader.setFloat(i++, c1.p2.x);
      shader.setFloat(i++, c1.p3.x);
      shader.setFloat(i++, c1.p0.y);
      shader.setFloat(i++, c1.p1.y);
      shader.setFloat(i++, c1.p2.y);
      shader.setFloat(i++, c1.p3.y);

      shader.setFloat(i++, c2.p0.x);
      shader.setFloat(i++, c2.p1.x);
      shader.setFloat(i++, c2.p2.x);
      shader.setFloat(i++, c2.p3.x);
      shader.setFloat(i++, c2.p0.y);
      shader.setFloat(i++, c2.p1.y);
      shader.setFloat(i++, c2.p2.y);
      shader.setFloat(i++, c2.p3.y);

      shader.setFloat(i++, direction.x);
      shader.setFloat(i++, direction.y);
      shader.setFloat(i++, srcEdgeCenter.x);
      shader.setFloat(i++, srcEdgeCenter.y);
      shader.setFloat(i++, dstEdgeCenter.x);
      shader.setFloat(i++, dstEdgeCenter.y);

      shader.setFloat(i++, t0);
      shader.setFloat(i++, t1);
      shader.setFloat(i++, tOpacity);

      final layer = ImageFilterLayer(imageFilter: .shader(shader));

      context.pushLayer(
        layer,
        (context, offset) {
          final offsetRect = paddedTotalRect.shift(offset);

          context.canvas.clipRect(offsetRect);
          context.canvas.drawRect(offsetRect, Paint()..color = Color(0x01000000));

          context.paintChild(child!, offset);
        },
        offset,
      );
    }
  }
}
