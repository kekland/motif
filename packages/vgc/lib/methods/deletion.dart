part of '../vector_complex.dart';

extension VectorComplexDeletion on VectorComplex {
  void hardDelete(Cell c) {
    assert(contains(c));

    final toDelete = <Cell>{c, ...c.star};

    for (final f in toDelete.whereType<Face>()) _detach(f);
    for (final e in toDelete.whereType<Edge>()) _detach(e);
    for (final v in toDelete.whereType<Vertex>()) _detach(v);

    _internalNotify();
  }
}
