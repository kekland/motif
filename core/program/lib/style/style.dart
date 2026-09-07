part of '../program.dart';

sealed class const CellStyle<H extends CellHandle>() {
  static CellStyle defaultOf(CellKind kind) => switch (kind) {
    .vertex => VertexStyle.default_,
    .edge => EdgeStyle.default_,
    .face => FaceStyle.default_,
    _ => throw ArgumentError.value(kind, 'kind', 'unsupported kind'),
  };

  CellStyle<H> updateWith(covariant CellStylePartial<H>? partial) => partial == null ? this : partial.apply(this);
  CellKind get kind;

  VertexStyle get asVertex {
    assert(kind == .vertex);
    return this as VertexStyle;
  }

  EdgeStyle get asEdge {
    assert(kind == .edge);
    return this as EdgeStyle;
  }

  FaceStyle get asFace {
    assert(kind == .face);
    return this as FaceStyle;
  }
}

sealed class const CellStylePartial<H extends CellHandle>() extends Partial<CellStyle<H>> {
  @override
  CellStyle<H> apply(covariant CellStyle<H> style);
}
