import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:dawn/dawn.dart' as dawn;

part 'tile_bucket.dart';

class TileGrid {
  TileGrid({this.tileSize = 256.0});

  final double tileSize;
  final Map<int, TileBucket> _activeTiles = {};

  int _tileKey(int row, int col) => (row << 16) | (col & 0xFFFF);
  void _createBucket(int row, int col) {
    assert(_activeTiles[_tileKey(row, col)] == null);

    final tileId = _tileKey(row, col);
    _activeTiles[tileId] = TileBucket(col, row, tileSize: tileSize);
  }

  void addQuad(Quadratic2 quad, double strokeWidth) {
    final padding = strokeWidth / 2.0;
    final bbox = quad.bbox;

    final startCol = ((bbox.min.x - padding) / tileSize).floor();
    final endCol = ((bbox.max.x + padding) / tileSize).floor();
    final startRow = ((bbox.min.y - padding) / tileSize).floor();
    final endRow = ((bbox.max.y + padding) / tileSize).floor();

    for (int r = startRow; r <= endRow; r++) {
      for (int c = startCol; c <= endCol; c++) {
        final tileId = _tileKey(r, c);
        if (_activeTiles[tileId] == null) _createBucket(r, c);
        _activeTiles[tileId]!.addQuad(quad);
      }
    }
  }

  static const bool _debug = true;
  void paint(
    ui.Canvas canvas,
    Rect viewportRect,
    Matrix4 localToGlobal,
    ui.FragmentProgram program,
    double strokeWidth,
  ) {
    var drawCalls = 0;

    for (final bucket in _activeTiles.values) {
      // final globalBounds = MatrixUtils.transformRect(localToGlobal, bucket.canvasBounds);
      if (!bucket.canvasBounds.overlaps(viewportRect)) continue;
      if (_debug) {
        final boundsPaint = ui.Paint()
          ..color = const ui.Color(0x80FF0000)
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 1.0;

        canvas.drawRect(bucket.canvasBounds, boundsPaint);
      }

      // ignore: constant_identifier_names
      const MAX_QUAD_COUNT = 128;

      for (int i = 0; i < bucket.quads.length; i += MAX_QUAD_COUNT) {
        final batch = bucket.quads.skip(i).take(MAX_QUAD_COUNT).toList();
        final shader = program.fragmentShader();

        shader.setFloat(0, strokeWidth);
        shader.setFloat(1, batch.length.toDouble());

        var floatIndex = 2;
        for (final q in batch) {
          shader.setFloat(floatIndex++, q.p0.x);
          shader.setFloat(floatIndex++, q.p0.y);
          shader.setFloat(floatIndex++, q.p1.x);
          shader.setFloat(floatIndex++, q.p1.y);
          shader.setFloat(floatIndex++, q.p2.x);
          shader.setFloat(floatIndex++, q.p2.y);
        }

        floatIndex = 2 + (MAX_QUAD_COUNT * 6);
        for (final q in batch) {
          final bbox = q.bbox;
          shader.setFloat(floatIndex++, bbox.min.x);
          shader.setFloat(floatIndex++, bbox.min.y);
          shader.setFloat(floatIndex++, bbox.max.x);
          shader.setFloat(floatIndex++, bbox.max.y);
        }

        ui.ImageDescriptor.raw(buffer, width: width, height: height, pixelFormat: pixelFormat).

        shader.setImageSampler(index, image)

        canvas.drawRect(bucket.canvasBounds, ui.Paint()..shader = shader);
        drawCalls++;
      }
    }

    print('Draw calls: $drawCalls');
  }
}
