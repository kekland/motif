part of '../program.dart';

extension type const EmbeddingWindow._((int, int) _) {
  int get lower => _.$1;
  int get upper => _.$2;

  bool contains(int index) => lower <= index && index <= upper;
}

extension EmbedProgram on Program {
  EmbeddingWindow? resolveEmbeddingWindow(ProgramSlice slice) {
    final inside = slice.ids.toSet();
    var lo = 0, hi = length;

    for (final s in slice.statements) {
      for (final arg in s.args) {
        final ref = arg.ref;
        if (inside.contains(ref.statement)) continue;

        final p = indexOf(ref.statement);
        if (p == null) return null;
        if (p + 1 > lo) lo = p + 1;

        final owner = graph.ownerOf(ref);
        final hasOutsideOwner = owner != null && !inside.contains(owner);

        if (arg is Own) {
          if (hasOutsideOwner) return null;
          for (final b in graph.borrowersOf(ref)) {
            if (inside.contains(b)) continue;
            final i = indexOf(b);
            if (i != null && i + 1 > lo) lo = i + 1;
          }
        } else {
          if (hasOutsideOwner) {
            final w = indexOf(owner!);
            if (w != null && w < hi) hi = w;
          }
        }
      }
    }

    return lo > hi ? null : EmbeddingWindow._((lo, hi));
  }
}
