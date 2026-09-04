part of '../program.dart';

extension EmbedProgram on Program {
  ProgramAnchor resolveEmbeddingAnchor(ProgramSlice slice) {
    final ids = {for (final s in slice.statements) s.id};
    var last = -1;

    for (final s in slice.statements) {
      for (final r in s.references) {
        if (ids.contains(r)) continue;
        final i = indexOf(r);
        if (i == null) throw StateError('reference $r does not exist in program');
        if (i > last) last = i;
      }
    }

    return last < 0 ? .start() : .after(this[last].id);
  }
}
