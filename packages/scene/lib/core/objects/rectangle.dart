part of '../core.dart';

final class RectangleObject extends SceneObject with TopologicalSceneObject {
  RectangleObject({super.id, super.transform, super.size});

  Vertex get topLeft => _ownedCells[0] as Vertex;
  Vertex get topRight => _ownedCells[1] as Vertex;
  Vertex get bottomRight => _ownedCells[2] as Vertex;
  Vertex get bottomLeft => _ownedCells[3] as Vertex;
  Edge get left => _ownedCells[4] as Edge;
  Edge get top => _ownedCells[5] as Edge;
  Edge get right => _ownedCells[6] as Edge;
  Edge get bottom => _ownedCells[7] as Edge;

  @override
  List<Cell> produceCells(ResolvedSize size) {
    final width = size.width;
    final height = size.height;

    final topLeft = Vertex(.zero());
    final topRight = Vertex(Vector2(width, 0.0));
    final bottomRight = Vertex(Vector2(width, height));
    final bottomLeft = Vertex(Vector2(0.0, height));

    final left = Edge(topLeft, bottomLeft);
    final top = Edge(topLeft, topRight);
    final right = Edge(topRight, bottomRight);
    final bottom = Edge(bottomLeft, bottomRight);

    return [topLeft, topRight, bottomRight, bottomLeft, left, top, right, bottom];
  }

  @override
  NodeType get type => .rectangle;
}
