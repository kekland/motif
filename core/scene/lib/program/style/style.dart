part of '../program.dart';

sealed class const CellStyle<D extends CellStyle<D>>() {
  static CellStyle defaultOf(CellKind kind) => switch (kind) {
    .edge => EdgeStyle.default_,
    .face => FaceStyle.default_,
    _ => throw ArgumentError.value(kind, 'kind', 'unsupported kind'),
  };

  D updateWith(covariant CellStylePartial<D>? partial) => partial == null ? this as D : partial.apply(this as D);
}

sealed class const CellStylePartial<D extends CellStyle<D>>() {
  D apply(D style);
}

final class StyleTable {
  final _styles = <Ref, CellStyle>{};

  T of<T extends CellStyle<T>>(Ref ref) => _styles[ref] as T;

  void bind(Ref ref, CellStyle decoration) {
    _styles[ref] = decoration;
  }
}

final class StyleOverrides {
  StyleOverrides();
  StyleOverrides.empty() : this();

  final _styles = <Ref, CellStylePartial>{};

  CellStylePartial? of(Ref ref) => _styles[ref];
  void set(Ref ref, CellStylePartial decoration) {
    _styles[ref] = decoration;
  }
}
