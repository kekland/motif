part of '../core.dart';

enum NodeType {
  root('Root'),
  rectangle('Rectangle'),
  container('Container'),

  vertex('Vertex'),
  edge('Edge'),
  edgeKnot('Knot'),
  edgeKnotControlPoint('Control point'),
  face('Face');

  const NodeType(this.typeName);
  final String typeName;
}
