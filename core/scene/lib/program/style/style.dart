part of '../program.dart';

sealed class const CellStyle<D extends CellStyle<D>>() {
  static CellStyle defaultOf(CellKind kind) => switch (kind) {
    .edge => EdgeStyle.default_,
    .face => FaceStyle.default_,
    _ => throw ArgumentError.value(kind, 'kind', 'unsupported kind'),
  };

  D updateWith(covariant CellStylePartial<D>? partial) => partial == null ? this as D : partial.apply(this as D);
}

sealed class const CellStylePartial<D extends CellStyle<D>>() extends Partial<D> {
  @override
  D apply(D style);
}

final class StyleTable {
  final _styles = <Ref, CellStyle>{};

  T? of<T extends CellStyle<T>>(Ref ref) => _styles[ref] as T?;
  EdgeStyle? ofEdge(Ref ref) => of(ref);
  FaceStyle? ofFace(Ref ref) => of(ref);

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
