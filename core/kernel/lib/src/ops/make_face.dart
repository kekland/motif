part of '../kernel.dart';

extension MakeFaceTransaction on TopologyTransaction {
  FaceHandle makeFace(
    CellId id,
    List<EdgeHandle> outer, {
    List<List<EdgeHandle>> holes = const [],
    FrameHandle? parent,
    SiblingHandleAnchor anchor = const .append(),
  }) {
    _checkOpen();

    Cycle makeCycle(List<EdgeHandle> edges, String name, bool isPositive) {
      final chain = bundle._chainEdges(edges);
      if (!chain.isClosed) throw ArgumentError.value(edges, name, 'must form a closed chain');

      var cycle = chain.cycle;
      final isCyclePositive = bundle.cycleSignedArea(cycle) >= 0;
      if (isCyclePositive != isPositive) cycle = cycle.reversed;
      return cycle;
    }

    final boundary = [
      makeCycle(outer, 'outer', true),
      for (var i = 0; i < holes.length; i++) makeCycle(holes[i], 'holes[$i]', false),
    ];

    return addFace(id, boundary, parent: parent, anchor: anchor);
  }
}
