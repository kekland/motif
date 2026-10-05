import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:color/color_flutter.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';

void paintEdge(ui.Canvas canvas, ui.Path path, Scene scene, EdgeStyle style, StatementId id) {
  final paint = ui.Paint()
    ..style = .stroke
    ..strokeWidth = style.width
    ..strokeCap = .butt
    ..strokeJoin = .bevel;

  final dst = path.getBounds().inflate(style.width / 2.0);
  _paintInternal(canvas, path, paint, dst, scene, style.decorations, id);
}

void paintFace(ui.Canvas canvas, ui.Path path, Scene scene, FaceStyle style, StatementId id) {
  final paint = ui.Paint()..style = .fill;
  final dst = path.getBounds();

  _paintInternal(canvas, path, paint, dst, scene, style.decorations, id);
}

Matrix4 _fit(ui.Image img, ui.Rect dst) {
  final s = math.max(dst.width / img.width, dst.height / img.height);
  final dx = dst.left + (dst.width - img.width * s) / 2;
  final dy = dst.top + (dst.height - img.height * s) / 2;

  return Matrix4.identity()
    ..translateByDouble(dx, dy, 0, 1)
    ..scaleByDouble(s, s, 1, 1);
}

void _paintInternal(
  ui.Canvas canvas,
  ui.Path path,
  ui.Paint paint,
  ui.Rect dst,
  Scene scene,
  Decorations decorations,
  StatementId id,
) {
  void pushDecoration(Decoration decoration) {
    if (decoration is ColorDecoration) {
      paint.color = decoration.color.toUiColor();
    } else if (decoration is ImageDecoration) {
      final imageHash = decoration.image;
      if (imageHash == null) return;

      final image = scene.evaluation.assetManifest.image(imageHash);
      scene.evaluation.loadAsset(id, image!);

      final uiImage = scene.assetCache.image[imageHash];
      if (uiImage == null) return;

      paint.color = const .new(0xFFFFFFFF);
      paint.shader = ui.ImageShader(uiImage, .clamp, .clamp, _fit(uiImage, dst).storage, filterQuality: .medium);
    } else {
      throw UnimplementedError();
    }
  }

  void popDecoration(Decoration decoration) {
    if (decoration is ColorDecoration) {
      paint.color = const .new(0x00000000);
    } else if (decoration is ImageDecoration) {
      paint.color = const .new(0x00000000);
      paint.shader = null;
    } else {
      throw UnimplementedError();
    }
  }

  for (final decoration in decorations.entries) {
    pushDecoration(decoration);
    canvas.drawPath(path, paint);
    popDecoration(decoration);
  }
}
