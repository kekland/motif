part of 'core.dart';

int _uuid = 0;
int _cellId() => _uuid++;

mixin Cell on node.Node {
  int get id;

  UnmodifiableSetView<Cell> get star;
  int get degree => star.length;

  Aabb2 get bbox;
}

abstract class ImmutableCell extends node.ImmutableNodeBase<ImmutableCell, MutableCell> with Cell {
  ImmutableCell({int? id}) : id = id ?? _cellId();

  factory ImmutableCell.vertex(Vector2 position, {int? id}) = ImmutableVertex;
  factory ImmutableCell.edge(
    ImmutableVertex start,
    ImmutableVertex end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    int? id,
  }) = ImmutableEdge;

  @override
  final int id;

  @override
  late final star = UnmodifiableSetView<ImmutableCell>(_star);
  final _star = <ImmutableCell>{};

  void _addStar(Cell c) => _star.add(c as ImmutableCell);
}

abstract base class MutableCell extends node.MutableNodeBase<ImmutableCell, MutableCell>
    with Cell, LinkedListEntry<MutableCell> {
  MutableCell({int? id}) : id = id ?? _cellId();

  factory MutableCell.vertex(Vector2 position, {int? id}) = MutableVertex;
  factory MutableCell.edge(
    MutableVertex start,
    MutableVertex end, {
    EdgePath? path,
    EdgeDecoration? decoration,
    EdgeWeights? weights,
    int? id,
  }) = MutableEdge;

  @override
  final int id;

  @override
  late final star = UnmodifiableSetView<MutableCell>(_star);
  final _star = <MutableCell>{};

  void _addStar(Cell c) => _star.add(c as MutableCell);
  void _removeStar(Cell c) => _star.remove(c as MutableCell);
}
