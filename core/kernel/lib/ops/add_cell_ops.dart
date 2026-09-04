part of '../kernel.dart';

final class AddFrameOp extends Op<FrameHandle> {
  AddFrameOp(
    this.transform, {
    this.size,
    FrameRef? parent,
  }) : placement = .ref(parent?.id);

  final Mat4 transform;
  final Size2? size;
  final CellPlacement placement;

  @override
  FrameHandle _execute(Transaction t, bool produceResult) {
    if (t.mode == .topology) {
      return t._addFrame(transform: transform, size: size, parent: placement.resolveParent(t));
    }

    final handle = t._cell<FrameHandle>();
    t._setFrameTransform(handle, transform);
    t._setFrameSize(handle, size);
    return handle;
  }

  @override
  bool topologyEquals(Op other) => other is AddFrameOp && placement == other.placement;
}

final class AddVertexOp extends Op<VertexHandle> {
  AddVertexOp(
    this.position, {
    FrameRef? parent,
  }) : placement = .ref(parent?.id);

  final Vec2 position;
  final CellPlacement placement;

  @override
  VertexHandle _execute(Transaction t, bool produceResult) {
    if (t.mode == .topology) {
      return t._addVertex(
        position,
        parent: placement.resolveParent(t),
      );
    }

    final handle = t._cell<VertexHandle>();
    t._setVertexPosition(handle, position);
    return handle;
  }

  @override
  bool topologyEquals(Op other) => other is AddVertexOp && placement == other.placement;
}

final class AddEdgeOp extends Op<EdgeHandle> {
  AddEdgeOp(
    this.start,
    this.end, {
    this.startTangent,
    this.endTangent,
    CellRef? parent,
  }) : placement = .ref(parent?.id);

  final VertexRef start, end;
  final Vec2? startTangent, endTangent;
  final CellPlacement placement;

  @override
  EdgeHandle _execute(Transaction t, bool produceResult) {
    if (t.mode == .topology) {
      return t._addEdge(
        t.vertexFor(start.id),
        t.vertexFor(end.id),
        startTangent: startTangent,
        endTangent: endTangent,
        parent: placement.resolveParent(t),
      );
    }

    final handle = t._cell<EdgeHandle>();
    t._setEdgeTangents(handle, start: startTangent, end: endTangent);
    return handle;
  }

  @override
  bool topologyEquals(Op other) =>
      other is AddEdgeOp && placement == other.placement && start == other.start && end == other.end;
}

final class AddFaceOp extends Op<FaceHandle> {
  AddFaceOp(
    this.boundary, {
    CellRef? parent,
  }) : placement = .ref(parent?.id);

  final List<CycleRef> boundary;
  final CellPlacement placement;

  @override
  FaceHandle _execute(Transaction t, bool produceResult) {
    if (t.mode == .topology) {
      return t._addFace(
        boundary.map(t.cycleFor).toList(),
        parent: placement.resolveParent(t),
      );
    }

    final handle = t._cell<FaceHandle>();
    return handle;
  }

  @override
  bool topologyEquals(Op other) => other is AddFaceOp && placement == other.placement && boundary == other.boundary;
}

extension CellOps on Transaction {
  FrameHandle addFrame(
    Mat4 transform, {
    Size2? size,
    FrameHandle? parent,
  }) => _applyWithResult(
    AddFrameOp(
      transform,
      size: size,
      parent: parent?.ref(bundle),
    ),
  );

  VertexHandle addVertex(
    Vec2 position, {
    FrameHandle? parent,
  }) => _applyWithResult(
    AddVertexOp(
      position,
      parent: parent?.ref(bundle),
    ),
  );

  EdgeHandle addEdge(
    VertexHandle start,
    VertexHandle end, {
    Vec2? startTangent,
    Vec2? endTangent,
    FrameHandle? parent,
  }) => _applyWithResult(
    AddEdgeOp(
      start.ref(bundle),
      end.ref(bundle),
      startTangent: startTangent,
      endTangent: endTangent,
      parent: parent?.ref(bundle),
    ),
  );

  FaceHandle addFace(
    List<Cycle> boundary, {
    FrameHandle? parent,
  }) => _applyWithResult(
    AddFaceOp(
      boundary.map((c) => c.asRef(bundle)).toList(),
      parent: parent?.ref(bundle),
    ),
  );
}
