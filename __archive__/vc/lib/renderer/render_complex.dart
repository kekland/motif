import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:stack/stack.dart';
import '../renderer.dart';
import 'package:flutter/widgets.dart';

import 'hit_test/hit_test.dart' as hit_test;
import 'hit_test/rect_hit_test.dart' as rect_hit_test;
import 'debug/debug_renderer.dart' as debug_renderer;

const _kDebugPaintHitTests = false;

class VectorComplexWidget extends LeafRenderObjectWidget {
  const VectorComplexWidget({
    super.key,
    required this.complex,
    this.transientStrokes = const [],
    this.debug = false,
    this.resizeToFit = false,
  });

  final VectorComplexBase complex;
  final List<TransientStroke> transientStrokes;
  final bool debug;
  final bool resizeToFit;

  @override
  RenderVectorComplex createRenderObject(BuildContext context) {
    return .new(
      complex: complex,
      debug: debug,
      transientStrokes: transientStrokes,
      resizeToFit: resizeToFit,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderVectorComplex renderObject) {
    renderObject.complex = complex;
    renderObject.debug = debug;
    renderObject.transientStrokes = transientStrokes;
    renderObject.resizeToFit = resizeToFit;
  }
}

class RenderVectorComplex extends RenderBox {
  RenderVectorComplex({
    required this._complex,
    this._debug = false,
    this._resizeToFit = false,
    this._transientStrokes = const [],
  }) {
    _complex.addListener(markNeedsLayout);
  }

  VectorComplexBase _complex;
  VectorComplexBase get complex => _complex;
  set complex(VectorComplexBase value) {
    if (_complex == value) return;
    _complex.removeListener(markNeedsLayout);
    _complex = value;
    _complex.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  bool _debug;
  bool get debug => _debug;
  set debug(bool value) {
    if (_debug == value) return;
    _debug = value;
    markNeedsPaint();
  }

  List<TransientStroke> _transientStrokes;
  List<TransientStroke> get transientStrokes => _transientStrokes;
  set transientStrokes(List<TransientStroke> value) {
    if (listEquals(_transientStrokes, value)) return;

    for (final s in _transientStrokes) s.removeListener(markNeedsPaint);
    _transientStrokes = value;
    for (final s in _transientStrokes) s.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  bool _resizeToFit;
  bool get resizeToFit => _resizeToFit;
  set resizeToFit(bool value) {
    if (_resizeToFit == value) return;
    _resizeToFit = value;
    markNeedsPaint();
  }

  late Size _viewportSize;
  late Rect _bbox;

  List<CellHitTestEntry>? _debugHitTestResult;

  @override
  void performLayout() {
    _viewportSize = constraints.biggest;

    final geometry = complex.geometry;
    geometry.flush();

    final bbox = geometry.bbox;
    size = constraints.constrainDimensions(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y);
    _bbox = Rect.fromPoints(.new(bbox.min.x, bbox.min.y), .new(bbox.max.x, bbox.max.y));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    if (resizeToFit) {
      context.canvas.translate(-_bbox.left, -_bbox.top);
    }

    final geometry = complex.geometry;
    geometry.flush();

    if (debug) {
      final canvas = context.canvas;
      final localToGlobal = Matrix4.fromFloat64List(canvas.getTransform());

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.transform(Matrix4.inverted(localToGlobal).storage);
      for (final c in complex.cells) {
        debug_renderer.debugPaintCell(
          canvas,
          c,
          localToGlobal,
          _debugHitTestResult?.firstWhereOrNull((e) => e.cell.id == c.id),
        );
      }

      for (final c in geometry.cells) {
        debug_renderer.debugPaintCellGeometry(canvas, c, localToGlobal);
      }

      for (final t in transientStrokes) {
        debug_renderer.debugPaintTransientStroke(canvas, t, localToGlobal);
      }

      canvas.restore();
    }

    context.canvas.restore();
  }

  @override
  bool hitTest(
    BoxHitTestResult result, {
    required Offset position,
    CellHitTestTolerance tolerance = .defaultTolerance,
  }) {
    // Add self if the position is within our bounds
    if (size.contains(position)) {
      final localToGlobal = getTransformTo(null);
      final scale = localToGlobal.getMaxScaleOnAxis();
      final adjustedTolerance = tolerance * scale;

      final cell = hitTestCell(position, tolerance: adjustedTolerance);
      if (cell != null) {
        result.add(cell);
      } else {
        result.add(BoxHitTestEntry(this, position));
      }
    } else {
      return false;
    }

    return true;
  }

  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final hits = hitTestCells(position, tolerance: tolerance);
    if (hits.isEmpty) return null;
    return hits.first;
  }

  List<CellHitTestEntry> hitTestCells(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    if (_kDebugPaintHitTests) {
      final results = hit_test.hitTestRenderComplex(this, position, tolerance);
      if (_debugHitTestResult == null || !listEquals(_debugHitTestResult, results)) {
        _debugHitTestResult = results;
        markNeedsPaint();
      }

      return results;
    }

    return hit_test.hitTestRenderComplex(this, position, tolerance);
  }

  List<CellHitTestEntry> rectHitTestCells(Rect rect) {
    return rect_hit_test.rectHitTestRenderComplex(this, rect);
  }

  @override
  void reassemble() {
    super.reassemble();
    complex.reassemble();
  }
}
