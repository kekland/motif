part of 'scene_tree_panel.dart';

class _NodeChildrenTreePainter extends CustomPainter {
  _NodeChildrenTreePainter({required this.depth, required this.color});

  final int depth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const childHeight = NodeTile.height;
    const indent = NodeTile.indent;

    final localIndent = depth * indent;
    final paddingLeft = 12.0 + 4.0 + localIndent;

    canvas.drawLine(
      Offset(paddingLeft, 0.0),
      Offset(paddingLeft, size.height - childHeight / 2.0),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_NodeChildrenTreePainter oldDelegate) => true;
}

class _NodeChildTreeBranchPainter extends CustomPainter {
  _NodeChildTreeBranchPainter({required this.color, required this.depth});

  final Color color;
  final int depth;

  @override
  void paint(Canvas canvas, Size size) {
    if (depth == 0) return;

    const indent = NodeTile.indent;
    final paddingLeft = (depth - 1) * indent + (indent / 2.0) - 2.0;

    canvas.drawLine(
      Offset(paddingLeft, 0.0),
      Offset(paddingLeft + 4.0, 0.0),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(_NodeChildTreeBranchPainter oldDelegate) => true;
}
