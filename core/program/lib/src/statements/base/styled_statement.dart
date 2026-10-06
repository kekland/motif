part of '../../_program.dart';

mixin VertexStyledStatement on Statement {
  VertexStyle get vertexStyle;

  Statement copyWithVertexStyle({VertexStyle? style});
}

mixin EdgeStyledStatement on Statement {
  EdgeStyle get edgeStyle;

  Statement copyWithEdgeStyle({EdgeStyle? style});
}

mixin FaceStyledStatement on Statement {
  FaceStyle get faceStyle;

  Statement copyWithFaceStyle({FaceStyle? style});
}
