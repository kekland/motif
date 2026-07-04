part of 'core.dart';

extension type const CellId(int id) implements int {
  static CellId generate() => .new(_id++);
  static var _id = 0;

  static const CellId keep = .new(-1);
  static const CellId none = .new(-2);

  static CellId resolve(CellId existing, CellId requested) {
    if (requested == .keep) return existing;
    if (requested == .none) return generate();
    return requested;
  }
}

sealed class CellPrimitive {
  CellPrimitive({CellId? id}) : id = id ?? .generate();
  final CellId id;

  CellPrimitive copyWith({CellId id = .keep});
  CellPrimitive transform(Matrix4 transform, {CellId id = .keep});
}

sealed class Cell with LinkedListEntry<Cell>, Selectable {
  Cell({CellId? id, List<Modifier>? modifiers}) : id = id ?? .generate(), _modifiers = modifiers ?? const [];

  final CellId id;

  var _dirty = false;
  VectorComplex? _complex;
  void _markAsDirty() {
    _complex?._markCellAsDirty(this);
    _dirty = true;
  }

  int get degree => _star.length;
  late final star = UnmodifiableSetView<Cell>(_star);
  final _star = <Cell>{};

  void _addStar(Cell c) => _star.add(c);
  void _removeStar(Cell c) => _star.remove(c);

  List<Modifier> _modifiers;
  List<Modifier> get modifiers => _modifiers;
  set modifiers(List<Modifier> value) {
    _modifiers = value;
    _markAsDirty();
  }

  Aabb2 get bbox;
  Aabb2 get bboxTight;

  Cell copyWith();
  CellPrimitive deflate();

  @override
  ReadonlySignal<Cell> call();
}
