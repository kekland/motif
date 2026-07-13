part of '../core.dart';

abstract class Modifier<C extends Cell> {
  Modifier({this.isEnabled = true});

  final bool isEnabled;

  (C, List<Cell>) apply(VectorComplexContext context, C cell);
}

typedef VertexModifier = Modifier<Vertex>;
typedef EdgeModifier = Modifier<Edge>;
