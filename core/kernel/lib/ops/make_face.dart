part of '../kernel.dart';

final class MakeFaceOp extends Op<FaceHandle> {
  MakeFaceOp(
    this.outer, {
    this.holes = const [],
    FrameRef? parent,
  }) : placement = .ref(parent?.id);

  final List<EdgeRef> outer;
  final List<List<EdgeRef>> holes;
  final CellPlacement placement;

  @override
  FaceHandle? _execute(Transaction t, bool produceResult) {
    if (t._mode != .topology) {
      return t._addFace([], parent: placement.resolveParent(t));
    }

    final bundle = t.bundle;

    Cycle makeCycle(List<EdgeRef> edges, String name, bool isPositive) {
      final handles = [for (final e in edges) t.edgeFor(e.id)];
      final chain = bundle._chainEdges(handles);
      if (!chain.isClosed) throw ArgumentError.value(edges, name, 'must form a closed chain');

      var cycle = chain.cycle;
      final isCyclePositive = bundle._cycleSignedArea(cycle) >= 0;
      if (isCyclePositive != isPositive) cycle = cycle.reversed;
      return cycle;
    }

    final boundary = [
      makeCycle(outer, 'outer', true),
      for (var i = 0; i < holes.length; i++) makeCycle(holes[i], 'holes[$i]', false),
    ];

    return t._addFace(
      boundary,
      parent: placement.resolveParent(t),
    );
  }

  @override
  bool topologyEquals(Op other) {
    if (other is! MakeFaceOp) return false;
    if (outer.length != other.outer.length) return false;
    for (var k = 0; k < outer.length; k++) {
      if (outer[k].id != other.outer[k].id) return false;
    }

    if (holes.length != other.holes.length) return false;
    for (var k = 0; k < holes.length; k++) {
      final a = holes[k], b = other.holes[k];
      if (a.length != b.length) return false;
      for (var j = 0; j < a.length; j++) {
        if (a[j].id != b[j].id) return false;
      }
    }

    return true;
  }
}
