part of '../kernel.dart';

extension FacesAtQuery on TopologyQuery {
  Iterable<FaceHandle> facesAt(Vec2 p) sync* {
    for (final f in bundle.faces) {
      if (bundle._faceWinding(f, p) != 0) yield f;
    }
  }
}
