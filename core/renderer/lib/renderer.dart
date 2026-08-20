import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:scene/scene.dart';

class SceneWidget extends StatefulWidget {
  const SceneWidget({super.key, required this.scene});

  final Scene scene;

  @override
  State<SceneWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  Scene get scene => widget.scene;

  @override
  void initState() {
    super.initState();
    scene.addListener(_onSceneChanged);
  }

  @override
  void didUpdateWidget(SceneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene != scene) {
      oldWidget.scene.removeListener(_onSceneChanged);
      scene.addListener(_onSceneChanged);
    }
  }

  @override
  void dispose() {
    scene.removeListener(_onSceneChanged);
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    scene.evaluate();
  }

  void _onSceneChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ScenePainter(scene: scene));
  }
}

final colors = Colors.primaries;
var _random = math.Random();
var _seed = 33;
Color get color => colors[_random.nextInt(colors.length)];

class ScenePainter extends CustomPainter {
  ScenePainter({required this.scene});

  final Scene scene;
  TopologyBundle get bundle => scene.bundle;
  StyleTable get style => scene.style;

  @override
  void paint(Canvas canvas, Size size) {
    final transform = Matrix4.fromFloat64List(canvas.getTransform());
    final inverse = Matrix4.inverted(transform);

    _random = math.Random(_seed);
    canvas.save();
    canvas.transform(inverse.storage);
    _paintFrame(canvas, bundle.root, transform, 0);
    canvas.restore();
  }

  void _paintFrame(Canvas canvas, FrameHandle frame, Matrix4 parent, int depth) {
    final transform = parent.multiplied(bundle.frameTransform(frame).asVM());

    for (final child in bundle.frameChildren(frame)) {
      final _ = switch (child.kind) {
        .vertex => _paintVertex(canvas, child.asVertex, transform),
        .edge => _paintEdge(canvas, child.asEdge, transform),
        .face => _paintFace(canvas, child.asFace, transform, depth),
        .frame => _paintFrame(canvas, child.asFrame, transform, depth + 1),
      };
    }
  }

  void _paintVertex(Canvas canvas, VertexHandle vertex, Matrix4 transform) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = .fill;

    final pos = bundle.vertexPosition(vertex);
    canvas.drawCircle(
      MatrixUtils.transformPoint(transform, Offset(pos.x, pos.y)),
      4,
      paint,
    );
  }

  void _paintEdge(Canvas canvas, EdgeHandle edge, Matrix4 transform) {
    final edgeRef = scene.refOf(bundle.edgeKey(edge));
    final style = this.style.of<EdgeStyle>(edgeRef!)!;

    final paint = Paint()
      ..color = style.color.toUiColor()
      ..strokeWidth = style.width
      ..style = .stroke;

    final cubic = bundle.edgeCubic(edge);
    final path = _cubicPath(cubic);

    canvas.save();
    canvas.transform(transform.storage);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _paintFace(Canvas canvas, FaceHandle face, Matrix4 transform, int depth) {
    final faceRef = scene.refOf(bundle.faceKey(face));
    final style = this.style.of<FaceStyle>(faceRef!)!;

    final paint = Paint()..color = style.color.toUiColor();

    var path = _facePath(bundle, face);
    path = path.transform(transform.storage);
    canvas.drawPath(path, paint);

    // canvas.save();
    // canvas.clipPath(path);

    // const spacing = 8.0;
    // final b = path.getBounds().inflate(spacing);

    // final s = depth.isEven ? 1.0 : -1.0;
    // final top = s * b.top, bottom = s * b.bottom;

    // final from = b.left + math.min(top, bottom);
    // final to = b.right + math.max(top, bottom);

    // for (var c = from; c <= to; c += spacing * math.sqrt2) {
    //   canvas.drawLine(Offset(c - top, b.top), Offset(c - bottom, b.bottom), stripePaint);
    // }

    // canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Path _cubicPath(Cubic2 cubic) {
  final path = Path();
  path.moveTo(cubic.p0.x, cubic.p0.y);
  path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
  return path;
}

Path _facePath(TopologyBundle bundle, FaceHandle f) {
  final path = Path()..fillType = .nonZero;
  final space = bundle.parentOf(f)!;

  for (final cycle in bundle.faceBoundary(f)) {
    var first = true;
    for (final u in cycle) {
      var cubic = bundle.edgeCubic(u.edge, space: space);
      if (!u.forward) cubic = cubic.reversed();

      if (first) {
        path.moveTo(cubic.p0.x, cubic.p0.y);
        first = false;
      }

      path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
    }

    path.close();
  }

  return path;
}
