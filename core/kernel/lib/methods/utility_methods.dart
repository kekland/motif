part of '../kernel.dart';

extension UtilityMethods on Bundle {
  // -------------------------------------------------------------------------------------------------------------------
  // Assertions
  // -------------------------------------------------------------------------------------------------------------------

  bool isFrameLive(FrameHandle h) => _frame.isHandleLive(h.index, h.gen);
  bool isVertexLive(VertexHandle h) => _vertex.isHandleLive(h.index, h.gen);
  bool isEdgeLive(EdgeHandle h) => _edge.isHandleLive(h.index, h.gen);
  bool isFaceLive(FaceHandle h) => _face.isHandleLive(h.index, h.gen);
  bool isCellLive(CellHandle h) => switch (h.kind) {
    .frame => isFrameLive(h.asFrame),
    .vertex => isVertexLive(h.asVertex),
    .edge => isEdgeLive(h.asEdge),
    .face => isFaceLive(h.asFace),
  };

  bool isFrameGhost(FrameHandle h) => _frame.isHandleGhost(h.index, h.gen);
  bool isVertexGhost(VertexHandle h) => _vertex.isHandleGhost(h.index, h.gen);
  bool isEdgeGhost(EdgeHandle h) => _edge.isHandleGhost(h.index, h.gen);
  bool isFaceGhost(FaceHandle h) => _face.isHandleGhost(h.index, h.gen);
  bool isCellGhost(CellHandle h) => switch (h.kind) {
    .frame => isFrameGhost(h.asFrame),
    .vertex => isVertexGhost(h.asVertex),
    .edge => isEdgeGhost(h.asEdge),
    .face => isFaceGhost(h.asFace),
  };

  bool isFrameReachable(FrameHandle h) => _frame.isHandleReachable(h.index, h.gen);
  bool isVertexReachable(VertexHandle h) => _vertex.isHandleReachable(h.index, h.gen);
  bool isEdgeReachable(EdgeHandle h) => _edge.isHandleReachable(h.index, h.gen);
  bool isFaceReachable(FaceHandle h) => _face.isHandleReachable(h.index, h.gen);
  bool isCellReachable(CellHandle h) => switch (h.kind) {
    .frame => isFrameReachable(h.asFrame),
    .vertex => isVertexReachable(h.asVertex),
    .edge => isEdgeReachable(h.asEdge),
    .face => isFaceReachable(h.asFace),
  };

  bool _checkFrame(FrameHandle h) {
    assert(_frame.isHandleReachable(h.index, h.gen), 'stale frame handle: $h');
    return true;
  }

  bool _liveFrame(FrameHandle h) {
    assert(isFrameLive(h), 'frame is not live: $h');
    return true;
  }

  bool _ghostFrame(FrameHandle h) {
    assert(isFrameGhost(h), 'frame is not ghost: $h');
    return true;
  }

  bool _checkVertex(VertexHandle h) {
    assert(_vertex.isHandleReachable(h.index, h.gen), 'stale vertex handle: $h');
    return true;
  }

  bool _liveVertex(VertexHandle h) {
    assert(isVertexLive(h), 'vertex is not live: $h');
    return true;
  }

  bool _ghostVertex(VertexHandle h) {
    assert(isVertexGhost(h), 'vertex is not ghost: $h');
    return true;
  }

  bool _checkEdge(EdgeHandle h) {
    assert(_edge.isHandleReachable(h.index, h.gen), 'stale edge handle: $h');
    return true;
  }

  bool _liveEdge(EdgeHandle h) {
    assert(isEdgeLive(h), 'edge is not live: $h');
    return true;
  }

  bool _ghostEdge(EdgeHandle h) {
    assert(isEdgeGhost(h), 'edge is not ghost: $h');
    return true;
  }

  bool _checkFace(FaceHandle h) {
    assert(_face.isHandleReachable(h.index, h.gen), 'stale face handle: $h');
    return true;
  }

  bool _liveFace(FaceHandle h) {
    assert(isFaceLive(h), 'face is not live: $h');
    return true;
  }

  bool _ghostFace(FaceHandle h) {
    assert(isFaceGhost(h), 'face is not ghost: $h');
    return true;
  }

  bool _checkCell(CellHandle h) => switch (h.kind) {
    .frame => _checkFrame(h.asFrame),
    .vertex => _checkVertex(h.asVertex),
    .edge => _checkEdge(h.asEdge),
    .face => _checkFace(h.asFace),
  };
}
