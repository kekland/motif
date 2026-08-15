part of 'core.dart';

extension type const TopologyId(int id) implements Object {
  TopologyId.from(Object id) : this(id.hashCode);
  TopologyId.from3(Object a, Object b, Object c) : this(Object.hash(a, b, c));
}

class Topology {
  Topology([List<Cell>? cells]) {
    if (cells != null) {
      addAll(cells);
    }
  }

  Topology.empty() : this();

  final _cells = <Cell>[];
  final _cellIds = <NodeId, Cell>{};
  final _cellTopologyIds = <TopologyId, Cell>{};

  List<Cell> get cells => _cells;
  Iterable<Vertex> get vertices => _cells.whereType<Vertex>();
  Iterable<Edge> get edges => _cells.whereType<Edge>();
  Iterable<Face> get faces => _cells.whereType<Face>();

  void add(Cell c, {Cell? after}) {
    final index = after != null ? _cells.indexOf(after) + 1 : _cells.length;
    _cells.insert(index, c);
    _cellIds[c.id] = c;
    _cellTopologyIds[c.topologyId] = c;
    c._attachToTopology(this);
  }

  void addAll(Iterable<Cell> cells, {Cell? after}) {
    var index = after != null ? _cells.indexOf(after) + 1 : _cells.length;
    for (final c in cells) {
      _cells.insert(index, c);
      _cellIds[c.id] = c;
      _cellTopologyIds[c.topologyId] = c;
      c._attachToTopology(this);
      index++;
    }
  }

  void remove(Cell c) {
    c._detachFromTopology();
    _cells.remove(c);
    _cellIds.remove(c.id);
    _cellTopologyIds.remove(c.topologyId);
  }

  void _addStar(NodeId id, Cell cell) {
    final node = getById(id);
    node._addStar(cell);
  }

  void _removeStar(NodeId id, Cell cell) {
    final node = getById(id);
    node._removeStar(cell);
  }

  C getById<C extends Cell>(NodeId id) => _cellIds[id] as C;
  C get<C extends Cell>(TopologyId id) => _cellTopologyIds[id] as C;
  C? maybeGet<C extends Cell>(TopologyId id) {
    if (!_cellTopologyIds.containsKey(id)) return null;
    return _cellTopologyIds[id] as C;
  }

  bool isEquivalentTo(Topology other) => isEquivalent(cells, other.cells);

  static bool isEquivalent(List<Cell> a, List<Cell> b) {
    if (a.length != b.length) return false;
    if (a.isEmpty) return true;

    final indexA = <NodeId, int>{};
    final indexB = <NodeId, int>{};

    for (var i = 0; i < a.length; i++) {
      indexA[a[i].id] = i;
      indexB[b[i].id] = i;
    }

    for (var i = 0; i < a.length; i++) {
      final cellA = a[i], cellB = b[i];
      if (cellA.type != cellB.type) return false;

      final starA = cellA.star, starB = cellB.star;
      final indicesA = <int>{}, indicesB = <int>{};
      for (final c in starA) {
        final idx = indexA[c.id];
        if (idx != null) indicesA.add(idx);
      }
      for (final c in starB) {
        final idx = indexB[c.id];
        if (idx != null) indicesB.add(idx);
      }

      if (indicesA.length != indicesB.length) return false;
      if (!indicesA.containsAll(indicesB)) return false;
    }

    return true;
  }
}

class SceneTopology extends Topology {
  SceneTopology(this.scene);

  final Scene scene;

  @override
  void add(Cell c, {Cell? after}) {
    if (after == null) throw ArgumentError('`after` must be provided when adding a cell to the scene topology.');
    final parent = after.parent!;
    final index = parent.children.indexOf(after);
    parent._insertChild(index, c);
  }

  @override
  void addAll(Iterable<Cell> cells, {Cell? after}) {
    if (after == null) throw ArgumentError('`after` must be provided when adding cells to the scene topology.');
    final parent = after.parent!;
    final index = parent.children.indexOf(after);
    parent._insertChildren(index, cells);
  }

  @override
  void remove(Cell c) {
    c.detach();
  }

  @override
  C getById<C extends Cell>(NodeId id) => scene._getNode(id);

  @override
  C get<C extends Cell>(TopologyId id) => scene._getCell(id);

  @override
  C? maybeGet<C extends Cell>(TopologyId id) => scene._maybeGetCell(id);
}
