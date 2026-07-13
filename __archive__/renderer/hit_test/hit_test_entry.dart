part of 'hit_test.dart';

class SceneNodeHitTestResult extends BoxHitTestResult {
  SceneNodeHitTestResult() : super();
  SceneNodeHitTestResult.wrap(super.result) : super.wrap();

  @override
  Iterable<SceneNodeHitTestEntry> get path => super.path.cast();

  Iterable<SceneObjectHitTestEntry> get objects => path;
  Iterable<CellHitTestEntry> get cells => path.whereType<CellHitTestEntry>();

  SceneObjectHitTestEntry? get object => objects.isNotEmpty ? objects.first : null;
  CellHitTestEntry? get cell => cells.isNotEmpty ? cells.first : null;
}

class SceneNodeHitTestEntry<T extends SceneNode> extends BoxHitTestEntry {
  SceneNodeHitTestEntry(RenderSceneNode super.target, super.localPosition) : node = target.node as T;

  final T node;

  @override
  String toString() => '${super.toString()}{$node}';
}

class SceneObjectHitTestEntry<T extends SceneObject> extends SceneNodeHitTestEntry<T> {
  SceneObjectHitTestEntry(RenderSceneObject super.target, super.localPosition) : super();
}

sealed class CellHitTestEntry<T extends Cell> extends SceneObjectHitTestEntry<T> {
  CellHitTestEntry(
    RenderCell super.target,
    super.localPosition, {
    required this.distance,
  });

  final double distance;
}

final class VertexHitTestEntry extends CellHitTestEntry<Vertex> {
  VertexHitTestEntry(
    RenderVertex super.target,
    super.localPosition, {
    required super.distance,
  });
}

final class EdgeHitTestEntry extends CellHitTestEntry<Edge> {
  EdgeHitTestEntry(
    RenderEdge super.target,
    super.localPosition, {
    required this.t,
    required super.distance,
  });

  final double t;
}
