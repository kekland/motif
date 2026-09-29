part of '../kernel.dart';

sealed class CellGeometry<H extends CellHandle> {
  CellGeometry({required this.anchor});

  static CellGeometry<H> of<H extends CellHandle>(Bundle b, H handle) => switch (handle.kind) {
    .frame => CellGeometry.frame(b, handle.asFrame),
    .vertex => CellGeometry.vertex(b, handle.asVertex),
    .edge => CellGeometry.edge(b, handle.asEdge),
    .face => CellGeometry.face(b, handle.asFace),
  } as CellGeometry<H>;

  static FrameGeometry frame(Bundle b, FrameHandle h) => .new(
    b.frameTransform(h),
    b.frameSize(h),
    b.frameClip(h)?.ref(b),
    anchor: b.zAnchorOf(h),
  );

  static VertexGeometry vertex(Bundle b, VertexHandle h) => .new(
    b.vertexPosition(h),
    anchor: b.zAnchorOf(h),
  );

  static EdgeGeometry edge(Bundle b, EdgeHandle h) => .new(
    b.edgeStartTangent(h),
    b.edgeEndTangent(h),
    anchor: b.zAnchorOf(h),
  );

  static FaceGeometry face(Bundle b, FaceHandle h) => .new(
    anchor: b.zAnchorOf(h),
  );

  final ZAnchor? anchor;

  void set(Bundle b, H handle);
}

final class FrameGeometry(
  final Mat4 transform,
  final Size2? size,
  final FaceRef? clip, {
  super.anchor,
}) extends CellGeometry<FrameHandle> {
  @override
  void set(Bundle b, FrameHandle handle) {
    b._frameSetTransform(handle, transform);
    b._frameSetSize(handle, size);
    b._frameSetClip(handle, clip != null ? b.face(clip!) : null);
    b._treeReorder(handle, anchor);
  }
}

final class VertexGeometry(
  final Vec2 position, {
  super.anchor,
}) extends CellGeometry<VertexHandle> {
  @override
  void set(Bundle b, VertexHandle handle) {
    b._vertexSetPosition(handle, position);
    b._treeReorder(handle, anchor);
  }
}

final class EdgeGeometry(
  final Vec2 startTangent,
  final Vec2 endTangent, {
  super.anchor,
}) extends CellGeometry<EdgeHandle> {
  @override
  void set(Bundle b, EdgeHandle handle) {
    b._edgeSetTangents(handle, start: startTangent, end: endTangent);
    b._treeReorder(handle, anchor);
  }
}

final class FaceGeometry({
  super.anchor,
}) extends CellGeometry<FaceHandle> {
  @override
  void set(Bundle b, FaceHandle handle) {
    b._treeReorder(handle, anchor);
  }
}
