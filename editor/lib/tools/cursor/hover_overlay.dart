// part of 'cursor_tool.dart';

// class HoverOverlay extends StatelessWidget {
//   const HoverOverlay({
//     super.key,
//     required this.childPaintTransform,
//     required this.hoveredCell,
//   });

//   final Matrix4 childPaintTransform;
//   final CellRef? hoveredCell;

//   @override
//   Widget build(BuildContext context) {
//     final editor = context.editor;

//     return IgnorePointer(
//       child: CustomPaint(
//         painter: _HoverOverlayPainter(
//           editor: editor,
//           childPaintTransform: childPaintTransform,
//           hoveredCell: hoveredCell,
//           primaryColor: context.colors.selection,
//           secondaryColor: context.colors.selection.withOpacity(0.5),
//         ),
//       ),
//     );
//   }
// }

// class _HoverOverlayPainter extends CustomPainter {
//   const _HoverOverlayPainter({
//     required this.editor,
//     required this.childPaintTransform,
//     required this.hoveredCell,
//     required this.primaryColor,
//     required this.secondaryColor,
//   });

//   final Editor editor;
//   final Matrix4 childPaintTransform;
//   final Color primaryColor;
//   final Color secondaryColor;
//   final CellRef? hoveredCell;

//   void _paintVertexHandle(Canvas canvas, Vec2 position) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final paint2 = Paint()
//       ..color = primaryColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;

//     final p = MatrixUtils.transformPoint(childPaintTransform, position.offset);
//     final rect = Rect.fromCircle(center: p, radius: 4.0);
//     canvas.drawRect(rect, paint2);
//     canvas.drawRect(rect, paint);
//   }

//   void _paintEdgeControlPoint(Canvas canvas, Vec2 origin, Vec2 control) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final paint2 = Paint()
//       ..color = secondaryColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;

//     final p1 = MatrixUtils.transformPoint(childPaintTransform, origin.offset);
//     final p2 = MatrixUtils.transformPoint(childPaintTransform, control.offset);
//     canvas.drawLine(p1, p2, paint2);

//     canvas.drawCircle(p2, 4.0, paint2);
//     canvas.drawCircle(p2, 4.0, paint);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final hoveredCell = this.hoveredCell;
//     final bundle = editor.bundle;
//     if (hoveredCell == null) return;

//     if (hoveredCell.kind == .vertex) {
//       final handle = bundle.vertex(hoveredCell.asVertex)!;
//       final position = bundle.vertexPosition(handle, space: .root);

//       final covertices = bundle.vertexUses(handle);
//       for (final cv in covertices) {
//         final tangent = bundle.covertexTangent(cv, space: .root);
//         _paintEdgeControlPoint(canvas, position, tangent + position);
//       }

//       _paintVertexHandle(canvas, position);
//     } else if (hoveredCell.kind == .edge) {
//       final cubic = bundle.edgeCubic(bundle.edge(hoveredCell.asEdge)!, space: .root);
//       final path = _cubicPath(cubic).transform(childPaintTransform.storage);
//       final paint = Paint()
//         ..color = primaryColor
//         ..strokeWidth = 2.0
//         ..strokeCap = .round
//         ..style = PaintingStyle.stroke;
//       _paintEdgeControlPoint(canvas, cubic.p0, cubic.p1);
//       _paintEdgeControlPoint(canvas, cubic.p3, cubic.p2);
//       canvas.drawPath(path, paint);
//       _paintVertexHandle(canvas, cubic.p0);
//       _paintVertexHandle(canvas, cubic.p3);
//     } else if (hoveredCell.kind == .face) {
//       final path = _facePath(bundle, bundle.handle(hoveredCell.asFace)!).transform(childPaintTransform.storage);
//       final paint = Paint()
//         ..color = primaryColor
//         ..strokeWidth = 2.0
//         ..strokeCap = .round
//         ..style = .stroke;
//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _HoverOverlayPainter oldDelegate) =>
//       oldDelegate.hoveredCell != hoveredCell || oldDelegate.childPaintTransform != childPaintTransform;
// }

// Path _cubicPath(Cubic2 cubic) {
//   final path = Path();
//   path.moveTo(cubic.p0.x, cubic.p0.y);
//   path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
//   return path;
// }

// Path _facePath(Bundle bundle, FaceHandle f) {
//   final path = Path()..fillType = .nonZero;

//   for (final cycle in bundle.faceBoundary(f)) {
//     var first = true;
//     for (final u in cycle) {
//       var cubic = bundle.edgeCubic(u.edge, space: .root);
//       if (!u.forward) cubic = cubic.reversed();

//       if (first) {
//         path.moveTo(cubic.p0.x, cubic.p0.y);
//         first = false;
//       }

//       path.cubicTo(cubic.p1.x, cubic.p1.y, cubic.p2.x, cubic.p2.y, cubic.p3.x, cubic.p3.y);
//     }

//     path.close();
//   }

//   return path;
// }
