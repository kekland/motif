part of '../kernel.dart';

extension FacesAtQuery on TopologyQuery {
  Iterable<FaceRef> facesAt(Vec2 p) sync* {
    for (final f in bundle.faces) {
      if (bundle.faceWinding(f, p) != 0) yield f.ref(bundle);
    }
  }
}
