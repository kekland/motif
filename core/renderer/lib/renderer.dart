import 'dart:ui' as ui;

import 'package:kernel/kernel.dart';
import 'package:program/program.dart';

import 'paint.dart' as painter;

final class ProgramRenderer {
  new(this.evaluation) {
    evaluation.addUpdateListener(_onEvaluationUpdate);
  }

  final Evaluation evaluation;
  Bundle get bundle => evaluation.bundle;
  final _cache = <FrameRef, ui.Picture>{};

  void _onEvaluationUpdate(EvaluationPass pass) {
    for (final r in pass.added) _invalidate(r);
    for (final r in pass.deleted) _invalidate(r, removed: true);
    for (final r in pass.moved) _invalidate(r);
  }

  void _invalidate(CellRef r, {bool removed = false}) {
    if (r.kind == .frame) {
      if (removed) _cache.remove(r.asFrame)?.dispose();
      return;
    }

    final h = bundle.handle(r);
    if (h == null) return;
    final frame = bundle.parentOf(h);
    if (frame != null) _cache.remove(frame.ref(bundle))?.dispose();
  }

  void dispose() {
    for (final p in _cache.values) p.dispose();
    _cache.clear();
    evaluation.removeUpdateListener(_onEvaluationUpdate);
  }

  void paint(ui.Canvas canvas) {
    _paintFrame(canvas, bundle.root, 0);
  }

  void _paintFrame(ui.Canvas canvas, FrameHandle frame, int depth) {
    canvas.save();
    canvas.transform(bundle.frameTransform(frame).storage64);

    final picture = _cache.putIfAbsent(frame.ref(bundle), () => painter.paintFrame(bundle, frame, depth));
    canvas.drawPicture(picture);

    for (final child in bundle.frameChildren(frame)) {
      if (child.kind == .frame) _paintFrame(canvas, child.asFrame, depth + 1);
    }

    canvas.restore();
  }
}
