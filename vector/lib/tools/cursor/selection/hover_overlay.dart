import 'package:vector/imports.dart';

class HoverOverlayBuilder extends StatelessWidget {
  const HoverOverlayBuilder({
    super.key,
    required this.controller,
    this.hoveredCell,
  });

  final VectorController controller;
  final Cell? hoveredCell;

  @override
  Widget build(BuildContext context) {
    return PersistentOverlayBuilder(
      builder: (context, info) => _HoverOverlay(
        controller: controller,
        childPaintTransform: info.childPaintTransform,
        hoveredCell: hoveredCell,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _HoverOverlay extends StatelessWidget {
  const _HoverOverlay({
    super.key,
    required this.controller,
    required this.childPaintTransform,
    this.hoveredCell,
  });

  final VectorController controller;
  final Matrix4 childPaintTransform;
  final Cell? hoveredCell;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (hoveredCell is Edge) {
      children.add(
        CustomPaint(
          painter: _EdgePainter(
            edge: hoveredCell as Edge,
            color: context.colors.accent.primary,
            transform: childPaintTransform,
          ),
        ),
      );
    } else if (hoveredCell is Vertex) {
      final incidentEdges = hoveredCell!.directStar.whereType<Edge>();
      for (var edge in incidentEdges) {
        children.add(
          CustomPaint(
            painter: _EdgePainter(
              edge: edge,
              color: context.colors.accent.primary,
              transform: childPaintTransform,
              dashPattern: (8.0, 8.0),
            ),
          ),
        );
      }
    }

    return MouseRegion(
      hitTestBehavior: .translucent,
      cursor: hoveredCell is Edge ? Cursors.toolCursorEdge : .defer,
      child: Stack(
        children: [
          ...children,
        ],
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  const _EdgePainter({
    required this.edge,
    required this.color,
    required this.transform,
    this.dashPattern,
  });

  final Edge edge;
  final Color color;
  final Matrix4 transform;
  final (double, double)? dashPattern;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = .stroke
      ..strokeCap = .round
      ..strokeJoin = .round
      ..strokeWidth = 2.0;

    var path = edge.getPath().transform(transform.storage);
    if (dashPattern != null) {
      path = path.dashed(dashLength: dashPattern!.$1, gapLength: dashPattern!.$2);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) => true;
}
