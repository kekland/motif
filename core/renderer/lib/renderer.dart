import 'dart:ui' as ui;

import 'package:kernel/kernel.dart';
import 'package:program/program.dart';

import 'paint.dart' as painter;

export 'widget.dart';

final class ProgramRenderer {
  new(this.evaluation) {
    evaluation.addUpdateListener(_onEvaluationUpdate);
  }

  final Evaluation evaluation;
  Bundle get bundle => evaluation.bundle;
  final _cache = <FrameRef, List<DrawEntry>>{};

  void _onEvaluationUpdate(EvaluationPass pass) {
    for (final r in pass.deleted) _invalidate(pass, r, removed: true);
    for (final r in pass.added) _invalidate(pass, r);
    for (final r in pass.moved) if (r.kind != .frame) _invalidate(pass, r);
    for (final r in pass.reordered) _invalidate(pass, r);
    for (final r in pass.restyled) _invalidate(pass, r);
  }

  void _invalidate(EvaluationPass pass, CellRef r, {bool removed = false}) {
    if (removed && r.kind == .frame) _stale(r as FrameRef);
    final frame = pass.frameOf(r);
    if (frame != null) _stale(frame);
  }

  void _stale(FrameRef r) {
    final segments = _cache.remove(r);
    if (segments == null) return;
    for (final s in segments) {
      if (s is DrawPicture) s.picture.dispose();
    }
  }

  void dispose() {
    for (final f in _cache.keys) _stale(f);
    _cache.clear();
    evaluation.removeUpdateListener(_onEvaluationUpdate);
  }

  void paint(ui.Canvas canvas) {
    _paintFrame(canvas, bundle.root, 0);
  }

  void _paintFrame(ui.Canvas canvas, FrameHandle frame, int depth) {
    canvas.save();
    canvas.transform(bundle.frameTransform(frame).storage64);

    final entries = _cache.putIfAbsent(frame.ref(bundle), () => painter.paintFrame(evaluation, frame, depth));
    for (final e in entries) {
      final _ = switch (e) {
        DrawPicture(:final picture) => canvas.drawPicture(picture),
        DrawFrame(:final frame) => _paintFrame(canvas, frame, depth + 1),
      };
    }

    canvas.restore();
  }

  void reassemble() {
    for (final f in _cache.keys.toList()) _stale(f);
  }
}

sealed class DrawEntry();
final class DrawPicture(final ui.Picture picture) extends DrawEntry;
final class DrawFrame(final FrameHandle frame) extends DrawEntry;
