import 'package:editor/imports.dart';
import 'package:editor/widgets/handles/cell_handles_painters.dart';

class TransientEdgesWidget extends HookWidget {
  const TransientEdgesWidget({
    super.key,
    required this.transform,
    this.topological = true,
    this.startPosition,
  });

  final Matrix4 transform;
  final bool topological;
  final Vec2? startPosition;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final transientEdges = useListenable(editor.transientEdges);

    return Stack(
      children: [
        _StartPositionWidget(
          startPosition: startPosition,
          transform: transform,
        ),
        for (final edge in transientEdges.instances)
          _TransientEdgeWidget(
            edge: edge,
            transform: transform,
            topological: topological,
          ),
      ],
    );
  }
}

class _TransientEdgeWidget extends HookWidget {
  const _TransientEdgeWidget({
    super.key,
    required this.edge,
    required this.transform,
    required this.topological,
  });

  final TransientEdge edge;
  final Matrix4 transform;
  final bool topological;

  @override
  Widget build(BuildContext context) {
    final edge = useListenable(this.edge);

    return CustomPaint(
      painter: _TransientEdgePainter(
        edge: edge,
        transform: transform,
        primaryColor: context.colors.selection.primary,
        secondaryColor: context.colors.selection.secondary,
        topological: topological,
      ),
    );
  }
}

class _TransientEdgePainter extends CustomPainter {
  _TransientEdgePainter({
    required this.edge,
    required this.transform,
    required this.primaryColor,
    required this.secondaryColor,
    required this.topological,
  });

  final TransientEdge edge;
  final Matrix4 transform;
  final Color primaryColor;
  final Color secondaryColor;
  final bool topological;

  @override
  void paint(Canvas canvas, Size size) {
    final cubic = edge.cubic.transformed(.fromListFloat64(transform.storage));
    final p0 = cubic.p0.offset, p1 = cubic.p1.offset, p2 = cubic.p2.offset, p3 = cubic.p3.offset;

    if (edge.end == null) {
      paintCovertexTangent(canvas, p0, p1, secondaryColor);
      paintCovertexHandle(canvas, p1, primaryColor, secondaryColor);
      paintVertexHandle(canvas, p0, primaryColor, secondaryColor);
    } else {
      paintCovertexTangent(canvas, p0, p1, secondaryColor);
      paintCovertexTangent(canvas, p3, p2, secondaryColor);
      paintEdgeHandle(canvas, cubic, primaryColor);
      paintVertexHandle(canvas, p0, primaryColor, secondaryColor);
      paintVertexHandle(canvas, p3, primaryColor, secondaryColor);
      paintCovertexHandle(canvas, p1, primaryColor, secondaryColor);
      paintCovertexHandle(canvas, p2, primaryColor, secondaryColor);
    }

    if (topological) {
      for (final intersection in edge.intersections) {
        final p = intersection.point.offset;
        paintIntersectionHandle(canvas, MatrixUtils.transformPoint(transform, p), primaryColor, secondaryColor);
      }
    }
  }

  @override
  bool shouldRepaint(_TransientEdgePainter oldDelegate) =>
      oldDelegate.edge != edge ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.transform != transform ||
      oldDelegate.topological != topological;
}

class _StartPositionWidget extends StatelessWidget {
  const new({
    super.key,
    this.startPosition,
    required this.transform,
  });

  final Vec2? startPosition;
  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StartPositionPainter(
        startPosition: startPosition,
        transform: transform,
        primaryColor: context.colors.selection.primary,
        secondaryColor: context.colors.selection.secondary,
      ),
    );
  }
}

class _StartPositionPainter extends CustomPainter {
  _StartPositionPainter({
    required this.startPosition,
    required this.transform,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final Vec2? startPosition;
  final Matrix4 transform;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (startPosition != null) {
      final p = MatrixUtils.transformPoint(transform, startPosition!.offset);
      paintVertexHandle(canvas, p, primaryColor, secondaryColor);
    }
  }

  @override
  bool shouldRepaint(_StartPositionPainter oldDelegate) =>
      oldDelegate.startPosition != startPosition || oldDelegate.transform != transform;
}
