part of '../../_program.dart';

/// A [LiveIndex] keeps track of all currently live cells and covertices.
final class LiveIndex {
  LiveIndex(this.evaluation);
  final Evaluation evaluation;

  final _cells = {
    CellKind.frame: HashSet<FrameRef>(),
    CellKind.vertex: HashSet<VertexRef>(),
    CellKind.edge: HashSet<EdgeRef>(),
    CellKind.face: HashSet<FaceRef>(),
  };

  final _covertices = HashSet<CovertexRef>();
  final _allCells = HashSet<CellRef>();

  Set<CellRef> get all => _allCells;
  Set<CellRef> ofKind(CellKind kind) => _cells[kind]!;
  Set<CovertexRef> get covertices => _covertices;

  bool contains(CellRef r) => _allCells.contains(r);
  int get length => _allCells.length;

  void _add(CellRef r) {
    _cells[r.kind]!.add(r);
    _allCells.add(r);

    if (r.kind == .edge) {
      final cv1 = CovertexRef.start(r.asEdge);
      final cv2 = CovertexRef.end(r.asEdge);
      _covertices.add(cv1);
      _covertices.add(cv2);
    }
  }

  void _remove(CellRef r) {
    _cells[r.kind]!.remove(r);
    _allCells.remove(r);

    if (r.kind == .edge) {
      final cv1 = CovertexRef.start(r.asEdge);
      final cv2 = CovertexRef.end(r.asEdge);
      _covertices.remove(cv1);
      _covertices.remove(cv2);
    }
  }

  void attach(Commit c) {
    for (final r in c.deleted) _remove(r);
    for (final r in c.added) _add(r);
  }

  void detach(Commit c) {
    for (final r in c.added) _remove(r);
    for (final r in c.deleted) _add(r);
  }
}
