import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:geometry/geometry.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:vgc/vgc.dart';
import 'package:vgc_renderer/vgc_renderer.dart';

part 'cell/render_vertex.dart';
part 'cell/render_edge.dart';
part 'cell/render_face.dart';

sealed class RenderCell<T extends Cell> extends RenderBox {
  RenderCell({required this._cell});
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
