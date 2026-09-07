part of '../kernel.dart';

extension TransformQueries on TopologyQuery {
  Mat4 localToWorld(CellHandle handle) {
    if (handle.kind == .frame) return bundle.frameTransform(handle.asFrame, space: .root);
    final parent = bundle.parentOf(handle)!;
    return bundle.frameTransform(parent.asFrame, space: .root);
  }
}
