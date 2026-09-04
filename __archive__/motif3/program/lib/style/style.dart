part of '../program.dart';

sealed class const CellStyle<D extends CellStyle<D>>() {
  static CellStyle defaultOf(CellKind kind) => switch (kind) {
    .vertex => VertexStyle.default_,
    .edge => EdgeStyle.default_,
    .face => FaceStyle.default_,
    _ => throw ArgumentError.value(kind, 'kind', 'unsupported kind'),
  };

  D updateWith(covariant CellStylePartial<D>? partial) => partial == null ? this as D : partial.apply(this as D);
  CellKind get kind;
}

sealed class const CellStylePartial<D extends CellStyle<D>>() extends Partial<D> {
  @override
  D apply(D style);
}

final class StyleTable {
  final _styles = <CellKey, CellStyle>{};

  CellStyle? of(CellKey key) => _styles[key];

  VertexStyle? ofVertex(CellKey key) => of(key) as VertexStyle?;
  EdgeStyle? ofEdge(CellKey key) => of(key) as EdgeStyle?;
  FaceStyle? ofFace(CellKey key) => of(key) as FaceStyle?;

  void bind(CellKey key, CellStyle decoration) {
    _styles[key] = decoration;
  }
}

final class StyleOverrides {
  StyleOverrides();
  StyleOverrides.empty() : this();

  final _styles = <CellKey, CellStylePartial>{};
  Iterable<MapEntry<CellKey, CellStylePartial>> get entries => _styles.entries;

  CellStylePartial? of(CellKey key) => _styles[key];
  void set(CellKey key, CellStylePartial? decoration) {
    if (decoration == null) {
      _styles.remove(key);
      return;
    }

    _styles[key] = decoration;
  }

  // StyleOverrides slice(Set<StatementId> targets) {
  //   final result = StyleOverrides();
  //   for (final entry in _styles.entries) {
  //     if (targets.contains(entry.key.statement)) {
  //       result._styles[entry.key] = entry.value;
  //     }
  //   }
  //   return result;
  // }

  // StyleOverrides remap(Ref Function(Ref) remapRef) {
  //   final result = StyleOverrides();
  //   for (final entry in _styles.entries) {
  //     final newRef = remapRef(entry.key);
  //     result._styles[newRef] = entry.value;
  //   }
  //   return result;
  // }
}
