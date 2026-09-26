// ignore_for_file: unused_element

import 'dart:convert';

import 'package:schema/program.dart' as gen;
import 'package:shared/shared.dart';
import 'package:color/color.dart';
import 'package:kernel/kernel.dart';
import 'package:program/program.dart';
import 'package:geometry/geometry.dart';
import 'package:blueprint/core.dart' as bp;

// ---------------------------------------------------------------------------------------------------------------------
// Setup
// ---------------------------------------------------------------------------------------------------------------------

final class _FunctionalConverter<S, T> extends Converter<S, T> {
  new(this._convert);
  final T Function(S input) _convert;

  @override
  T convert(S input) => _convert(input);
}

final class _FunctionalCodec<S, T> extends Codec<S, T> {
  new({required this.decoder, required this.encoder});

  _FunctionalCodec.from({required S Function(T input) decoder, required T Function(S input) encoder})
    : this(decoder: .new(decoder), encoder: .new(encoder));

  @override
  final _FunctionalConverter<T, S> decoder;

  @override
  final _FunctionalConverter<S, T> encoder;
}

_FunctionalCodec<S, T> _codec<S, T>({
  required S Function(T input) decoder,
  required T Function(S input) encoder,
}) => .from(decoder: decoder, encoder: encoder);

T? _opt<T>(bool Function() hasValue, T Function() value) => hasValue() ? value() : null;

List<R> _map<T, R>(Iterable<T> list, R Function(T) mapper) => list.map(mapper).toList();

// dart format off

// ---------------------------------------------------------------------------------------------------------------------
// Program
// ---------------------------------------------------------------------------------------------------------------------

final programCodec = _codec<Program, gen.Program>(
  decoder: (v) => .new(
    _map(v.statements, (v) => v.decode()),
    styles: v.style.decode(),
    zOrders: v.zOrder.decode(),
  ),
  encoder: (v) => .new(
    statements: _map(v.statements, (v) => v.encode()),
    style: v.styles.encode(),
    zOrder: v.zOrders.encode(),
  ),
);

final programSliceCodec = _codec<ProgramSlice, gen.ProgramSlice>(
  decoder: (v) => .new(
    statements: _map(v.statements, (v) => v.decode()),
    // styles: v.style.decode(),
    // zOrders: v.zOrder.decode(),
  ),
  encoder: (v) => .new(
    statements: _map(v.statements, (v) => v.encode()),
    // style: v.styles.encode(),
    // zOrder: v.zOrders.encode(),
  ),
);


extension _U64Encode on U64 { gen.U64 encode() => _u64Codec.encode(this); }
extension _U64Decode on gen.U64 { U64 decode() => _u64Codec.decode(this); }

final _u64Codec = _codec<U64, gen.U64>(
  decoder: (v) => .of(v.hi, v.lo),
  encoder: (v) => .new(hi: v.hi, lo: v.lo),
);

extension _StatementIdEncode on StatementId { gen.StatementId encode() => _statementIdCodec.encode(this); }
extension _StatementIdDecode on gen.StatementId { StatementId decode() => _statementIdCodec.decode(this); }

final _statementIdCodec = _codec<StatementId, gen.StatementId>(
  decoder: (v) => .raw(v.value.decode()),
  encoder: (v) => .new(value: v.value.encode()),
);

extension _CellKindEncode on CellKind { gen.CellKind encode() => _cellKindCodec.encode(this); }
extension _CellKindDecode on gen.CellKind { CellKind decode() => _cellKindCodec.decode(this); }

final _cellKindCodec = _codec<CellKind, gen.CellKind>(
  decoder: (v) => switch(v) {
    .CELL_KIND_FRAME => .frame,
    .CELL_KIND_VERTEX => .vertex,
    .CELL_KIND_EDGE => .edge,
    .CELL_KIND_FACE => .face,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .frame => .CELL_KIND_FRAME,
    .vertex => .CELL_KIND_VERTEX,
    .edge => .CELL_KIND_EDGE,
    .face => .CELL_KIND_FACE,
  },
);

extension _CellRefEncode on CellRef { gen.CellRef encode() => _cellRefCodec.encode(this); }

final _refKindMap = <gen.CellKind, Type>{
  .CELL_KIND_FRAME: FrameHandle,
  .CELL_KIND_VERTEX: VertexHandle,
  .CELL_KIND_EDGE: EdgeHandle,
  .CELL_KIND_FACE: FaceHandle,
};

void _checkRefKind<H extends CellHandle>(gen.CellKind kind) {
  if (H != CellHandle && _refKindMap[kind] != H) {
    throw ArgumentError('CellRef kind $kind does not match expected type $H');
  }
}

extension _CellRefDecode on gen.CellRef {
  CellRef<H> decode<H extends CellHandle>() {
    _checkRefKind<H>(kind);
    return .make(namespace: namespace.decode(), op: tag, sub: sub, kind: kind.decode());
  }
}

final _cellRefCodec = _codec<CellRef, gen.CellRef>(
  decoder: (v) => .make(namespace: v.namespace.decode(), op: v.tag, sub: v.sub, kind: v.kind.decode()),
  encoder: (v) => .new(namespace: v.namespace.encode(), tag: v.op, sub: v.sub, kind: v.kind.encode()),
);

// ---------------------------------------------------------------------------------------------------------------------
// Z-order
// ---------------------------------------------------------------------------------------------------------------------

extension _ZOrderTableEncode on ZOrderTable { gen.ZOrderTable encode() => _zOrderTableCodec.encode(this); }
extension _ZOrderTableDecode on gen.ZOrderTable { ZOrderTable decode() => _zOrderTableCodec.decode(this); }

final _zOrderTableCodec = _codec<ZOrderTable, gen.ZOrderTable>(
  decoder: (v) => .new({
    for (final e in v.entries) e.ref.decode(): e.value.decode(),
  }),
  encoder: (v) => .new(entries: [
    for (final e in v.entries) .new(ref: e.key.encode(), value: e.value.encode()),
  ])
);

extension _ZAnchorEncode on ZAnchor { gen.ZAnchor encode() => _zAnchorCodec.encode(this); }
extension _ZAnchorDecode on gen.ZAnchor { ZAnchor decode() => _zAnchorCodec.decode(this); }

final _zAnchorCodec = _codec<ZAnchor, gen.ZAnchor>(
  decoder: (v) => switch(v.whichValue()) {
    .top => ZAnchor.top(),
    .bottom => ZAnchor.bottom(),
    .above => ZAnchor.above(v.above.decode()),
    .below => ZAnchor.below(v.below.decode()),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    ZTop() => .new(top: true),
    ZBottom() => .new(bottom: true),
    ZAbove v => .new(above: v.sibling.encode()),
    ZBelow v => .new(below: v.sibling.encode()),
  },
);

// ---------------------------------------------------------------------------------------------------------------------
// Styles
// ---------------------------------------------------------------------------------------------------------------------

extension _StyleTableEncode on StyleTable { gen.StyleTable encode() => _styleTableCodec.encode(this); }
extension _StyleTableDecode on gen.StyleTable { StyleTable decode() => _styleTableCodec.decode(this); }

final _styleTableCodec = _codec<StyleTable, gen.StyleTable>(
  decoder: (v) => .new({
    for (final e in v.entries) e.ref.decode(): e.value.decode(),
  }),
  encoder: (v) => .new(entries: [
    for (final e in v.entries) .new(ref: e.key.encode(), value: e.value.encode()),
  ])
);

extension _CellStylePartialEncode on CellStylePartial { gen.CellStyle_Partial encode() => _cellStylePartialCodec.encode(this); }
extension _CellStylePartialDecode on gen.CellStyle_Partial { CellStylePartial decode() => _cellStylePartialCodec.decode(this); }

final _cellStylePartialCodec = _codec<CellStylePartial, gen.CellStyle_Partial>(
  decoder: (v) => switch(v.whichValue()) {
    .vertex => v.vertex.decode(),
    .edge => v.edge.decode(),
    .face => v.face.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    VertexStylePartial v => .new(vertex: v.encode()),
    EdgeStylePartial v => .new(edge: v.encode()),
    FaceStylePartial v => .new(face: v.encode()),
  },
);

extension _CellStyleEncode on CellStyle { gen.CellStyle encode() => _cellStyleCodec.encode(this); }
extension _CellStyleDecode on gen.CellStyle { CellStyle decode() => _cellStyleCodec.decode(this); }

final _cellStyleCodec = _codec<CellStyle, gen.CellStyle>(
  decoder: (v) => switch(v.whichValue()) {
    .vertex => v.vertex.decode(),
    .edge => v.edge.decode(),
    .face => v.face.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    VertexStyle v => .new(vertex: v.encode()),
    EdgeStyle v => .new(edge: v.encode()),
    FaceStyle v => .new(face: v.encode()),
  },
);

extension _VertexStyleEncode on VertexStyle { gen.VertexStyle encode() => _vertexStyleCodec.encode(this); }
extension _VertexStyleDecode on gen.VertexStyle { VertexStyle decode() => _vertexStyleCodec.decode(this); }

final _vertexStyleCodec = _codec<VertexStyle, gen.VertexStyle>(
  decoder: (v) => .new(
    color: v.color.decode(),
    radius: v.radius,
  ),
  encoder: (v) => .new(
    color: v.color.encode(),
    radius: v.radius,
  ),
);

extension _EdgeStyleEncode on EdgeStyle { gen.EdgeStyle encode() => _edgeStyleCodec.encode(this); }
extension _EdgeStyleDecode on gen.EdgeStyle { EdgeStyle decode() => _edgeStyleCodec.decode(this); }

final _edgeStyleCodec = _codec<EdgeStyle, gen.EdgeStyle>(
  decoder: (v) => .new(
    color: v.color.decode(),
    width: v.width,
  ),
  encoder: (v) => .new(
    color: v.color.encode(),
    width: v.width,
  ),
);

extension _FaceStyleEncode on FaceStyle { gen.FaceStyle encode() => _faceStyleCodec.encode(this); }
extension _FaceStyleDecode on gen.FaceStyle { FaceStyle decode() => _faceStyleCodec.decode(this); }

final _faceStyleCodec = _codec<FaceStyle, gen.FaceStyle>(
  decoder: (v) => .new(
    color: v.color.decode(),
  ),
  encoder: (v) => .new(
    color: v.color.encode(),
  ),
);

extension _VertexStylePartialEncode on VertexStylePartial { gen.VertexStyle_Partial encode() => _vertexStylePartialCodec.encode(this); }
extension _VertexStylePartialDecode on gen.VertexStyle_Partial { VertexStylePartial decode() => _vertexStylePartialCodec.decode(this); }

final _vertexStylePartialCodec = _codec<VertexStylePartial, gen.VertexStyle_Partial>(
  decoder: (v) => .new(
    color: _opt(v.hasColor, () => v.color.decode()),
    radius: _opt(v.hasRadius, () => v.radius),
  ),
  encoder: (v) => .new(
    color: v.color?.encode(),
    radius: v.radius,
  ),
);

extension _EdgeStylePartialEncode on EdgeStylePartial { gen.EdgeStyle_Partial encode() => _edgeStylePartialCodec.encode(this); }
extension _EdgeStylePartialDecode on gen.EdgeStyle_Partial { EdgeStylePartial decode() => _edgeStylePartialCodec.decode(this); }

final _edgeStylePartialCodec = _codec<EdgeStylePartial, gen.EdgeStyle_Partial>(
  decoder: (v) => .new(
    color: _opt(v.hasColor, () => v.color.decode()),
    width: _opt(v.hasWidth, () => v.width),
  ),
  encoder: (v) => .new(
    color: v.color?.encode(),
    width: v.width,
  ),
);

extension _FaceStylePartialEncode on FaceStylePartial { gen.FaceStyle_Partial encode() => _faceStylePartialCodec.encode(this); }
extension _FaceStylePartialDecode on gen.FaceStyle_Partial { FaceStylePartial decode() => _faceStylePartialCodec.decode(this); }

final _faceStylePartialCodec = _codec<FaceStylePartial, gen.FaceStyle_Partial>(
  decoder: (v) => .new(
    color: _opt(v.hasColor, () => v.color.decode()),
  ),
  encoder: (v) => .new(
    color: v.color?.encode(),
  ),
);

// ---------------------------------------------------------------------------------------------------------------------
// Selectors
// ---------------------------------------------------------------------------------------------------------------------

extension _CellSelectorEncode on CellSelector { gen.CellSelector encode() => _cellSelectorCodec.encode(this); }
extension _CellSelectorDecode on gen.CellSelector {
  CellSelector<H> decode<H extends CellHandle>() {
    _checkRefKind<H>(ref.kind);
    return _cellSelectorCodec.decode(this) as CellSelector<H>;
  }
}

final _cellSelectorCodec = _codec<CellSelector, gen.CellSelector>(
  decoder: (v) => .new(v.ref.decode()),
  encoder: (v) => .new(ref: v.ref.encode())
);

extension _ChainSelectorEncode on ChainSelector { gen.ChainSelector encode() => _chainSelectorCodec.encode(this); }
extension _ChainSelectorDecode on gen.ChainSelector { ChainSelector decode() => _chainSelectorCodec.decode(this); }

final _chainSelectorCodec = _codec<ChainSelector, gen.ChainSelector>(
  decoder: (v) => .new(_map(v.edges, (v) => v.decode<EdgeHandle>())),
  encoder: (v) => .new(edges: _map(v.edges, (v) => v.encode())),
);

extension _FragmentSelectorEncode on FragmentSelector { gen.FragmentSelector encode() => _fragmentSelectorCodec.encode(this); }
extension _FragmentSelectorDecode on gen.FragmentSelector { FragmentSelector decode() => _fragmentSelectorCodec.decode(this); }

final _fragmentSelectorCodec = _codec<FragmentSelector, gen.FragmentSelector>(
  decoder: (v) => .new(v.id.decode(), modifierIndex: _opt(v.hasModifierIndex, () => v.modifierIndex)),
  encoder: (v) => .new(id: v.id.encode(), modifierIndex: v.modifierIndex),
);

extension _ParentSelectorEncode on ParentSelector { gen.ParentSelector encode() => _parentSelectorCodec.encode(this); }
extension _ParentSelectorDecode on gen.ParentSelector { ParentSelector decode() => _parentSelectorCodec.decode(this); }

final _parentSelectorCodec = _codec<ParentSelector, gen.ParentSelector>(
  decoder: (v) => .new(v.ref.decode()),
  encoder: (v) => .new(ref: v.ref.encode()),
);


extension _SelectorEncode on Selector { gen.Selector encode() => _selectorCodec.encode(this); }
extension _SelectorDecode on gen.Selector { Selector decode() => _selectorCodec.decode(this); }

final _selectorCodec = _codec<Selector, gen.Selector>(
  decoder: (v) => switch(v.whichValue()) {
    .cell => v.cell.decode(),
    .chain => v.chain.decode(),
    .fragment => v.fragment.decode(),
    .parent => v.parent.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    CellSelector v => .new(cell: v.encode()),
    ParentSelector v => .new(parent: v.encode()),
    ChainSelector v => .new(chain: v.encode()),
    FragmentSelector v => .new(fragment: v.encode()),
  },
);

extension _SingleSelectorEncode<H extends CellHandle> on Selector<CellRef<H>> { gen.SingleSelector encode() => _singleSelectorCodec.encode(this); }
extension _SingleSelectorDecode on gen.SingleSelector { 
  Selector<CellRef<H>> decode<H extends CellHandle>() {
    switch(whichValue()) {
      case .cell: return cell.decode<H>();
      case .notSet: throw ArgumentError();
    }
  }
}

final _singleSelectorCodec = _codec<Selector, gen.SingleSelector>(
  decoder: (v) => switch(v.whichValue()) {
    .cell => v.cell.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    CellSelector v => .new(cell: v.encode()),
    _ => throw ArgumentError('Selector is not a single selector'),
  },
);

// ---------------------------------------------------------------------------------------------------------------------
// Statements
// ---------------------------------------------------------------------------------------------------------------------

extension _StatementEncode on Statement { gen.Statement encode() => _statementCodec.encode(this); }
extension _StatementDecode on gen.Statement { Statement decode() => _statementCodec.decode(this); }

final _statementCodec = _codec<Statement, gen.Statement>(
  decoder: (v) => switch(v.whichValue()) {
    .vertex => _vertexStatementCodec.decode(v),
    .edge => _edgeStatementCodec.decode(v),
    .face => _faceStatementCodec.decode(v),
    .cutEdge => _cutEdgeStatementCodec.decode(v),
    .filletFace => _filletFaceStatementCodec.decode(v),
    .glueVertices => _glueVerticesStatementCodec.decode(v),
    .rectangle => _rectangleStatementCodec.decode(v),
    .polygon => _polygonStatementCodec.decode(v),
    .ellipse => _ellipseStatementCodec.decode(v),
    .container => _containerStatementCodec.decode(v),
    .group => _groupStatementCodec.decode(v),
    .multiCutEdge => _multiCutEdgeStatementCodec.decode(v),
    .generator => _generatorStatementCodec.decode(v),
    .text => _textStatementCodec.decode(v),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    VertexStatement v => _vertexStatementCodec.encode(v),
    EdgeStatement v => _edgeStatementCodec.encode(v),
    FaceStatement v => _faceStatementCodec.encode(v),
    CutEdgeStatement v => _cutEdgeStatementCodec.encode(v),
    FilletFaceStatement v => _filletFaceStatementCodec.encode(v),
    GlueVerticesStatement v => _glueVerticesStatementCodec.encode(v),
    RectangleStatement v => _rectangleStatementCodec.encode(v),
    PolygonStatement v => _polygonStatementCodec.encode(v),
    EllipseStatement v => _ellipseStatementCodec.encode(v),
    ContainerStatement v => _containerStatementCodec.encode(v),
    GroupStatement v => _groupStatementCodec.encode(v),
    MultiCutEdgeStatement v => _multiCutEdgeStatementCodec.encode(v),
    GeneratorStatement v => _generatorStatementCodec.encode(v),
    TextStatement v => _textStatementCodec.encode(v),
    PlacedStatement() => unreachable(),
    GeneratingStatement() => unreachable(),
    FacedStatement() => unreachable(),
    FramedStatement() => unreachable(),
  },
);


final _vertexStatementCodec = _codec<VertexStatement, gen.Statement>(
  decoder: (v) => .new(
    v.vertex.position.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    style: v.vertex.style.decode(),
    parent: _opt(v.vertex.hasParent, () => v.vertex.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    vertex: .new(
      position: v.position.encode(),
      style: v.style.encode(),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _edgeStatementCodec = _codec<EdgeStatement, gen.Statement>(
  decoder: (v) => .new(
    v.edge.start.decode(),
    v.edge.end.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    startTangent: _opt(v.edge.hasStartTangent, () => v.edge.startTangent.decode()),
    endTangent: _opt(v.edge.hasEndTangent, () => v.edge.endTangent.decode()),
    style: v.edge.style.decode(),
    parent: _opt(v.edge.hasParent, () => v.edge.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    edge: .new(
      start: v.start.encode(),
      end: v.end.encode(),
      startTangent: v.startTangent?.encode(),
      endTangent: v.endTangent?.encode(),
      style: v.style.encode(),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _faceStatementCodec = _codec<FaceStatement, gen.Statement>(
  decoder: (v) => .new(
    v.face.outer.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    style: v.face.style.decode(),
    holes: _map(v.face.holes, (v) => v.decode()),
    parent: _opt(v.face.hasParent, () => v.face.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    face: .new(
      outer: v.outer.encode(),
      style: v.style.encode(),
      holes: _map(v.holes, (v) => v.encode()),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _cutEdgeStatementCodec = _codec<CutEdgeStatement, gen.Statement>(
  decoder: (v) => .new(
    v.cutEdge.target.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    t: v.cutEdge.t,
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    cutEdge: .new(
      target: v.target.encode(),
      t: v.t,
    ),
  ),
);

final _filletFaceStatementCodec = _codec<FilletFaceStatement, gen.Statement>(
  decoder: (v) => .new(
    v.filletFace.face.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    corners: .fromEntries(_map(v.filletFace.corners, (v) => .new(v.index, v.radius.decode()))),
    radius: _opt(v.filletFace.hasRadius, () => v.filletFace.radius.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    filletFace: .new(
      face: v.face.encode(),
      corners: _map(v.corners.entries, (e) => .new(index: e.key, radius: e.value.encode())),
      radius: v.radius?.encode(),
    ),
  )
);

extension _GlueVerticesStatementPositionEncode on GlueVerticesPosition { gen.GlueVerticesStatement_Position encode() => _glueVerticesStatementPositionCodec.encode(this); }
extension _GlueVerticesStatementPositionDecode on gen.GlueVerticesStatement_Position { GlueVerticesPosition decode() => _glueVerticesStatementPositionCodec.decode(this); }

final _glueVerticesStatementPositionCodec = _codec<GlueVerticesPosition, gen.GlueVerticesStatement_Position>(
  decoder: (v) => switch(v) {
    .GLUE_VERTICES_STATEMENT_POSITION_FIRST => .first,
    .GLUE_VERTICES_STATEMENT_POSITION_CENTROID => .centroid,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .first => .GLUE_VERTICES_STATEMENT_POSITION_FIRST,
    .centroid => .GLUE_VERTICES_STATEMENT_POSITION_CENTROID,
  }
);

final _glueVerticesStatementCodec = _codec<GlueVerticesStatement, gen.Statement>(
  decoder: (v) => .new(
    _map(v.glueVertices.vertices, (v) => v.decode()),
    position: v.glueVertices.position.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    glueVertices: .new(
      vertices: v.vertices.map((v) => v.encode()).toList(),
      position: v.position.encode(),
    ),
  )
);

final _rectangleStatementCodec = _codec<RectangleStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    transform: _opt(v.rectangle.hasTransform, () => v.rectangle.transform.decode()),
    vertexStyle: v.rectangle.vertexStyle.decode(),
    edgeStyle: v.rectangle.edgeStyle.decode(),
    faceStyle: v.rectangle.faceStyle.decode(),
    shape: v.rectangle.shape.decode(),
    size: v.rectangle.size.decode(),
    parent: _opt(v.rectangle.hasParent, () => v.rectangle.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    rectangle: .new(
      transform: v.transform?.encode(),
      vertexStyle: v.vertexStyle.encode(),
      edgeStyle: v.edgeStyle.encode(),
      faceStyle: v.faceStyle.encode(),
      shape: v.shape.encode(),
      size: v.size.encode(),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _polygonStatementCodec = _codec<PolygonStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    transform: _opt(v.polygon.hasTransform, () => v.polygon.transform.decode()),
    vertexStyle: v.polygon.vertexStyle.decode(),
    edgeStyle: v.polygon.edgeStyle.decode(),
    faceStyle: v.polygon.faceStyle.decode(),
    shape: v.polygon.shape.decode(),
    size: v.polygon.size.decode(),
    parent: _opt(v.polygon.hasParent, () => v.polygon.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    polygon: .new(
      transform: v.transform?.encode(),
      vertexStyle: v.vertexStyle.encode(),
      edgeStyle: v.edgeStyle.encode(),
      faceStyle: v.faceStyle.encode(),
      shape: v.shape.encode(),
      size: v.size.encode(),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _ellipseStatementCodec = _codec<EllipseStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    transform: _opt(v.ellipse.hasTransform, () => v.ellipse.transform.decode()),
    vertexStyle: v.ellipse.vertexStyle.decode(),
    edgeStyle: v.ellipse.edgeStyle.decode(),
    faceStyle: v.ellipse.faceStyle.decode(),
    shape: v.ellipse.shape.decode(),
    size: v.ellipse.size.decode(),
    parent: _opt(v.ellipse.hasParent, () => v.ellipse.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    ellipse: .new(
      transform: v.transform?.encode(),
      vertexStyle: v.vertexStyle.encode(),
      edgeStyle: v.edgeStyle.encode(),
      faceStyle: v.faceStyle.encode(),
      shape: v.shape.encode(),
      size: v.size.encode(),
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _containerStatementCodec = _codec<ContainerStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    transform: _opt(v.container.hasTransform, () => v.container.transform.decode()),
    layout: v.container.layout.decode(),
    size: v.container.size.decode(),
    parent: _opt(v.container.hasParent, () => v.container.parent.decode()),
    vertexStyle: v.container.vertexStyle.decode(),
    edgeStyle: v.container.edgeStyle.decode(),
    faceStyle: v.container.faceStyle.decode(),
    shape: v.container.shape.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    container: .new(
      transform: v.transform?.encode(),
      layout: v.layout.encode(),
      size: v.size.encode(),
      parent: v.parent?.ref.encode(),
      vertexStyle: v.vertexStyle.encode(),
      edgeStyle: v.edgeStyle.encode(),
      faceStyle: v.faceStyle.encode(),
      shape: v.shape.encode(),
    ),
  )
);

final _groupStatementCodec = _codec<GroupStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    parent: _opt(v.group.hasParent, () => v.group.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    group: .new(
      parent: v.parent?.ref.encode(),
    ),
  )
);

final _multiCutEdgeStatementCodec = _codec<MultiCutEdgeStatement, gen.Statement>(
  decoder: (v) => .new(
    v.multiCutEdge.target.decode(),
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    ts: v.multiCutEdge.ts.toList(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    multiCutEdge: .new(
      target: v.target.encode(),
      ts: v.ts,
    ),
  )
);

final _generatorStatementCodec = _codec<GeneratorStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    generator: v.generator.generator.decode(),
    inputs: _map(v.generator.inputs, (e) => e.decode()),
    parent: _opt(v.generator.hasParent, () => v.generator.parent.decode()),
    transform: _opt(v.generator.hasTransform, () => v.generator.transform.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    generator: .new(
      generator: v.generator.encode(),
      inputs: _map(v.inputs, (e) => e.encode()),
      parent: v.parent?.ref.encode(),
      transform: v.transform.encode(),
    ),
  ),
);

final _textStatementCodec = _codec<TextStatement, gen.Statement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    modifiers: v.modifiers.decode(),
    text: v.text.text,
    size: v.text.size.decode(),
    transform: v.text.transform.decode(),
    parent: _opt(v.text.hasParent, () => v.text.parent.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    modifiers: v.modifiers.encode(),
    text: .new(
      text: v.text,
      size: v.size.encode(),
      transform: v.transform?.encode(),
      parent: v.parent?.ref.encode(),
    ),
  ),
);

// ---------------------------------------------------------------------------------------------------------------------
// Shape
// ---------------------------------------------------------------------------------------------------------------------

extension _ObjectShapeRectangleEncode on RectangleObjectShape { gen.ObjectShape_Rectangle encode() => _objectShapeRectangleCodec.encode(this); }
extension _ObjectShapeRectangleDecode on gen.ObjectShape_Rectangle { RectangleObjectShape decode() => _objectShapeRectangleCodec.decode(this); }

final _objectShapeRectangleCodec = _codec<RectangleObjectShape, gen.ObjectShape_Rectangle>(
  decoder: (v) => .new(),
  encoder: (v) => .new(),
);

extension _ObjectShapePolygonEncode on PolygonObjectShape { gen.ObjectShape_Polygon encode() => _objectShapePolygonCodec.encode(this); }
extension _ObjectShapePolygonDecode on gen.ObjectShape_Polygon { PolygonObjectShape decode() => _objectShapePolygonCodec.decode(this); }

final _objectShapePolygonCodec = _codec<PolygonObjectShape, gen.ObjectShape_Polygon>(
  decoder: (v) => .new(sides: v.sides),
  encoder: (v) => .new(sides: v.sides),
);

extension _ObjectShapeEllipseEncode on EllipseObjectShape { gen.ObjectShape_Ellipse encode() => _objectShapeEllipseCodec.encode(this); }
extension _ObjectShapeEllipseDecode on gen.ObjectShape_Ellipse { EllipseObjectShape decode() => _objectShapeEllipseCodec.decode(this); }

final _objectShapeEllipseCodec = _codec<EllipseObjectShape, gen.ObjectShape_Ellipse>(
  decoder: (v) => .new(),
  encoder: (v) => .new(),
);

extension _ObjectShapeEncode on ObjectShape { gen.ObjectShape encode() => _objectShapeCodec.encode(this); }
extension _ObjectShapeDecode on gen.ObjectShape { ObjectShape decode() => _objectShapeCodec.decode(this); }

final _objectShapeCodec = _codec<ObjectShape, gen.ObjectShape>(
  decoder: (v) => switch(v.whichValue()) {
    .rectangle => v.rectangle.decode(),
    .polygon => v.polygon.decode(),
    .ellipse => v.ellipse.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    RectangleObjectShape v => .new(rectangle: v.encode()),
    PolygonObjectShape v => .new(polygon: v.encode()),
    EllipseObjectShape v => .new(ellipse: v.encode()),
  },
);

// ---------------------------------------------------------------------------------------------------------------------
// Modifiers
// ---------------------------------------------------------------------------------------------------------------------

extension _ModifierListEncode on List<Modifier> { List<gen.Modifier> encode() => map((v) => v.encode()).toList(); }
extension _ModifierListDecode on List<gen.Modifier> { List<Modifier> decode() => map((v) => v.decode()).toList(); }

extension _ModifierEncode on Modifier { gen.Modifier encode() => _modifierCodec.encode(this); }
extension _ModifierDecode on gen.Modifier { Modifier decode() => _modifierCodec.decode(this); }

final _modifierCodec = _codec<Modifier, gen.Modifier>(
  decoder: (v) => switch(v.whichValue()) {
    .fillet => _filletModifierCodec.decode(v.fillet),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    FilletModifier v => .new(fillet: _filletModifierCodec.encode(v)),
  },
);

final _filletModifierCodec = _codec<FilletModifier, gen.FilletModifier>(
  decoder: (v) => .new(
    radius: _opt(v.hasRadius, () => v.radius.decode()),
    corners: .fromEntries(_map(v.corners, (e) => .new(e.index, e.radius.decode()))),
  ),
  encoder: (v) => .new(
    radius: v.radius?.encode(),
    corners: _map(v.corners.entries, (e) => .new(index: e.key, radius: e.value.encode())),
  ),
);


// ---------------------------------------------------------------------------------------------------------------------
// Deltas/changes
// ---------------------------------------------------------------------------------------------------------------------

extension _ProgramDeltaEncode on ProgramDelta { gen.ProgramDelta encode() => programDeltaCodec.encode(this); }
extension _ProgramDeltaDecode on gen.ProgramDelta { ProgramDelta decode() => programDeltaCodec.decode(this); }

final programDeltaCodec = _codec<ProgramDelta, gen.ProgramDelta>(
  decoder: (v) => .new(
    v.changes.map((e) => e.decode()).toList(),
  ),
  encoder: (v) => .new(
    changes: v.changes.map((e) => e.encode()).toList(),
  ),
);

extension _ProgramChangeEncode on ProgramChange { gen.ProgramChange encode() => _programChangeCodec.encode(this); }
extension _ProgramChangeDecode on gen.ProgramChange { ProgramChange decode() => _programChangeCodec.decode(this); }

final _programChangeCodec = _codec<ProgramChange, gen.ProgramChange>(
  decoder: (v) => switch(v.whichValue()) {
    .statement => v.statement.decode(),
    .style => v.style.decode(),
    .zOrder => v.zOrder.decode(),
    .empty => .empty(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    StatementChange v => .new(statement: v.encode()),
    StyleChange v => .new(style: v.encode()),
    ZOrderChange v => .new(zOrder: v.encode()),
    EmptyChange() => .new(empty: true),
  },
);

extension _ZOrderChangeEncode on ZOrderChange { gen.ZOrderChange encode() => _zOrderChangeCodec.encode(this); }
extension _ZOrderChangeDecode on gen.ZOrderChange { ZOrderChange decode() => _zOrderChangeCodec.decode(this); }

final _zOrderChangeCodec = _codec<ZOrderChange, gen.ZOrderChange>(
  decoder: (v) => .new(
    v.ref.decode(),
    before: _opt(v.hasBefore, () => v.before.decode()),
    after: _opt(v.hasAfter, () => v.after.decode()),
  ),
  encoder: (v) => .new(
    ref: v.ref.encode(),
    before: v.before?.encode(),
    after: v.after?.encode(),
  ),
);

extension _StyleChangeEncode on StyleChange { gen.StyleChange encode() => _styleChangeCodec.encode(this); }
extension _StyleChangeDecode on gen.StyleChange { StyleChange decode() => _styleChangeCodec.decode(this); }

final _styleChangeCodec = _codec<StyleChange, gen.StyleChange>(
  decoder: (v) => .new(
    v.ref.decode(),
    before: _opt(v.hasBefore, () => v.before.decode()),
    after: _opt(v.hasAfter, () => v.after.decode()),
  ),
  encoder: (v) => .new(
    ref: v.ref.encode(),
    before: v.before?.encode(),
    after: v.after?.encode(),
  ),
);

extension _StatementChangeEncode on StatementChange { gen.StatementChange encode() => _statementChangeCodec.encode(this); }
extension _StatementChangeDecode on gen.StatementChange { StatementChange decode() => _statementChangeCodec.decode(this); }

final _statementChangeCodec = _codec<StatementChange, gen.StatementChange>(
  decoder: (v) => .new(
    anchor: v.anchor.decode(),
    removed: v.removed.map((e) => e.decode()).toList(),
    inserted: v.inserted.map((e) => e.decode()).toList(),
  ),
  encoder: (v) => .new(
    anchor: v.anchor.encode(),
    removed: v.removed.map((e) => e.encode()).toList(),
    inserted: v.inserted.map((e) => e.encode()).toList(),
  ),
);

extension _ProgramAnchorEncode on ProgramAnchor { gen.ProgramAnchor encode() => _programAnchorCodec.encode(this); }
extension _ProgramAnchorDecode on gen.ProgramAnchor { ProgramAnchor decode() => _programAnchorCodec.decode(this); }

final _programAnchorCodec = _codec<ProgramAnchor, gen.ProgramAnchor>(
  decoder: (v) => switch(v.whichValue()) {
    .start => .start,
    .end => .end,
    .at => .at(v.at.decode()),
    .after => .after(v.after.decode()),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    StartAnchor() => .new(start: true),
    EndAnchor() => .new(end: true),
    AtAnchor a => .new(at: a.id.encode()),
    AfterAnchor a => .new(after: a.id.encode()),
  },
);

// ---------------------------------------------------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------------------------------------------------

extension _LayoutDimensionTypeEncode on LayoutDimensionType { gen.LayoutDimension_Type encode() => _layoutDimensionTypeCodec.encode(this); }
extension _LayoutDimensionTypeDecode on gen.LayoutDimension_Type { LayoutDimensionType decode() => _layoutDimensionTypeCodec.decode(this); }

final _layoutDimensionTypeCodec = _codec<LayoutDimensionType, gen.LayoutDimension_Type>(
  decoder: (v) => switch(v) {
    .LAYOUT_DIMENSION_TYPE_FIXED => .fixed,
    .LAYOUT_DIMENSION_TYPE_EXPAND => .expand,
    .LAYOUT_DIMENSION_TYPE_CONTAIN => .contain,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .fixed => .LAYOUT_DIMENSION_TYPE_FIXED,
    .expand => .LAYOUT_DIMENSION_TYPE_EXPAND,
    .contain => .LAYOUT_DIMENSION_TYPE_CONTAIN,
  },
);

extension _LayoutDimensionRangeEncode on LayoutRange { gen.LayoutDimension_Range encode() => _layoutDimensionRangeCodec.encode(this); }
extension _LayoutDimensionRangeDecode on gen.LayoutDimension_Range { LayoutRange decode() => _layoutDimensionRangeCodec.decode(this); }

final _layoutDimensionRangeCodec = _codec<LayoutRange, gen.LayoutDimension_Range>(
  decoder: (v) => .new(
    min: v.min,
    max: v.max,
  ),
  encoder: (v) => .new(
    min: v.min,
    max: v.max,
  ),
);

extension _LayoutDimensionEncode on LayoutDimension { gen.LayoutDimension encode() => _layoutDimensionCodec.encode(this); }
extension _LayoutDimensionDecode on gen.LayoutDimension { LayoutDimension decode() => _layoutDimensionCodec.decode(this); }

final _layoutDimensionCodec = _codec<LayoutDimension, gen.LayoutDimension>(
  decoder: (v) => .new(
    _opt(v.hasValue, () => v.value),
    v.type.decode(),
    v.range.decode(),
  ),
  encoder: (v) => .new(
    value: v.value,
    type: v.type.encode(),
    range: v.range.encode(),
  ),
);

extension _LayoutSizeEncode on LayoutSize { gen.LayoutSize encode() => _layoutSizeCodec.encode(this); }
extension _LayoutSizeDecode on gen.LayoutSize { LayoutSize decode() => _layoutSizeCodec.decode(this); }

final _layoutSizeCodec = _codec<LayoutSize, gen.LayoutSize>(
  decoder: (v) => .new(
    v.width.decode(),
    v.height.decode(),
  ),
  encoder: (v) => .new(
    width: v.width.encode(),
    height: v.height.encode(),
  ),
);

extension _LayoutAlignEncode on LayoutAlign { gen.Layout_Align encode() => _layoutAlignCodec.encode(this); }
extension _LayoutAlignDecode on gen.Layout_Align { LayoutAlign decode() => _layoutAlignCodec.decode(this); }

final _layoutAlignCodec = _codec<LayoutAlign, gen.Layout_Align>(
  decoder: (v) => switch (v) {
    .LAYOUT_ALIGN_START => .start,
    .LAYOUT_ALIGN_CENTER => .center,
    .LAYOUT_ALIGN_END => .end,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch (v) {
    .start => .LAYOUT_ALIGN_START,
    .center => .LAYOUT_ALIGN_CENTER,
    .end => .LAYOUT_ALIGN_END,
  },
);

extension _LayoutJustifyEncode on LayoutJustify { gen.Layout_Justify encode() => _layoutJustifyCodec.encode(this); }
extension _LayoutJustifyDecode on gen.Layout_Justify { LayoutJustify decode() => _layoutJustifyCodec.decode(this); }

final _layoutJustifyCodec = _codec<LayoutJustify, gen.Layout_Justify>(
  decoder: (v) => switch(v) {
    .LAYOUT_JUSTIFY_START => .start,
    .LAYOUT_JUSTIFY_CENTER => .center,
    .LAYOUT_JUSTIFY_END => .end,
    .LAYOUT_JUSTIFY_SPACE_BETWEEN => .spaceBetween,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .start => .LAYOUT_JUSTIFY_START,
    .center => .LAYOUT_JUSTIFY_CENTER,
    .end => .LAYOUT_JUSTIFY_END,
    .spaceBetween => .LAYOUT_JUSTIFY_SPACE_BETWEEN,
  },
);

extension _LayoutInsetsEncode on LayoutInsets { gen.Layout_Insets encode() => _layoutInsetsCodec.encode(this); }
extension _LayoutInsetsDecode on gen.Layout_Insets { LayoutInsets decode() => _layoutInsetsCodec.decode(this); }

final _layoutInsetsCodec = _codec<LayoutInsets, gen.Layout_Insets>(
  decoder: (v) => .new(v.left, v.top, v.right, v.bottom),
  encoder: (v) => .new(left: v.left, top: v.top, right: v.right, bottom: v.bottom),
);

extension _LayoutStackEncode on StackLayout { gen.Layout_Stack encode() => _layoutStackCodec.encode(this); }
extension _LayoutStackDecode on gen.Layout_Stack { StackLayout decode() => _layoutStackCodec.decode(this); }

final _layoutStackCodec = _codec<StackLayout, gen.Layout_Stack>(
  decoder: (v) => .new(
    alignHorizontal: _opt(v.hasAlignHorizontal, () => v.alignHorizontal.decode()),
    alignVertical: _opt(v.hasAlignVertical, () => v.alignVertical.decode()),
    padding: v.padding.decode(),
  ),
  encoder: (v) => .new(
    alignHorizontal: v.alignHorizontal?.encode(),
    alignVertical: v.alignVertical?.encode(),
    padding: v.padding.encode(),
  ),
);

extension _FlexDirectionEncode on FlexDirection { gen.Layout_Flex_Direction encode() => _flexDirectionCodec.encode(this); }
extension _FlexDirectionDecode on gen.Layout_Flex_Direction { FlexDirection decode() => _flexDirectionCodec.decode(this); }

final _flexDirectionCodec = _codec<FlexDirection, gen.Layout_Flex_Direction>(
  decoder: (v) => switch(v) {
    .LAYOUT_FLEX_DIRECTION_ROW => .row,
    .LAYOUT_FLEX_DIRECTION_COLUMN => .column,
    _ => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    .row => .LAYOUT_FLEX_DIRECTION_ROW,
    .column => .LAYOUT_FLEX_DIRECTION_COLUMN,
  },
);

extension _LayoutFlexEncode on FlexLayout { gen.Layout_Flex encode() => _layoutFlexCodec.encode(this); }
extension _LayoutFlexDecode on gen.Layout_Flex { FlexLayout decode() => _layoutFlexCodec.decode(this); }

final _layoutFlexCodec = _codec<FlexLayout, gen.Layout_Flex>(
  decoder: (v) => .new(
    direction: v.direction.decode(),
    justify: v.justify.decode(),
    crossAlign: v.crossAlign.decode(),
    gap: v.gap,
    padding: v.padding.decode(),
  ),
  encoder: (v) => .new(
    direction: v.direction.encode(),
    justify: v.justify.encode(),
    crossAlign: v.crossAlign.encode(),
    gap: v.gap,
    padding: v.padding.encode(),
  ),
);

extension _LayoutEncode on Layout { gen.Layout encode() => _layoutCodec.encode(this); }
extension _LayoutDecode on gen.Layout { Layout decode() => _layoutCodec.decode(this); }

final _layoutCodec = _codec<Layout, gen.Layout>(
  decoder: (v) => switch(v.whichValue()) {
    .stack => v.stack.decode(),
    .flex => v.flex.decode(),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    StackLayout v => .new(stack: v.encode()),
    FlexLayout v => .new(flex: v.encode()),
  },
);

// ---------------------------------------------------------------------------------------------------------------------
// Generator nodes
// ---------------------------------------------------------------------------------------------------------------------

extension _GeneratorEncode on Generator { gen.Generator encode() => _generatorCodec.encode(this); }
extension _GeneratorDecode on gen.Generator { Generator decode() => _generatorCodec.decode(this); }

final _generatorCodec = _codec<Generator, gen.Generator>(
  decoder: (v) => .new(
    nodes: _map(v.nodes, (e) => e.decode()),
    connections: _map(v.connections, (e) => e.decode()),
    positions: .fromEntries(_map(v.positions, (e) => MapEntry(e.node.decode(), e.position.decode()))),
    fixed: _map(v.fixed, (e) => e.decode()).toSet(),
  ),
  encoder: (v) => .new(
    nodes: _map(v.nodes, (e) => e.encode()),
    connections: _map(v.connections, (e) => e.encode()),
    positions: _map(v.positions.entries, (e) => .new(node: e.key.encode(), position: e.value.encode())),
    fixed: _map(v.fixed, (e) => e.encode()).toList(),
  ),
);

extension _NodeIdEncode on bp.NodeId { gen.NodeId encode() => _nodeIdCodec.encode(this); }
extension _NodeIdDecode on gen.NodeId { bp.NodeId decode() => _nodeIdCodec.decode(this); }

final _nodeIdCodec = _codec<bp.NodeId, gen.NodeId>(
  decoder: (v) => .new(v.value),
  encoder: (v) => .new(value: v.value),
);

extension _SocketRefEncode on bp.SocketRef { gen.SocketRef encode() => _socketRefCodec.encode(this); }
extension _SocketRefDecode on gen.SocketRef { bp.SocketRef decode() => _socketRefCodec.decode(this); }

final _socketRefCodec = _codec<bp.SocketRef, gen.SocketRef>(
  decoder: (v) => .new(v.node.decode(), v.index),
  encoder: (v) => .new(node: v.node.encode(), index: v.index),
);

extension _ConnectionEncode on bp.Connection { gen.Connection encode() => _connectionCodec.encode(this); }
extension _ConnectionDecode on gen.Connection { bp.Connection decode() => _connectionCodec.decode(this); }

final _connectionCodec = _codec<bp.Connection, gen.Connection>(
  decoder: (v) => .new(
    v.output.decode(),
    v.input.decode(),
  ),
  encoder: (v) => .new(
    output: v.output.encode(),
    input: v.input.encode(),
  ),
);

extension _NodeEncode on bp.Node { gen.Node encode() => _nodeCodec.encode(this); }
extension _NodeDecode on gen.Node { bp.Node decode() => _nodeCodec.decode(this); }

final _nodeCodec = _codec<bp.Node, gen.Node>(
  decoder: (v) => switch(v.whichKind()) {
    .array => _arrayNodeCodec.decode(v),
    .randomVector => _randomVectorNodeCodec.decode(v),
    .fillet => _filletNodeCodec.decode(v),
    .generatorInput => _generatorInputNodeCodec.decode(v),
    .generatorOutput => _generatorOutputNodeCodec.decode(v),
    .polar => _polarNodeCodec.decode(v),
    .pi => _piNodeCodec.decode(v),
    .divide => _divideNodeCodec.decode(v),
    .vertices => _verticesNodeCodec.decode(v),
    .connectVertices => _connectVerticesNodeCodec.decode(v),
    .face => _faceNodeCodec.decode(v),
    .number => _numberNodeCodec.decode(v),
    .vector => _vectorNodeCodec.decode(v),
    .index_ => _indexNodeCodec.decode(v),
    .scaleVector => _scaleVectorNodeCodec.decode(v),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    ArrayNode v => _arrayNodeCodec.encode(v),
    RandomVectorNode v => _randomVectorNodeCodec.encode(v),
    FilletNode v => _filletNodeCodec.encode(v),
    GeneratorInputNode v => _generatorInputNodeCodec.encode(v),
    GeneratorOutputNode v => _generatorOutputNodeCodec.encode(v),
    PolarNode v => _polarNodeCodec.encode(v),
    PiNode v => _piNodeCodec.encode(v),
    DivideNode v => _divideNodeCodec.encode(v),
    VerticesNode v => _verticesNodeCodec.encode(v),
    ConnectVerticesNode v => _connectVerticesNodeCodec.encode(v),
    FaceNode v => _faceNodeCodec.encode(v),
    NumberNode v => _numberNodeCodec.encode(v),
    VectorNode v => _vectorNodeCodec.encode(v),
    IndexNode v => _indexNodeCodec.encode(v),
    ScaleVectorNode v => _scaleVectorNodeCodec.encode(v),
    _ => throw ArgumentError(),
  },
);

final _arrayNodeCodec = _codec<ArrayNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    count: _opt(v.array.hasCount, () => v.array.count.decode()),
    offset: _opt(v.array.hasOffset, () => v.array.offset.decode()),
    slice: _opt(v.array.hasSlice, () => .decode(v.array.slice)),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    array: .new(
      count: v.i.count.inlineValue.encode(),
      offset: v.i.offset.inlineValue.encode(),
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _randomVectorNodeCodec = _codec<RandomVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    seed: _opt(v.randomVector.hasSeed, () => v.randomVector.seed),
    min: _opt(v.randomVector.hasMin, () => v.randomVector.min.decode()),
    max: _opt(v.randomVector.hasMax, () => v.randomVector.max.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    randomVector: .new(
      seed: v.i.seed.inlineValue,
      min: v.i.min.inlineValue.encode(),
      max: v.i.max.inlineValue.encode(),
    ),
  ),
);

final _filletNodeCodec = _codec<FilletNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    radius: _opt(v.fillet.hasRadius, () => v.fillet.radius.decode()),
    slice: _opt(v.fillet.hasSlice, () => .decode(v.fillet.slice)),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    fillet: .new(
      radius: v.i.radius.inlineValue.encode(),
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _generatorInputNodeCodec = _codec<GeneratorInputNode, gen.Node>(
  decoder: (v) => .new(id: v.id.decode()),
  encoder: (v) => .new(id: v.id.encode(), generatorInput: .new()),
);

final _generatorOutputNodeCodec = _codec<GeneratorOutputNode, gen.Node>(
  decoder: (v) => .new(id: v.id.decode()),
  encoder: (v) => .new(id: v.id.encode(), generatorOutput: .new()),
);

final _polarNodeCodec = _codec<PolarNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    angle: _opt(v.polar.hasAngle, () => v.polar.angle),
    radius: _opt(v.polar.hasRadius, () => v.polar.radius),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    polar: .new(
      angle: v.i.angle.inlineValue,
      radius: v.i.radius.inlineValue,
    ),
  ),
);

final _piNodeCodec = _codec<PiNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    pi: .new(),
  ),
);

final _divideNodeCodec = _codec<DivideNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    denominator: _opt(v.divide.hasDenominator, () => v.divide.denominator),
    numerator: _opt(v.divide.hasNumerator, () => v.divide.numerator),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    divide: .new(
      denominator: v.i.denominator.inlineValue,
      numerator: v.i.numerator.inlineValue,
    ),
  ),
);

final _verticesNodeCodec = _codec<VerticesNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    count: _opt(v.vertices.hasCount, () => v.vertices.count),
    position: _opt(v.vertices.hasPosition, () => v.vertices.position.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vertices: .new(
      count: v.i.count.inlineValue,
      position: v.i.position.inlineValue.encode(),
    ),
  ),
);

final _connectVerticesNodeCodec = _codec<ConnectVerticesNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: _opt(v.connectVertices.hasSlice, () => .decode(v.connectVertices.slice)),
    closed: _opt(v.connectVertices.hasClosed, () => v.connectVertices.closed),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    connectVertices: .new(
      slice: v.i.slice.inlineValue.encode(),
      closed: v.i.closed.inlineValue,
    ),
  ),
);

final _faceNodeCodec = _codec<FaceNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    slice: _opt(v.face.hasSlice, () => .decode(v.face.slice)),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    face: .new(
      slice: v.i.slice.inlineValue.encode(),
    ),
  ),
);

final _numberNodeCodec = _codec<NumberNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: _opt(v.number.hasValue, () => v.number.value),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    number: .new(
      value: v.i.value.inlineValue,
    ),
  ),
);

final _vectorNodeCodec = _codec<VectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    value: _opt(v.vector.hasValue, () => v.vector.value.decode()),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    vector: .new(
      value: v.i.value.inlineValue.encode(),
    ),
  ),
);

final _indexNodeCodec = _codec<IndexNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    index: .new(),
  ),
);

final _scaleVectorNodeCodec = _codec<ScaleVectorNode, gen.Node>(
  decoder: (v) => .new(
    id: v.id.decode(),
    vector: _opt(v.scaleVector.hasVector, () => v.scaleVector.vector.decode()),
    factor: _opt(v.scaleVector.hasFactor, () => v.scaleVector.factor),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    scaleVector: .new(
      vector: v.i.vector.inlineValue.encode(),
      factor: v.i.factor.inlineValue,
    ),
  ),
);

// ---------------------------------------------------------------------------------------------------------------------
// Other types
// ---------------------------------------------------------------------------------------------------------------------

extension _Mat4Encode on Mat4 { gen.Mat4 encode() => _mat4Codec.encode(this); }
extension _Mat4Decode on gen.Mat4 { Mat4 decode() => _mat4Codec.decode(this); }

final _mat4Codec = _codec<Mat4, gen.Mat4>(
  decoder: (v) => .from(v.m00, v.m01, v.m02, v.m03, v.m10, v.m11, v.m12, v.m13, v.m20, v.m21, v.m22, v.m23, v.m30, v.m31, v.m32, v.m33),
  encoder: (v) => .new(m00: v.m00, m01: v.m01, m02: v.m02, m03: v.m03, m10: v.m10, m11: v.m11, m12: v.m12, m13: v.m13, m20: v.m20, m21: v.m21, m22: v.m22, m23: v.m23, m30: v.m30, m31: v.m31, m32: v.m32, m33: v.m33),
);

extension _Vec2Encode on Vec2 { gen.Vec2 encode() => _vec2Codec.encode(this); }
extension _Vec2Decode on gen.Vec2 { Vec2 decode() => _vec2Codec.decode(this); }

final _vec2Codec = _codec<Vec2, gen.Vec2>(
  decoder: (v) => .new(v.x, v.y),
  encoder: (v) => .new(x: v.x, y: v.y),
);

extension _Size2Encode on Size2 { gen.Size2 encode() => _size2Codec.encode(this); }
extension _Size2Decode on gen.Size2 { Size2 decode() => _size2Codec.decode(this); }

final _size2Codec = _codec<Size2, gen.Size2>(
  decoder: (v) => .new(v.width, v.height),
  encoder: (v) => .new(width: v.width, height: v.height),
);

extension _CornerRadiusEncode on CornerRadius { gen.CornerRadius encode() => _cornerRadiusCodec.encode(this); }
extension _CornerRadiusDecode on gen.CornerRadius { CornerRadius decode() => _cornerRadiusCodec.decode(this); }

final _cornerRadiusCodec = _codec<CornerRadius, gen.CornerRadius>(
  decoder: (v) => .new(v.x, v.y),
  encoder: (v) => .new(x: v.x, y: v.y),
);

extension _ColorDataEncode on ColorData { gen.ColorData encode() => _colorDataCodec.encode(this); }
extension _ColorDataDecode on gen.ColorData { ColorData decode() => _colorDataCodec.decode(this); }

final _colorDataCodec = _codec<ColorData, gen.ColorData>(
  decoder: (v) => switch(v.whichValue()) {
    .hsv => ColorData.hsv(h: v.hsv.h, s: v.hsv.s, v: v.hsv.v, alpha: v.alpha),
    .notSet => throw ArgumentError(),
  },
  encoder: (v) => switch(v) {
    HsvColorData v => .new(hsv: .new(h: v.h, s: v.s, v: v.v), alpha: v.alpha),
  }
);