import 'package:vgc/vgc.dart';
import 'package:vgc_renderer/vgc_renderer.dart';

extension VertexAtHitTest on VectorComplex {
  Vertex createVertexAtHitTest(CellHitTestEntry hitTest) {
    if (hitTest is VertexHitTestEntry) {
      return hitTest.vertex;
    } else if (hitTest is EdgeHitTestEntry) {
      final edge = hitTest.edge, t = hitTest.t;
      final result = cutEdge(edge, t);
      return result.vertex;
    } else if (hitTest is FaceHitTestEntry) {
      // TODO: Add vertex into face's cycle as a steiner cycle.
      return createVertex(hitTest.localPosition);
    } else {
      throw ArgumentError('Unsupported hit test entry type: ${hitTest.runtimeType}');
    }
  }
}
