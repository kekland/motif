part of '../kernel.dart';

sealed class CellGeometry<H extends CellHandle> {
  static CellGeometry<H> of<H extends CellHandle>(Bundle b, H handle) => switch (handle.kind) {
    .frame => CellGeometry.frame(b, handle.asFrame),
    .vertex => CellGeometry.vertex(b, handle.asVertex),
    .edge => CellGeometry.edge(b, handle.asEdge),
    .face => CellGeometry.face(b, handle.asFace),
  } as CellGeometry<H>;

  static FrameGeometry frame(Bundle b, FrameHandle h) => .new(
    b.frameTransform(h),
    b.frameSize(h),
    b.frameClip(h)?.id(b),
  );

  static VertexGeometry vertex(Bundle b, VertexHandle h) => .new(
    b.vertexPosition(h),
  );

  static EdgeGeometry edge(Bundle b, EdgeHandle h) => .new(
    b.edgeStartTangent(h),
    b.edgeEndTangent(h),
  );

  static FaceGeometry face(Bundle b, FaceHandle h) => .new();

  void set(Bundle b, H handle);
}

final class FrameGeometry(
  final Mat4 transform,
  final Size2? size,
  final CellId? clip,
) extends CellGeometry<FrameHandle> {
  @override
  void set(Bundle b, FrameHandle handle) {
    b._frameSetTransform(handle, transform);
    b._frameSetSize(handle, size);
    b._frameSetClip(handle, clip != null ? b.face(clip!) : null);
  }
}

final class VertexGeometry(
  final Vec2 position,
) extends CellGeometry<VertexHandle> {
  @override
  void set(Bundle b, VertexHandle handle) {
    b._vertexSetPosition(handle, position);
  }
}

final class EdgeGeometry(
  final Vec2 startTangent,
  final Vec2 endTangent,
) extends CellGeometry<EdgeHandle> {
  @override
  void set(Bundle b, EdgeHandle handle) {
    b._edgeSetTangents(handle, start: startTangent, end: endTangent);
  }
}

final class FaceGeometry() extends CellGeometry<FaceHandle> {
  @override
  void set(Bundle b, FaceHandle handle) {}
}
