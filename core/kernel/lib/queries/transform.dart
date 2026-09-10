part of '../kernel.dart';

extension TransformQueries on TopologyQuery {
  FrameRef localFrame(Ref ref) {
    final handle = switch (ref) {
      CellRef() => bundle.handle(ref)!,
      CovertexRef() => bundle.handle(ref.resolveVertex(bundle))!,
    };

    if (handle.kind == .frame) return handle.ref(bundle).asFrame;
    return bundle.parentOf(handle)!.ref(bundle);
  }

  Mat4 localToWorld(Ref ref) {
    final handle = switch (ref) {
      CellRef() => bundle.handle(ref)!,
      CovertexRef() => bundle.handle(ref.resolveVertex(bundle))!,
    };

    if (handle.kind == .frame) return bundle.frameTransform(handle.asFrame, space: .root);
    final parent = bundle.parentOf(handle)!;
    return bundle.frameTransform(parent.asFrame, space: .root);
  }
}
