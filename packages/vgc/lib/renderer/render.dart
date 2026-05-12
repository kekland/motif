import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:vgc/vgc.dart';

import 'async_program.dart';
import 'tile/tile_grid.dart';

part 'hit_test.dart';
part 'render_vertex.dart';
part 'render_edge.dart';
part 'render_face.dart';

AsyncFragmentProgram _tileQuad2Program = AsyncFragmentProgram('packages/vgc/shaders/tile_quad2.frag');

class RenderVectorComplex extends RenderBox {
  RenderVectorComplex({required VectorComplex complex}) : _complex = complex {
    _complex.addListener(_onComplexChanged);
    _onComplexChanged();

    if (!_tileQuad2Program.isLoaded) _tileQuad2Program.load().then((_) => markNeedsPaint());
  }

  final _children = <Cell, RenderCell>{};

  late VectorComplex _complex;
  VectorComplex get complex => _complex;
  set complex(VectorComplex value) {
    if (_complex == value) return;
    _complex.removeListener(_onComplexChanged);
    _complex = value;
    _complex.addListener(_onComplexChanged);
    _onComplexChanged();
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
    super.dispose();
  }

  @override
  void performLayout() {
    const childConstraints = BoxConstraints();
    for (final child in _children.values) child.layout(childConstraints);

    final bbox = complex.bbox;
    size = constraints.constrain(Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final localToGlobal = getTransformTo(null);
    final tolerance = 1.0 / localToGlobal.getMaxScaleOnAxis();
    final scale = localToGlobal.getMaxScaleOnAxis();

    // Set the tile size based on the current scale to maintain a consistent screen-space size.
    final tileSize = 128.0 / math.pow(2, (math.log(scale) / math.ln2).floorToDouble());

    layer = context.pushTransform(
      false,
      offset,
      Matrix4.identity(),
      (context, offset) {
        final localViewport = context.canvas.getLocalClipBounds().translate(-offset.dx, -offset.dy);

        context.canvas.save();
        context.canvas.translate(offset.dx, offset.dy);

        // Tile-based workflow
        final grid = TileGrid(tileSize: tileSize);
        for (final cell in complex.cells) {
          final child = _children[cell]!;
          child.submitGeometry(grid, tolerance);
        }

        if (!_tileQuad2Program.isLoaded) return;
        grid.paint(context.canvas, localViewport, localToGlobal, _tileQuad2Program.program, 4.0);
        context.canvas.restore();
      },
      oldLayer: layer as TransformLayer?,
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

sealed class RenderCell<T extends Cell> extends RenderBox {
  RenderCell({required T cell}) : _cell = cell;
  static RenderCell create(Cell cell) {
    return switch (cell) {
      Vertex v => RenderVertex(vertex: v),
      Edge e => RenderEdge(edge: e),
      Face f => RenderFace(face: f),
    };
  }

  late T _cell;
  T get cell => _cell;
  set cell(T value) {
    if (_cell == value) return;
    _cell = value;
    markNeedsLayout();
  }

  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance});

  void submitGeometry(TileGrid grid, double tolerance) {}
}
