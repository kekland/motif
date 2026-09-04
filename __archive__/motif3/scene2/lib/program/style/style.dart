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
