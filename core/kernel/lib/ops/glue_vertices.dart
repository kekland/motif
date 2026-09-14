part of '../kernel.dart';

enum GlueVerticesPosition {
  first,
  centroid,
}

final class GlueVerticesOp extends Op<VertexRef> {
  new(this.vertices, {this.position = .centroid});

  final List<VertexRef> vertices;
  final GlueVerticesPosition position;

  @override
  VertexRef? _execute(Transaction t, bool produceResult) {
    final bundle = t.bundle;

    final handles = vertices.map((v) => bundle.vertex(v)!).toList();
    final space = bundle.lcaMany(handles);

    Vec2 position = .zero();
    if (this.position == .first) {
      position = bundle.vertexPosition(handles.first, space: space);
    } else {
      for (final handle in handles) position += bundle.vertexPosition(handle, space: space);
      position /= handles.length;
    }

    final newVertex = t._addVertex(position, parent: space);

    // Repoint existing edges
    for (final handle in handles) {
      for (final cv in bundle.vertexUses(handle).toList()) {
        t._repointEdgeEndpoint(cv.edge, isStart: cv.isStart, to: newVertex);
      }
    }

    for (final h in handles) t._deleteVertex(h);

    return produceResult ? newVertex.ref(bundle) : null;
  }

  @override
  bool topologyEquals(Op<dynamic> other) {
    if (other is! GlueVerticesOp) return false;
    if (position != other.position) return false;
    if (!const ListEquality().equals(vertices, other.vertices)) return false;
    return true;
  }
}
