import 'package:flutter/foundation.dart';
import 'package:wgpu/darwin.dart' as darwin;

import 'package:flutter/rendering.dart';
import 'package:vgc/vgc.dart';
import 'package:vgc_renderer/vgc_renderer.dart';

import 'cubic_renderer.dart';

class RenderVectorComplex extends RenderBox {
  RenderVectorComplex({required this._complex, this._transientStrokes = const []}) {
    _complex.addListener(_onComplexChanged);
    _onComplexChanged();
    _mtlTexture.register();

    for (final s in _transientStrokes) s.addListener(markNeedsPaint);
  }

  final _children = <Cell, RenderCell>{};
  final _renderer3 = CubicRenderer();
  final _mtlTexture = darwin.MTLFlutterTexture.create();

  late VectorComplex _complex;
  VectorComplex get complex => _complex;
  set complex(VectorComplex value) {
    if (_complex == value) return;
    _complex.removeListener(_onComplexChanged);
    _complex = value;
    _complex.addListener(_onComplexChanged);
    _onComplexChanged();
  }

  late List<TransientStroke> _transientStrokes;
  List<TransientStroke> get transientStrokes => _transientStrokes;
  set transientStrokes(List<TransientStroke> value) {
    if (listEquals(_transientStrokes, value)) return;

    for (final s in _transientStrokes) s.removeListener(markNeedsPaint);
    _transientStrokes = value;
    for (final s in _transientStrokes) s.addListener(markNeedsPaint);

    markNeedsPaint();
  }

  void _onComplexChanged() {
    final untouched = {..._children.keys};
    for (final cell in complex.cells) {
      if (!_children.containsKey(cell)) {
        final render = RenderCell.create(cell);
        adoptChild(render);
        _children[cell] = render;
      }

      untouched.remove(cell);
    }

    for (final cell in untouched) {
      final render = _children.remove(cell)!;
      dropChild(render);
      render.dispose();
    }

    for (final child in _children.values) {
      child.markNeedsLayout();
    }

    markNeedsLayout();
  }

  @override
  void dispose() {
    for (final child in _children.values) child.dispose();
    _complex.removeListener(_onComplexChanged);
    _mtlTexture.dispose();
    // _renderer2.dispose();
    _renderer3.dispose();
    super.dispose();
  }

  late Size viewportSize;

  @override
  void performLayout() {
    const childConstraints = BoxConstraints();
    for (final child in _children.values) child.layout(childConstraints);

    viewportSize = constraints.biggest;

    final bbox = complex.bbox;
    size = constraints.constrain(Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y));
  }

  @override
  bool get needsCompositing => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    final localToGlobal = getTransformTo(null);
    final localViewport = context.canvas.getLocalClipBounds();

    final transform = localToGlobal.leftTranslateByDouble(-offset.dx, -offset.dy, 0.0, 1.0);

    final mtlTexture = _renderer3.renderToTexture(
      complex.edges.toList(),
      width: viewportSize.width.ceil() * 3,
      height: viewportSize.height.ceil() * 3,
      tolerance: 1.0,
      transform: Matrix4.diagonal3Values(3.0, 3.0, 1.0) * localToGlobal,
      transientStrokes: transientStrokes,
    );

    _mtlTexture.updateBuffer(mtlTexture);

    context.addLayer(
      TextureLayer(
        rect: offset & (viewportSize),
        textureId: _mtlTexture.textureId!,
        filterQuality: .high,
        freeze: false,
      ),
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Add self if the position is within our bounds
    if (size.contains(position)) {
      result.add(BoxHitTestEntry(this, position));
    } else {
      return false;
    }

    // Add the cell if we hit one.
    final cell = hitTestCell(position);
    if (cell != null) {
      result.add(BoxHitTestEntry(cell.target, position));
    }

    return true;
  }

  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final hits = hitTestCells(position, tolerance: tolerance);
    if (hits.isEmpty) return null;
    return hits.first;
  }

  List<CellHitTestEntry> hitTestCells(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return _hitTestRenderComplex(this, position, tolerance);
  }
}

List<CellHitTestEntry> _hitTestRenderComplex(
  RenderVectorComplex renderComplex,
  Offset position,
  CellHitTestTolerance tolerance,
) {
  final complex = renderComplex.complex;
  final indexed = <(CellHitTestEntry, int)>[];
  var depth = 0;

  for (var c = complex.top; c != null; c = c.prev) {
    final child = renderComplex._children[c];
    if (child == null) continue;

    final result = switch (c) {
      Vertex _ => (child as RenderVertex).hitTestCell(position, tolerance: tolerance),
      Edge _ => (child as RenderEdge).hitTestCell(position, tolerance: tolerance),
      Face _ => null,
    };

    if (result != null) indexed.add((result, depth));
    depth++;
  }

  int _priority(CellHitTestEntry r) => switch (r) {
    VertexHitTestEntry _ => 0,
    EdgeHitTestEntry _ => 1,
    FaceHitTestEntry _ => 2,
  };

  indexed.sort((a, b) {
    final typeComparison = _priority(a.$1).compareTo(_priority(b.$1));
    if (typeComparison != 0) return typeComparison;

    final distanceComparison = a.$1.distance.compareTo(b.$1.distance);
    if (distanceComparison != 0) return distanceComparison;

    return a.$2.compareTo(b.$2);
  });

  return indexed.map((e) => e.$1).toList();
}
