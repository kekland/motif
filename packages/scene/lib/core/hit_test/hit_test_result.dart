part of '../core.dart';

final class SceneHitTestResult {
  SceneHitTestResult();

  final _entries = <SceneHitTestEntry>[];

  void add(SceneHitTestEntry entry) {
    _entries.add(entry);
  }

  Iterable<SceneHitTestEntry> get nodes => _entries;
  SceneHitTestEntry? get node => _entries.isNotEmpty ? _entries.first : null;

  Iterable<SceneObjectHitTestEntry> get objects => nodes.whereType<SceneObjectHitTestEntry>();
  SceneObjectHitTestEntry? get object => objects.isNotEmpty ? objects.first : null;

  Iterable<CellHitTestEntry> get cells => nodes.whereType<CellHitTestEntry>();
  CellHitTestEntry? get cell => cells.isNotEmpty ? cells.first : null;
}

abstract class SceneHitTestEntry<T extends SceneNode> {
  SceneHitTestEntry(
    this.node,
    this.localPosition, {
    this._distance = 0.0,
  });

  final T node;
  final Vector2 localPosition;
  final double _distance;
}

class SceneObjectHitTestEntry extends SceneHitTestEntry<SceneObject> {
  SceneObjectHitTestEntry(super.node, super.localPosition) : super(distance: 0.0);
}

sealed class CellHitTestEntry<C extends Cell> extends SceneHitTestEntry<C> {
  CellHitTestEntry(super.node, super.localPosition, {super.distance = 0.0});

  double get distance => _distance;
}

final class VertexHitTestEntry extends CellHitTestEntry<Vertex> {
  VertexHitTestEntry(super.node, super.localPosition, {required super.distance});
}

final class EdgeHitTestEntry extends CellHitTestEntry<Edge> {
  EdgeHitTestEntry(super.node, super.localPosition, {required this.t, required super.distance});

  final double t;
}

final class EdgeKnotHitTestEntry extends SceneHitTestEntry<EdgeKnot> {
  EdgeKnotHitTestEntry(
    super.node,
    super.localPosition, {
    required this.edge,
    required this.index,
    required super.distance,
  });

  final Edge edge;
  final int index;

  double get distance => _distance;
}

final class EdgeKnotControlPointHitTestEntry extends SceneHitTestEntry<EdgeKnotControlPoint> {
  EdgeKnotControlPointHitTestEntry(
    super.node,
    super.localPosition, {
    required this.edge,
    required this.index,
    required this.knot,
    required super.distance,
  });

  final Edge edge;
  final int index;
  final EdgeKnot knot;

  double get distance => _distance;
}
