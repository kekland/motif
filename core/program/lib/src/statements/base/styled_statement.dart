part of '../../_program.dart';

mixin VertexStyledStatement on Statement {
  VertexStyle get vertexStyle;
}

mixin EdgeStyledStatement on Statement {
  EdgeStyle get edgeStyle;
}

mixin FaceStyledStatement on Statement {
  FaceStyle get faceStyle;
}
