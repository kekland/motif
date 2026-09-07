import 'package:editor/imports.dart';

extension StatementUtils on Statement {
  String name(BuildContext context) => switch (this) {
    VertexStatement() => 'Vertex',
    EdgeStatement() => 'Edge',
    FaceStatement() => 'Face',
    ContainerStatement() => 'Container',
    RectangleStatement() => 'Rectangle',
    EllipseStatement() => 'Ellipse',
    PolygonStatement() => 'Polygon',
    FrameStatement() => 'Frame',
    CutEdgeStatement() => 'Cut edge',
    // GlueVerticesStatement() => 'Glue vertices',
    FilletFaceStatement() => 'Fillet face',
    DissolveStatement() => 'Dissolve',
    PlacedStatement() => unreachable(),
  };

  Widget icon(BuildContext context) => switch (this) {
    VertexStatement() => Icons.vertex(),
    EdgeStatement() => Icons.edge(),
    FaceStatement() => Icons.face(),
    ContainerStatement() => Icons.container(),
    RectangleStatement() => Icons.square(),
    EllipseStatement() => Icons.circle(),
    PolygonStatement() => Icons.polygon(),
    FrameStatement _ => Icons.frame(),
    // CutEdgeStatement() => Icons.cut_edge(),
    // GlueVerticesStatement() => Icons.glue_vertices(),
    // _ => Icons.statement(),
    PlacedStatement() => unreachable(),
    _ => Icons.s(),
  };
}
