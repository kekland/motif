import 'package:scene/scene.dart';
import 'package:ui/ui.dart';

extension StatementUtils on Statement {
  String name(BuildContext context) => switch (this) {
    VertexStatement _ => 'Vertex',
    EdgeStatement _ => 'Edge',
    FaceStatement _ => 'Face',
    ContainerStatement _ => 'Container',
    RectangleStatement _ => 'Rectangle',
    CircleStatement _ => 'Circle',
    TriangleStatement _ => 'Triangle',
    FrameStatement _ => 'Frame',
    CutEdgeStatement() => 'Cut edge',
    GlueVerticesStatement() => 'Glue vertices',
    _ => runtimeType.toString(),
  };

  Widget icon(BuildContext context) => switch (this) {
    VertexStatement _ => Icons.vertex(),
    EdgeStatement _ => Icons.edge(),
    FaceStatement _ => Icons.face(),
    ContainerStatement _ => Icons.container(),
    RectangleStatement _ => Icons.square(),
    CircleStatement _ => Icons.circle(),
    TriangleStatement _ => Icons.polygon(),
    FrameStatement _ => Icons.frame(),
    // CutEdgeStatement() => Icons.cut_edge(),
    // GlueVerticesStatement() => Icons.glue_vertices(),
    // _ => Icons.statement(),
    _ => Icons.s(),
  };
}
