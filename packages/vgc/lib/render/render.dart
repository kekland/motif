import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:vgc/vgc.dart';

part 'hit_test.dart';

class RenderVectorComplex extends RenderBox {
  RenderVectorComplex({required VectorComplex complex}) : _complex = complex {
    _complex.addListener(_onComplexChanged);
    _onComplexChanged();
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
      if (!_children.containsKey(cell)) _children[cell] = RenderCell.create(cell);
      untouched.remove(cell);
    }

    for (final cell in untouched) {
      _children.remove(cell)!.dispose();
    }

    for (final child in _children.values) child.markNeedsLayout();
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

    final bbox = complex.boundingBoxApproximate;
    size = constraints.constrain(Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer = context.pushTransform(
      false,
      offset,
      Matrix4.identity(),
      (context, offset) {
        for (final cell in complex.cells) {
          final child = _children[cell]!;
          context.paintChild(child, offset);
        }
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
}

final class RenderVertex extends RenderCell<Vertex> {
  RenderVertex({required Vertex vertex}) : super(cell: vertex);
  Vertex get vertex => cell;

  @override
  void performLayout() {
    size = Size.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // final point = Offset(offset.dx + vertex.position.x, offset.dy + vertex.position.y);
    // final paint = Paint()
    //   ..style = .fill
    //   ..color = const Color(0xFFFF0000);

    // context.canvas.drawCircle(point, 4.0, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final result = _hitTestVertexRaw(vertex, Vector2(position.dx, position.dy), tolerance.vertex);
    return result != null ? VertexHitTestEntry(this, distance: result) : null;
  }
}

final class RenderEdge extends RenderCell<Edge> {
  RenderEdge({required Edge edge}) : super(cell: edge);
  Edge get edge => cell;

  @override
  void performLayout() {
    final bbox = edge.boundingBoxApproximate;
    size = Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final path = edge.getPath().shift(offset);
    final paint = Paint()
      ..style = .stroke
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 2.0;

    context.canvas.drawPath(path, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    final result = _hitTestEdgeRaw(edge, Vector2(position.dx, position.dy), tolerance.edge);
    return result != null ? EdgeHitTestEntry(this, distance: result.$1, t: result.$2) : null;
  }
}

final _faceColors = Colors.primaries;
Color getFaceColor(Face face) {
  final index = face.hashCode.abs() % _faceColors.length;
  return _faceColors[index].withValues(alpha: 0.25);
}

final class RenderFace extends RenderCell<Face> {
  RenderFace({required Face face}) : super(cell: face);
  Face get face => cell;

  @override
  void performLayout() {
    final bbox = face.boundingBoxApproximate;
    size = constraints.constrain(Size(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final path = face.getPath().shift(offset);
    final paint = Paint()
      ..style = .fill
      ..color = getFaceColor(face);

    context.canvas.drawPath(path, paint);
  }

  @override
  CellHitTestEntry? hitTestCell(Offset position, {CellHitTestTolerance tolerance = .defaultTolerance}) {
    return null;
  }
}
