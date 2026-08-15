import 'dart:math' as math;

import 'package:editor/imports.dart';

class TransientFaceWidget extends StatelessWidget {
  const TransientFaceWidget({
    super.key,
    required this.editor,
    required this.region,
    required this.childPaintTransform,
  });

  final Editor editor;
  final Region region;
  final Matrix4 childPaintTransform;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RegionPainter(
        editor: editor,
        region: region,
        transform: childPaintTransform,
        color: context.colors.accent.secondary,
      ),
    );
  }
}

class _RegionPainter extends CustomPainter {
  const _RegionPainter({
    required this.editor,
    required this.region,
    required this.transform,
    required this.color,
  });

  final Editor editor;
  final Region region;
  final Matrix4 transform;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var path = _regionPath(editor.bundle, region);
    path = path.transform(transform.storage);

    final stripePaint = Paint()
      ..color = color
      ..strokeWidth = 0.0
      ..style = .stroke;

    canvas.save();
    canvas.clipPath(path);

    const spacing = 8.0;
    final b = path.getBounds().inflate(spacing);

    final top = -b.top, bottom = -b.bottom;
    final from = b.left + math.min(top, bottom);
    final to = b.right + math.max(top, bottom);

    for (var c = from; c <= to; c += spacing * math.sqrt2) {
      canvas.drawLine(Offset(c - top, b.top), Offset(c - bottom, b.bottom), stripePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Path _regionPath(TopologyBundle bundle, Region region) {
  final path = Path()..fillType = .nonZero;
  path.addPath(_cyclePath(bundle, region.outer), .zero);
  for (final hole in region.holes) {
    path.addPath(_cyclePath(bundle, hole), .zero);
  }

  return path;
}

Path _cyclePath(TopologyBundle bundle, Cycle cycle) {
  final path = Path()..fillType = .nonZero;

  var first = true;
  for (final u in cycle) {
    var cubic = bundle.edgeCubicWorld(u.edge);
    if (!u.forward) cubic = cubic.reversed();

    if (first) {
      path.moveTo(cubic.p0.x, cubic.p0.y);
      first = false;
    }

    path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
  }

  path.close();

  return path;
}
