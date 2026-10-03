import 'dart:ui' as ui;

import 'package:geometry/geometry.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:scene/scene.dart';

import 'paint.dart' as painter;

export 'widget.dart';

final class SceneRenderer {
  new(this.scene) {
    scene.evaluation.addUpdateListener(_onEvaluationUpdate);
    scene.assetCache.addFetchListener(_onAssetFetched);
  }

  final Scene scene;
  Bundle get bundle => scene.bundle;
  Evaluation get evaluation => scene.evaluation;

  final _cache = <FrameRef, List<DrawEntry>>{};

  void _onEvaluationUpdate(EvalPass pass) {
    final stale = <FrameRef>{...pass.movedFrames};
    void mark(CellRef r) {
      final f = pass.frameOf(r);
      if (f != null) stale.add(f);
    }

    for (final r in pass.deleted) {
      if (r.kind == .frame) stale.add(r as FrameRef);
      mark(r);
    }

    for (final r in pass.added) mark(r);
    for (final r in pass.restyled) mark(r);
    for (final r in pass.moved) {
      if (r.kind == .frame) {
        final statement = evaluation.statement(r.statementId);
        if (painter.isPaintedStatement(statement)) stale.add(r.asFrame);
      }
    }

    for (final f in stale) _stale(f);
  }

  void _stale(FrameRef r) {
    final segments = _cache.remove(r);
    if (segments == null) return;
    for (final s in segments) {
      if (s is DrawPicture) s.picture.dispose();
    }
  }

  void dispose() {
    for (final f in _cache.keys.toList()) _stale(f);
    _cache.clear();
    evaluation.removeUpdateListener(_onEvaluationUpdate);
    scene.assetCache.removeFetchListener(_onAssetFetched);
  }

  void paint(ui.Canvas canvas) {
    _paintFrame(canvas, .root, .root, 0, .identity());
  }

  void _paintFrame(ui.Canvas canvas, FrameRef ref, FrameHandle frame, int depth, Mat4 parentToWorld) {
    final transform = bundle.frameTransform(frame);

    canvas.save();
    canvas.transform(transform.storage64);

    final entries = _cache.putIfAbsent(ref, () => painter.paintFrame(scene, ref, frame, depth));
    for (final e in entries) {
      final _ = switch (e) {
        DrawPicture(:final picture) => canvas.drawPicture(picture),
        DrawFrame(:final ref, :final frame) => _paintFrame(canvas, ref, frame, depth + 1, parentToWorld * transform),
      };
    }

    canvas.restore();
  }

  void _onAssetFetched(StatementId id) {
    final products = scene.evaluation.productsOf(id);
    for (final cell in products) {
      final frame = cell.kind == .frame ? cell : bundle.parentOf(bundle.handle(cell)!)?.ref(bundle);
      if (frame != null) _stale(frame.asFrame);
    }
  }

  void reassemble() {
    for (final f in _cache.keys.toList()) _stale(f);
  }
}

sealed class DrawEntry();
final class DrawPicture(final ui.Picture picture) extends DrawEntry;
final class DrawFrame(final FrameRef ref, final FrameHandle frame) extends DrawEntry;
