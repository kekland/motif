import 'package:editor/imports.dart';
import 'package:editor/widgets/handles/cell_handles_painters.dart';

class TransientEdgesWidget extends HookWidget {
  const TransientEdgesWidget({super.key, required this.transform});

  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final editor = context.editor;
    final transientEdges = useListenable(editor.transientEdges);

    return Stack(
      children: [
        for (final edge in transientEdges.instances)
          _TransientEdgeWidget(
            edge: edge,
            transform: transform,
          ),
      ],
    );
  }
}

class _TransientEdgeWidget extends HookWidget {
  const _TransientEdgeWidget({super.key, required this.edge, required this.transform});

  final TransientEdge edge;
  final Matrix4 transform;

  @override
  Widget build(BuildContext context) {
    final edge = useListenable(this.edge);

    return CustomPaint(
      painter: _TransientEdgePainter(
        edge: edge,
        transform: transform,
        primaryColor: context.colors.selection.primary,
        secondaryColor: context.colors.selection.secondary,
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
  });

  final TransientEdge edge;
  final Matrix4 transform;
  final Color primaryColor;
  final Color secondaryColor;

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
  }

  @override
  bool shouldRepaint(_TransientEdgePainter oldDelegate) =>
      oldDelegate.edge != edge ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.transform != transform;
}
