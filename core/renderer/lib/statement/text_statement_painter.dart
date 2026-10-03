part of '../paint.dart';

final class TextStatementPainter extends StatementPainter<TextStatement> {
  const TextStatementPainter();

  @override
  ui.Picture paint(Scene scene, TextStatement statement) {
    final e = scene.evaluation;
    final size = e.layout.placementOf(statement.id)!.size;
    final paragraph = statement.buildParagraph(e);
    paragraph.layout(size.width);

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final path = Path();

    for (final (i, metrics) in paragraph.glyphMetrics.indexed) {
      final glyphPath = paragraph.getGlyphPath(i);
      var point = 0;
      double _x() => glyphPath.points[point++] + metrics.x;
      double _y() => glyphPath.points[point++] + metrics.y;

      for (var j = 0; j < glyphPath.verbs.length; j++) {
        final verb = glyphPath.verbs[j];
        final _ = switch (verb) {
          .move => path.moveTo(_x(), _y()),
          .line => path.lineTo(_x(), _y()),
          .quad => path.quadraticBezierTo(_x(), _y(), _x(), _y()),
          .cubic => path.cubicTo(_x(), _y(), _x(), _y(), _x(), _y()),
          .close => path.close(),
          .conic => unreachable(),
          _ => unreachable(),
        };
      }
    }

    paintEdge(canvas, path, scene, statement.edgeStyle, statement.id);
    paintFace(canvas, path, scene, statement.faceStyle, statement.id);

    return recorder.endRecording();
  }
}
