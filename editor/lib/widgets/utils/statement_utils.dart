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
    MultiCutEdgeStatement() => 'Multi-cut edge',
    GlueVerticesStatement() => 'Glue vertices',
    FilletFaceStatement() => 'Fillet face',
    DissolveStatement() => 'Dissolve',
    GeneratorStatement() => 'Generator',
    GeneratingStatement() => unreachable(),
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
    FilletFaceStatement() => Icons.fillet(),
    // GlueVerticesStatement() => Icons.glue_vertices(),
    // CutEdgeStatement() => Icons.cut_edge(),
    // _ => Icons.statement(),
    GeneratorStatement() => Icons.generator(),
    PlacedStatement() => unreachable(),
    _ => Icons.s(),
  };
}

extension ModifierUtils on Modifier {
  String name(BuildContext context) => switch (this) {
    .generator => 'Generator',
    .filletFace => 'Fillet',
  };

  Widget icon(BuildContext context) => switch (this) {
    .generator => Icons.generator(),
    .filletFace => Icons.fillet(),
  };
}
