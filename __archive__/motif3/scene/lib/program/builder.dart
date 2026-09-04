part of 'program.dart';

final class ProgramBuilder {
  ProgramBuilder();

  final List<Statement> _statements = [];

  FrameRef frame(Mat4 transform, {FrameRef? parent}) {
    final stmt = FrameStatement(transform: transform, parent: parent);
    _statements.add(stmt);
    return stmt.frame;
  }

  VertexRef vertex(Vec2 position, {FrameRef? parent}) {
    final stmt = VertexStatement(position, parent: parent);
    _statements.add(stmt);
    return stmt.vertex;
  }

  EdgeRef edge(VertexRef start, VertexRef end, {FrameRef? parent}) {
    final stmt = EdgeStatement(start, end, parent: parent);
    _statements.add(stmt);
    return stmt.edge;
  }

  FaceRef face(List<EdgeRef> outer, {List<List<EdgeRef>> holes = const [], FrameRef? parent}) {
    final stmt = FaceStatement(outer, holes: holes, parent: parent);
    _statements.add(stmt);
    return stmt.face;
  }

  (VertexRef, EdgeRef, EdgeRef) cutEdge(EdgeRef target, double t) {
    final stmt = CutEdgeStatement(target, t: t);
    _statements.add(stmt);
    return (stmt.vertex, stmt.edge0, stmt.edge1);
  }

  VertexRef glueVertices(List<VertexRef> targets, {GlueVerticesPosition position = .centroid}) {
    final stmt = GlueVerticesStatement(targets, position: position);
    _statements.add(stmt);
    return stmt.vertex;
  }

  RectangleStatement rectangle({
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    FrameRef? parent,
  }) {
    final stmt = RectangleStatement(transform: transform, size: size, shape: shape, parent: parent);
    _statements.add(stmt);
    return stmt;
  }

  ContainerStatement container({
    Mat4? transform,
    LayoutSize? size,
    ChildLayout childLayout = .default_,
    RectangleObjectShape? shape,
    FrameRef? parent,
  }) {
    final stmt = ContainerStatement(
      transform: transform,
      size: size,
      childLayout: childLayout,
      shape: shape,
      parent: parent,
    );
    _statements.add(stmt);
    return stmt;
  }

  Program build() => Program(_statements);
}
