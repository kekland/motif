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
    CutEdgeStatement() => 'Cut edge',
    MultiCutEdgeStatement() => 'Multi-cut edge',
    GlueVerticesStatement() => 'Glue vertices',
    FilletFaceStatement() => 'Fillet face',
    GeneratorStatement() => 'Generator',
    GroupStatement() => 'Group',
    TextStatement() => 'Text',
    GeneratingStatement() => unreachable(),
    PlacedStatement() => unreachable(),
    FacedStatement() => unreachable(),
    FramedStatement() => unreachable(),
  };

  Widget icon(BuildContext context) => switch (this) {
    VertexStatement() => Icons.vertex(),
    EdgeStatement() => Icons.edge(),
    FaceStatement() => Icons.face(),
    ContainerStatement() => Icons.container(),
    RectangleStatement() => Icons.square(),
    EllipseStatement() => Icons.circle(),
    PolygonStatement() => Icons.polygon(),
    FilletFaceStatement() => Icons.fillet(),
    GroupStatement() => Icons.group(),
    // GlueVerticesStatement() => Icons.glue_vertices(),
    // CutEdgeStatement() => Icons.cut_edge(),
    // _ => Icons.statement(),
    TextStatement() => Icons.text(),
    GeneratorStatement() => Icons.generator(),
    PlacedStatement() => unreachable(),
    FacedStatement() => unreachable(),
    _ => Icons.s(),
  };
}

extension ModifierUtils on Modifier {
  String name(BuildContext context) => kind.name(context);
  Widget icon(BuildContext context) => kind.icon(context);
}

extension ModifierKindUtils on ModifierKind {
  String name(BuildContext context) => switch (this) {
    .fillet => 'Fillet',
  };

  Widget icon(BuildContext context) => switch (this) {
    .fillet => Icons.fillet(),
  };
}
