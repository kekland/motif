part of '../program.dart';

final class StyleTable {
  final _styles = <Ref, CellStyle>{};

  CellStyle? of(Ref ref) => _styles[ref];

  VertexStyle? ofVertex(Ref ref) => of(ref) as VertexStyle?;
  EdgeStyle? ofEdge(Ref ref) => of(ref) as EdgeStyle?;
  FaceStyle? ofFace(Ref ref) => of(ref) as FaceStyle?;

  void bind(Ref ref, CellStyle decoration) {
    _styles[ref] = decoration;
  }
}

final class StyleOverrides {
  StyleOverrides();
  StyleOverrides.empty() : this();

  final _styles = <Ref, CellStylePartial>{};
  Iterable<MapEntry<Ref, CellStylePartial>> get entries => _styles.entries;

  CellStylePartial? of(Ref ref) => _styles[ref];
  void set(Ref ref, CellStylePartial? decoration) {
    if (decoration == null) {
      _styles.remove(ref);
      return;
    }

    _styles[ref] = decoration;
  }

  StyleOverrides slice(Set<StatementId> targets) {
    final result = StyleOverrides();
    for (final entry in _styles.entries) {
      if (targets.contains(entry.key.statement)) {
        result._styles[entry.key] = entry.value;
      }
    }
    return result;
  }

  StyleOverrides remap(Ref Function(Ref) remapRef) {
    final result = StyleOverrides();
    for (final entry in _styles.entries) {
      final newRef = remapRef(entry.key);
      result._styles[newRef] = entry.value;
    }
    return result;
  }
}
