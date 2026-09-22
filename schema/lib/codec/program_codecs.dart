// // ignore_for_file: unused_element

// import 'dart:convert';

// import 'package:schema/program.dart' as gen;
// import 'package:shared/shared.dart';
// import 'package:color/color.dart';
// import 'package:kernel/kernel.dart';
// import 'package:program/program.dart';
// import 'package:geometry/geometry.dart';

// // ---------------------------------------------------------------------------------------------------------------------
// // Setup
// // ---------------------------------------------------------------------------------------------------------------------

// final class _FunctionalConverter<S, T> extends Converter<S, T> {
//   new(this._convert);
//   final T Function(S input) _convert;

//   @override
//   T convert(S input) => _convert(input);
// }

// final class _FunctionalCodec<S, T> extends Codec<S, T> {
//   new({required this.decoder, required this.encoder});

//   _FunctionalCodec.from({required S Function(T input) decoder, required T Function(S input) encoder})
//     : this(decoder: .new(decoder), encoder: .new(encoder));

//   @override
//   final _FunctionalConverter<T, S> decoder;

//   @override
//   final _FunctionalConverter<S, T> encoder;
// }

// _FunctionalCodec<S, T> _codec<S, T>({
//   required S Function(T input) decoder,
//   required T Function(S input) encoder,
// }) => .from(decoder: decoder, encoder: encoder);

// T? _opt<T>(bool Function() hasValue, T Function() value) => hasValue() ? value() : null;

// List<R> _map<T, R>(Iterable<T> list, R Function(T) mapper) => list.map(mapper).toList();

// // dart format off

// // ---------------------------------------------------------------------------------------------------------------------
// // Program
// // ---------------------------------------------------------------------------------------------------------------------

// final programCodec = _codec<Program, gen.Program>(
//   decoder: (v) => .new(
//     _map(v.statements, (v) => v.decode()),
//     styles: v.style.decode(),
//     zOrders: v.zOrder.decode(),
//   ),
//   encoder: (v) => .new(
//     statements: _map(v.statements, (v) => v.encode()),
//     style: v.styles.encode(),
//     zOrder: v.zOrders.encode(),
//   ),
// );

// final programSliceCodec = _codec<ProgramSlice, gen.ProgramSlice>(
//   decoder: (v) => .new(
//     statements: _map(v.statements, (v) => v.decode()),
//     // styles: v.style.decode(),
//     // zOrders: v.zOrder.decode(),
//   ),
//   encoder: (v) => .new(
//     statements: _map(v.statements, (v) => v.encode()),
//     // style: v.styles.encode(),
//     // zOrder: v.zOrders.encode(),
//   ),
// );


// extension _U64Encode on U64 { gen.U64 encode() => _u64Codec.encode(this); }
// extension _U64Decode on gen.U64 { U64 decode() => _u64Codec.decode(this); }

// final _u64Codec = _codec<U64, gen.U64>(
//   decoder: (v) => .of(v.hi, v.lo),
//   encoder: (v) => .new(hi: v.hi, lo: v.lo),
// );

// extension _StatementIdEncode on StatementId { gen.StatementId encode() => _statementIdCodec.encode(this); }
// extension _StatementIdDecode on gen.StatementId { StatementId decode() => _statementIdCodec.decode(this); }

// final _statementIdCodec = _codec<StatementId, gen.StatementId>(
//   decoder: (v) => .raw(v.value.decode()),
//   encoder: (v) => .new(value: v.value.encode()),
// );

// extension _CellKindEncode on CellKind { gen.CellKind encode() => _cellKindCodec.encode(this); }
// extension _CellKindDecode on gen.CellKind { CellKind decode() => _cellKindCodec.decode(this); }

// final _cellKindCodec = _codec<CellKind, gen.CellKind>(
//   decoder: (v) => switch(v) {
//     .CELL_KIND_FRAME => .frame,
//     .CELL_KIND_VERTEX => .vertex,
//     .CELL_KIND_EDGE => .edge,
//     .CELL_KIND_FACE => .face,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     .frame => .CELL_KIND_FRAME,
//     .vertex => .CELL_KIND_VERTEX,
//     .edge => .CELL_KIND_EDGE,
//     .face => .CELL_KIND_FACE,
//   },
// );

// extension _CellRefEncode on CellRef { gen.CellRef encode() => _cellRefCodec.encode(this); }

// final _refKindMap = <gen.CellKind, Type>{
//   .CELL_KIND_FRAME: FrameHandle,
//   .CELL_KIND_VERTEX: VertexHandle,
//   .CELL_KIND_EDGE: EdgeHandle,
//   .CELL_KIND_FACE: FaceHandle,
// };

// void _checkRefKind<H extends CellHandle>(gen.CellKind kind) {
//   if (H != CellHandle && _refKindMap[kind] != H) {
//     throw ArgumentError('CellRef kind $kind does not match expected type $H');
//   }
// }

// extension _CellRefDecode on gen.CellRef {
//   CellRef<H> decode<H extends CellHandle>() {
//     _checkRefKind<H>(kind);
//     return .make(namespace: namespace.decode(), op: tag, sub: sub, kind: kind.decode());
//   }
// }

// final _cellRefCodec = _codec<CellRef, gen.CellRef>(
//   decoder: (v) => .make(namespace: v.namespace.decode(), op: v.tag, sub: v.sub, kind: v.kind.decode()),
//   encoder: (v) => .new(namespace: v.namespace.encode(), tag: v.op, sub: v.sub, kind: v.kind.encode()),
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Z-order
// // ---------------------------------------------------------------------------------------------------------------------

// extension _ZOrderTableEncode on ZOrderTable { gen.ZOrderTable encode() => _zOrderTableCodec.encode(this); }
// extension _ZOrderTableDecode on gen.ZOrderTable { ZOrderTable decode() => _zOrderTableCodec.decode(this); }

// final _zOrderTableCodec = _codec<ZOrderTable, gen.ZOrderTable>(
//   decoder: (v) => .new({
//     for (final e in v.entries) e.ref.decode(): e.value.decode(),
//   }),
//   encoder: (v) => .new(entries: [
//     for (final e in v.entries) .new(ref: e.key.encode(), value: e.value.encode()),
//   ])
// );

// extension _ZAnchorEncode on ZAnchor { gen.ZAnchor encode() => _zAnchorCodec.encode(this); }
// extension _ZAnchorDecode on gen.ZAnchor { ZAnchor decode() => _zAnchorCodec.decode(this); }

// final _zAnchorCodec = _codec<ZAnchor, gen.ZAnchor>(
//   decoder: (v) => switch(v.whichValue()) {
//     .top => ZAnchor.top(),
//     .bottom => ZAnchor.bottom(),
//     .above => ZAnchor.above(v.above.decode()),
//     .below => ZAnchor.below(v.below.decode()),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     ZTop() => .new(top: true),
//     ZBottom() => .new(bottom: true),
//     ZAbove v => .new(above: v.sibling.encode()),
//     ZBelow v => .new(below: v.sibling.encode()),
//   },
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Styles
// // ---------------------------------------------------------------------------------------------------------------------

// extension _StyleTableEncode on StyleTable { gen.StyleTable encode() => _styleTableCodec.encode(this); }
// extension _StyleTableDecode on gen.StyleTable { StyleTable decode() => _styleTableCodec.decode(this); }

// final _styleTableCodec = _codec<StyleTable, gen.StyleTable>(
//   decoder: (v) => .new({
//     for (final e in v.entries) e.ref.decode(): e.value.decode(),
//   }),
//   encoder: (v) => .new(entries: [
//     for (final e in v.entries) .new(ref: e.key.encode(), value: e.value.encode()),
//   ])
// );

// extension _CellStylePartialEncode on CellStylePartial { gen.CellStyle_Partial encode() => _cellStylePartialCodec.encode(this); }
// extension _CellStylePartialDecode on gen.CellStyle_Partial { CellStylePartial decode() => _cellStylePartialCodec.decode(this); }

// final _cellStylePartialCodec = _codec<CellStylePartial, gen.CellStyle_Partial>(
//   decoder: (v) => switch(v.whichValue()) {
//     .vertex => v.vertex.decode(),
//     .edge => v.edge.decode(),
//     .face => v.face.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     VertexStylePartial v => .new(vertex: v.encode()),
//     EdgeStylePartial v => .new(edge: v.encode()),
//     FaceStylePartial v => .new(face: v.encode()),
//   },
// );

// extension _CellStyleEncode on CellStyle { gen.CellStyle encode() => _cellStyleCodec.encode(this); }
// extension _CellStyleDecode on gen.CellStyle { CellStyle decode() => _cellStyleCodec.decode(this); }

// final _cellStyleCodec = _codec<CellStyle, gen.CellStyle>(
//   decoder: (v) => switch(v.whichValue()) {
//     .vertex => v.vertex.decode(),
//     .edge => v.edge.decode(),
//     .face => v.face.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     VertexStyle v => .new(vertex: v.encode()),
//     EdgeStyle v => .new(edge: v.encode()),
//     FaceStyle v => .new(face: v.encode()),
//   },
// );

// extension _VertexStyleEncode on VertexStyle { gen.VertexStyle encode() => _vertexStyleCodec.encode(this); }
// extension _VertexStyleDecode on gen.VertexStyle { VertexStyle decode() => _vertexStyleCodec.decode(this); }

// final _vertexStyleCodec = _codec<VertexStyle, gen.VertexStyle>(
//   decoder: (v) => .new(
//     color: v.color.decode(),
//     radius: v.radius,
//   ),
//   encoder: (v) => .new(
//     color: v.color.encode(),
//     radius: v.radius,
//   ),
// );

// extension _EdgeStyleEncode on EdgeStyle { gen.EdgeStyle encode() => _edgeStyleCodec.encode(this); }
// extension _EdgeStyleDecode on gen.EdgeStyle { EdgeStyle decode() => _edgeStyleCodec.decode(this); }

// final _edgeStyleCodec = _codec<EdgeStyle, gen.EdgeStyle>(
//   decoder: (v) => .new(
//     color: v.color.decode(),
//     width: v.width,
//   ),
//   encoder: (v) => .new(
//     color: v.color.encode(),
//     width: v.width,
//   ),
// );

// extension _FaceStyleEncode on FaceStyle { gen.FaceStyle encode() => _faceStyleCodec.encode(this); }
// extension _FaceStyleDecode on gen.FaceStyle { FaceStyle decode() => _faceStyleCodec.decode(this); }

// final _faceStyleCodec = _codec<FaceStyle, gen.FaceStyle>(
//   decoder: (v) => .new(
//     color: v.color.decode(),
//   ),
//   encoder: (v) => .new(
//     color: v.color.encode(),
//   ),
// );

// extension _VertexStylePartialEncode on VertexStylePartial { gen.VertexStyle_Partial encode() => _vertexStylePartialCodec.encode(this); }
// extension _VertexStylePartialDecode on gen.VertexStyle_Partial { VertexStylePartial decode() => _vertexStylePartialCodec.decode(this); }

// final _vertexStylePartialCodec = _codec<VertexStylePartial, gen.VertexStyle_Partial>(
//   decoder: (v) => .new(
//     color: _opt(v.hasColor, () => v.color.decode()),
//     radius: _opt(v.hasRadius, () => v.radius),
//   ),
//   encoder: (v) => .new(
//     color: v.color?.encode(),
//     radius: v.radius,
//   ),
// );

// extension _EdgeStylePartialEncode on EdgeStylePartial { gen.EdgeStyle_Partial encode() => _edgeStylePartialCodec.encode(this); }
// extension _EdgeStylePartialDecode on gen.EdgeStyle_Partial { EdgeStylePartial decode() => _edgeStylePartialCodec.decode(this); }

// final _edgeStylePartialCodec = _codec<EdgeStylePartial, gen.EdgeStyle_Partial>(
//   decoder: (v) => .new(
//     color: _opt(v.hasColor, () => v.color.decode()),
//     width: _opt(v.hasWidth, () => v.width),
//   ),
//   encoder: (v) => .new(
//     color: v.color?.encode(),
//     width: v.width,
//   ),
// );

// extension _FaceStylePartialEncode on FaceStylePartial { gen.FaceStyle_Partial encode() => _faceStylePartialCodec.encode(this); }
// extension _FaceStylePartialDecode on gen.FaceStyle_Partial { FaceStylePartial decode() => _faceStylePartialCodec.decode(this); }

// final _faceStylePartialCodec = _codec<FaceStylePartial, gen.FaceStyle_Partial>(
//   decoder: (v) => .new(
//     color: _opt(v.hasColor, () => v.color.decode()),
//   ),
//   encoder: (v) => .new(
//     color: v.color?.encode(),
//   ),
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Selectors
// // ---------------------------------------------------------------------------------------------------------------------

// extension _CellSelectorEncode on CellSelector { gen.CellSelector encode() => _cellSelectorCodec.encode(this); }
// extension _CellSelectorDecode on gen.CellSelector {
//   CellSelector<H> decode<H extends CellHandle>() {
//     _checkRefKind<H>(ref.kind);
//     return _cellSelectorCodec.decode(this) as CellSelector<H>;
//   }
// }

// final _cellSelectorCodec = _codec<CellSelector, gen.CellSelector>(
//   decoder: (v) => .new(v.ref.decode()),
//   encoder: (v) => .new(ref: v.ref.encode())
// );

// extension _ProductsSelectorEncode on ProductsSelector { gen.ProductsSelector encode() => _productsSelectorCodec.encode(this); }
// extension _ProductsSelectorDecode on gen.ProductsSelector {
//   ProductsSelector<H> decode<H extends CellHandle>() {
//     if (H != CellHandle) {
//       if (!hasKind()) throw ArgumentError();
//       _checkRefKind(kind);
//     }
//     return _productsSelectorCodec.decode(this) as ProductsSelector<H>;
//   }
// }

// final _productsSelectorCodec = _codec<ProductsSelector, gen.ProductsSelector>(
//   decoder: (v) => .new(v.id.decode(), kind: _opt(v.hasKind, () => v.kind.decode())),
//   encoder: (v) => .new(id: v.id.encode(), kind: v.kind?.encode()),
// );

// extension _ChainSelectorEncode on ChainSelector { gen.ChainSelector encode() => _chainSelectorCodec.encode(this); }
// extension _ChainSelectorDecode on gen.ChainSelector { ChainSelector decode() => _chainSelectorCodec.decode(this); }

// final _chainSelectorCodec = _codec<ChainSelector, gen.ChainSelector>(
//   decoder: (v) => .new(_map(v.edges, (v) => v.decode<EdgeHandle>())),
//   encoder: (v) => .new(edges: _map(v.edges, (v) => v.encode())),
// );

// extension _DissolveSelectorEncode on DissolveSelector { gen.DissolveSelector encode() => _dissolveSelectorCodec.encode(this); }
// extension _DissolveSelectorDecode on gen.DissolveSelector { DissolveSelector decode() => _dissolveSelectorCodec.decode(this); }

// final _dissolveSelectorCodec = _codec<DissolveSelector, gen.DissolveSelector>(
//   decoder: (v) => .new(_map(v.refs, (v) => v.decode<CellHandle>()).toSet()),
//   encoder: (v) => .new(refs: _map(v.refs, (v) => v.encode())),
// );

// extension _FragmentSelectorEncode on FragmentSelector { gen.FragmentSelector encode() => _fragmentSelectorCodec.encode(this); }
// extension _FragmentSelectorDecode on gen.FragmentSelector { FragmentSelector decode() => _fragmentSelectorCodec.decode(this); }

// final _fragmentSelectorCodec = _codec<FragmentSelector, gen.FragmentSelector>(
//   decoder: (v) => .new(v.id.decode()),
//   encoder: (v) => .new(id: v.id.encode()),
// );

// extension _SelectorEncode on Selector { gen.Selector encode() => _selectorCodec.encode(this); }
// extension _SelectorDecode on gen.Selector { Selector decode() => _selectorCodec.decode(this); }

// final _selectorCodec = _codec<Selector, gen.Selector>(
//   decoder: (v) => switch(v.whichValue()) {
//     .cell => v.cell.decode(),
//     .products => v.products.decode(),
//     .chain => v.chain.decode(),
//     .dissolve => v.dissolve.decode(),
//     .fragment => v.fragment.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     CellSelector v => .new(cell: v.encode()),
//     ProductsSelector v => .new(products: v.encode()),
//     ChainSelector v => .new(chain: v.encode()),
//     DissolveSelector v => .new(dissolve: v.encode()),
//     FragmentSelector v => .new(fragment: v.encode()),
//     _ => throw ArgumentError(),
//   },
// );

// extension _SingleSelectorEncode<H extends CellHandle> on Selector<CellRef<H>> { gen.SingleSelector encode() => _singleSelectorCodec.encode(this); }
// extension _SingleSelectorDecode on gen.SingleSelector { 
//   Selector<CellRef<H>> decode<H extends CellHandle>() {
//     switch(whichValue()) {
//       case .cell: return cell.decode<H>();
//       case .notSet: throw ArgumentError();
//     }
//   }
// }

// final _singleSelectorCodec = _codec<Selector, gen.SingleSelector>(
//   decoder: (v) => switch(v.whichValue()) {
//     .cell => v.cell.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     CellSelector v => .new(cell: v.encode()),
//     _ => throw ArgumentError('Selector is not a single selector'),
//   },
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Statements
// // ---------------------------------------------------------------------------------------------------------------------

// extension _StatementEncode on Statement { gen.Statement encode() => _statementCodec.encode(this); }
// extension _StatementDecode on gen.Statement { Statement decode() => _statementCodec.decode(this); }

// final _statementCodec = _codec<Statement, gen.Statement>(
//   decoder: (v) => switch(v.whichValue()) {
//     .frame => _frameStatementCodec.decode(v),
//     .vertex => _vertexStatementCodec.decode(v),
//     .edge => _edgeStatementCodec.decode(v),
//     .face => _faceStatementCodec.decode(v),
//     .cutEdge => _cutEdgeStatementCodec.decode(v),
//     .dissolve => _dissolveStatementCodec.decode(v),
//     .filletFace => _filletFaceStatementCodec.decode(v),
//     .glueVertices => _glueVerticesStatementCodec.decode(v),
//     .rectangle => _rectangleStatementCodec.decode(v),
//     .polygon => _polygonStatementCodec.decode(v),
//     .ellipse => _ellipseStatementCodec.decode(v),
//     .container => _containerStatementCodec.decode(v),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     FrameStatement v => _frameStatementCodec.encode(v),
//     VertexStatement v => _vertexStatementCodec.encode(v),
//     EdgeStatement v => _edgeStatementCodec.encode(v),
//     FaceStatement v => _faceStatementCodec.encode(v),
//     CutEdgeStatement v => _cutEdgeStatementCodec.encode(v),
//     DissolveStatement v => _dissolveStatementCodec.encode(v),
//     FilletFaceStatement v => _filletFaceStatementCodec.encode(v),
//     GlueVerticesStatement v => _glueVerticesStatementCodec.encode(v),
//     RectangleStatement v => _rectangleStatementCodec.encode(v),
//     PolygonStatement v => _polygonStatementCodec.encode(v),
//     EllipseStatement v => _ellipseStatementCodec.encode(v),
//     ContainerStatement v => _containerStatementCodec.encode(v),
//     _ => throw UnimplementedError(),
//   },
// );

// final _frameStatementCodec = _codec<FrameStatement, gen.Statement>(
//   decoder: (v) => .new(
//     id: v.id.decode(),
//     enabled: v.enabled,
//     size: _opt(v.frame.hasSize, () => v.frame.size.decode()),
//     transform: v.frame.transform.decode(),
//     parent: _opt(v.frame.hasParent, () => v.frame.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     frame: .new(
//       size: v.size?.encode(),
//       transform: v.transform.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _vertexStatementCodec = _codec<VertexStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.vertex.position.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     style: v.vertex.style.decode(),
//     parent: _opt(v.vertex.hasParent, () => v.vertex.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     vertex: .new(
//       position: v.position.encode(),
//       style: v.style.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _edgeStatementCodec = _codec<EdgeStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.edge.start.decode(),
//     v.edge.end.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     startTangent: _opt(v.edge.hasStartTangent, () => v.edge.startTangent.decode()),
//     endTangent: _opt(v.edge.hasEndTangent, () => v.edge.endTangent.decode()),
//     style: v.edge.style.decode(),
//     parent: _opt(v.edge.hasParent, () => v.edge.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     edge: .new(
//       start: v.start.encode(),
//       end: v.end.encode(),
//       startTangent: v.startTangent?.encode(),
//       endTangent: v.endTangent?.encode(),
//       style: v.style.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _faceStatementCodec = _codec<FaceStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.face.outer.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     style: v.face.style.decode(),
//     holes: _map(v.face.holes, (v) => v.decode()),
//     parent: _opt(v.face.hasParent, () => v.face.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     face: .new(
//       outer: v.outer.encode(),
//       style: v.style.encode(),
//       holes: _map(v.holes, (v) => v.encode()),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _cutEdgeStatementCodec = _codec<CutEdgeStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.cutEdge.target.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     t: v.cutEdge.t,
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     cutEdge: .new(
//       target: v.target.encode(),
//       t: v.t,
//     ),
//   ),
// );

// final _dissolveStatementCodec = _codec<DissolveStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.dissolve.selector.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     keep: _map(v.dissolve.keep, (v) => (v.target.decode(), _opt(v.hasFrame, () => v.frame.decode()))),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     dissolve: .new(
//       selector: v.selector.encode(),
//       keep: _map(v.keep, (v) => .new(target: v.$1.encode(), frame: v.$2?.encode())),
//     ),
//   ),
// );

// final _filletFaceStatementCodec = _codec<FilletFaceStatement, gen.Statement>(
//   decoder: (v) => .new(
//     v.filletFace.face.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//     corners: _map(v.filletFace.corners, (v) => (v.vertex.decode(), v.radius.decode())),
//     radius: _opt(v.filletFace.hasRadius, () => v.filletFace.radius.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     filletFace: .new(
//       face: v.face.encode(),
//       corners: _map(v.corners, (v) => .new(vertex: v.$1.encode(), radius: v.$2.encode())),
//       radius: v.radius?.encode(),
//     ),
//   )
// );

// extension _GlueVerticesStatementPositionEncode on GlueVerticesPosition { gen.GlueVerticesStatement_Position encode() => _glueVerticesStatementPositionCodec.encode(this); }
// extension _GlueVerticesStatementPositionDecode on gen.GlueVerticesStatement_Position { GlueVerticesPosition decode() => _glueVerticesStatementPositionCodec.decode(this); }

// final _glueVerticesStatementPositionCodec = _codec<GlueVerticesPosition, gen.GlueVerticesStatement_Position>(
//   decoder: (v) => switch(v) {
//     .GLUE_VERTICES_STATEMENT_POSITION_FIRST => .first,
//     .GLUE_VERTICES_STATEMENT_POSITION_CENTROID => .centroid,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     .first => .GLUE_VERTICES_STATEMENT_POSITION_FIRST,
//     .centroid => .GLUE_VERTICES_STATEMENT_POSITION_CENTROID,
//   }
// );

// final _glueVerticesStatementCodec = _codec<GlueVerticesStatement, gen.Statement>(
//   decoder: (v) => .new(
//     _map(v.glueVertices.vertices, (v) => v.decode()),
//     position: v.glueVertices.position.decode(),
//     id: v.id.decode(),
//     enabled: v.enabled,
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     glueVertices: .new(
//       vertices: v.vertices.map((v) => v.encode()).toList(),
//       position: v.position.encode(),
//     ),
//   )
// );

// final _rectangleStatementCodec = _codec<RectangleStatement, gen.Statement>(
//   decoder: (v) => .new(
//     id: v.id.decode(),
//     enabled: v.enabled,
//     transform: _opt(v.rectangle.hasTransform, () => v.rectangle.transform.decode()),
//     vertexStyle: v.rectangle.vertexStyle.decode(),
//     edgeStyle: v.rectangle.edgeStyle.decode(),
//     faceStyle: v.rectangle.faceStyle.decode(),
//     shape: v.rectangle.shape.decode(),
//     size: v.rectangle.size.decode(),
//     parent: _opt(v.rectangle.hasParent, () => v.rectangle.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     rectangle: .new(
//       transform: v.transform?.encode(),
//       vertexStyle: v.vertexStyle.encode(),
//       edgeStyle: v.edgeStyle.encode(),
//       faceStyle: v.faceStyle.encode(),
//       shape: v.shape.encode(),
//       size: v.size.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _polygonStatementCodec = _codec<PolygonStatement, gen.Statement>(
//   decoder: (v) => .new(
//     id: v.id.decode(),
//     enabled: v.enabled,
//     transform: _opt(v.polygon.hasTransform, () => v.polygon.transform.decode()),
//     vertexStyle: v.polygon.vertexStyle.decode(),
//     edgeStyle: v.polygon.edgeStyle.decode(),
//     faceStyle: v.polygon.faceStyle.decode(),
//     shape: v.polygon.shape.decode(),
//     size: v.polygon.size.decode(),
//     parent: _opt(v.polygon.hasParent, () => v.polygon.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     polygon: .new(
//       transform: v.transform?.encode(),
//       vertexStyle: v.vertexStyle.encode(),
//       edgeStyle: v.edgeStyle.encode(),
//       faceStyle: v.faceStyle.encode(),
//       shape: v.shape.encode(),
//       size: v.size.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _ellipseStatementCodec = _codec<EllipseStatement, gen.Statement>(
//   decoder: (v) => .new(
//     id: v.id.decode(),
//     enabled: v.enabled,
//     transform: _opt(v.ellipse.hasTransform, () => v.ellipse.transform.decode()),
//     vertexStyle: v.ellipse.vertexStyle.decode(),
//     edgeStyle: v.ellipse.edgeStyle.decode(),
//     faceStyle: v.ellipse.faceStyle.decode(),
//     shape: v.ellipse.shape.decode(),
//     size: v.ellipse.size.decode(),
//     parent: _opt(v.ellipse.hasParent, () => v.ellipse.parent.decode()),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     ellipse: .new(
//       transform: v.transform?.encode(),
//       vertexStyle: v.vertexStyle.encode(),
//       edgeStyle: v.edgeStyle.encode(),
//       faceStyle: v.faceStyle.encode(),
//       shape: v.shape.encode(),
//       size: v.size.encode(),
//       parent: v.parent?.ref.encode(),
//     ),
//   )
// );

// final _containerStatementCodec = _codec<ContainerStatement, gen.Statement>(
//   decoder: (v) => .new(
//     id: v.id.decode(),
//     enabled: v.enabled,
//     transform: _opt(v.container.hasTransform, () => v.container.transform.decode()),
//     layout: v.container.layout.decode(),
//     size: v.container.size.decode(),
//     parent: _opt(v.container.hasParent, () => v.container.parent.decode()),
//     vertexStyle: v.container.vertexStyle.decode(),
//     edgeStyle: v.container.edgeStyle.decode(),
//     faceStyle: v.container.faceStyle.decode(),
//     shape: v.container.shape.decode(),
//   ),
//   encoder: (v) => .new(
//     id: v.id.encode(),
//     enabled: v.enabled,
//     container: .new(
//       transform: v.transform?.encode(),
//       layout: v.layout.encode(),
//       size: v.size.encode(),
//       parent: v.parent?.ref.encode(),
//       vertexStyle: v.vertexStyle.encode(),
//       edgeStyle: v.edgeStyle.encode(),
//       faceStyle: v.faceStyle.encode(),
//       shape: v.shape.encode(),
//     ),
//   )
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Shape
// // ---------------------------------------------------------------------------------------------------------------------

// extension _ObjectShapeRectangleEncode on RectangleObjectShape { gen.ObjectShape_Rectangle encode() => _objectShapeRectangleCodec.encode(this); }
// extension _ObjectShapeRectangleDecode on gen.ObjectShape_Rectangle { RectangleObjectShape decode() => _objectShapeRectangleCodec.decode(this); }

// final _objectShapeRectangleCodec = _codec<RectangleObjectShape, gen.ObjectShape_Rectangle>(
//   decoder: (v) => .new(),
//   encoder: (v) => .new(),
// );

// extension _ObjectShapePolygonEncode on PolygonObjectShape { gen.ObjectShape_Polygon encode() => _objectShapePolygonCodec.encode(this); }
// extension _ObjectShapePolygonDecode on gen.ObjectShape_Polygon { PolygonObjectShape decode() => _objectShapePolygonCodec.decode(this); }

// final _objectShapePolygonCodec = _codec<PolygonObjectShape, gen.ObjectShape_Polygon>(
//   decoder: (v) => .new(sides: v.sides),
//   encoder: (v) => .new(sides: v.sides),
// );

// extension _ObjectShapeEllipseEncode on EllipseObjectShape { gen.ObjectShape_Ellipse encode() => _objectShapeEllipseCodec.encode(this); }
// extension _ObjectShapeEllipseDecode on gen.ObjectShape_Ellipse { EllipseObjectShape decode() => _objectShapeEllipseCodec.decode(this); }

// final _objectShapeEllipseCodec = _codec<EllipseObjectShape, gen.ObjectShape_Ellipse>(
//   decoder: (v) => .new(),
//   encoder: (v) => .new(),
// );

// extension _ObjectShapeEncode on ObjectShape { gen.ObjectShape encode() => _objectShapeCodec.encode(this); }
// extension _ObjectShapeDecode on gen.ObjectShape { ObjectShape decode() => _objectShapeCodec.decode(this); }

// final _objectShapeCodec = _codec<ObjectShape, gen.ObjectShape>(
//   decoder: (v) => switch(v.whichValue()) {
//     .rectangle => v.rectangle.decode(),
//     .polygon => v.polygon.decode(),
//     .ellipse => v.ellipse.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     RectangleObjectShape v => .new(rectangle: v.encode()),
//     PolygonObjectShape v => .new(polygon: v.encode()),
//     EllipseObjectShape v => .new(ellipse: v.encode()),
//   },
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Layout
// // ---------------------------------------------------------------------------------------------------------------------

// extension _LayoutDimensionTypeEncode on LayoutDimensionType { gen.LayoutDimension_Type encode() => _layoutDimensionTypeCodec.encode(this); }
// extension _LayoutDimensionTypeDecode on gen.LayoutDimension_Type { LayoutDimensionType decode() => _layoutDimensionTypeCodec.decode(this); }

// final _layoutDimensionTypeCodec = _codec<LayoutDimensionType, gen.LayoutDimension_Type>(
//   decoder: (v) => switch(v) {
//     .LAYOUT_DIMENSION_TYPE_FIXED => .fixed,
//     .LAYOUT_DIMENSION_TYPE_EXPAND => .expand,
//     .LAYOUT_DIMENSION_TYPE_CONTAIN => .contain,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     .fixed => .LAYOUT_DIMENSION_TYPE_FIXED,
//     .expand => .LAYOUT_DIMENSION_TYPE_EXPAND,
//     .contain => .LAYOUT_DIMENSION_TYPE_CONTAIN,
//   },
// );

// extension _LayoutDimensionRangeEncode on LayoutRange { gen.LayoutDimension_Range encode() => _layoutDimensionRangeCodec.encode(this); }
// extension _LayoutDimensionRangeDecode on gen.LayoutDimension_Range { LayoutRange decode() => _layoutDimensionRangeCodec.decode(this); }

// final _layoutDimensionRangeCodec = _codec<LayoutRange, gen.LayoutDimension_Range>(
//   decoder: (v) => .new(
//     min: v.min,
//     max: v.max,
//   ),
//   encoder: (v) => .new(
//     min: v.min,
//     max: v.max,
//   ),
// );

// extension _LayoutDimensionEncode on LayoutDimension { gen.LayoutDimension encode() => _layoutDimensionCodec.encode(this); }
// extension _LayoutDimensionDecode on gen.LayoutDimension { LayoutDimension decode() => _layoutDimensionCodec.decode(this); }

// final _layoutDimensionCodec = _codec<LayoutDimension, gen.LayoutDimension>(
//   decoder: (v) => .new(
//     _opt(v.hasValue, () => v.value),
//     v.type.decode(),
//     v.range.decode(),
//   ),
//   encoder: (v) => .new(
//     value: v.value,
//     type: v.type.encode(),
//     range: v.range.encode(),
//   ),
// );

// extension _LayoutSizeEncode on LayoutSize { gen.LayoutSize encode() => _layoutSizeCodec.encode(this); }
// extension _LayoutSizeDecode on gen.LayoutSize { LayoutSize decode() => _layoutSizeCodec.decode(this); }

// final _layoutSizeCodec = _codec<LayoutSize, gen.LayoutSize>(
//   decoder: (v) => .new(
//     v.width.decode(),
//     v.height.decode(),
//   ),
//   encoder: (v) => .new(
//     width: v.width.encode(),
//     height: v.height.encode(),
//   ),
// );

// extension _LayoutAlignEncode on LayoutAlign { gen.Layout_Align encode() => _layoutAlignCodec.encode(this); }
// extension _LayoutAlignDecode on gen.Layout_Align { LayoutAlign decode() => _layoutAlignCodec.decode(this); }

// final _layoutAlignCodec = _codec<LayoutAlign, gen.Layout_Align>(
//   decoder: (v) => switch (v) {
//     .LAYOUT_ALIGN_START => .start,
//     .LAYOUT_ALIGN_CENTER => .center,
//     .LAYOUT_ALIGN_END => .end,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch (v) {
//     .start => .LAYOUT_ALIGN_START,
//     .center => .LAYOUT_ALIGN_CENTER,
//     .end => .LAYOUT_ALIGN_END,
//   },
// );

// extension _LayoutJustifyEncode on LayoutJustify { gen.Layout_Justify encode() => _layoutJustifyCodec.encode(this); }
// extension _LayoutJustifyDecode on gen.Layout_Justify { LayoutJustify decode() => _layoutJustifyCodec.decode(this); }

// final _layoutJustifyCodec = _codec<LayoutJustify, gen.Layout_Justify>(
//   decoder: (v) => switch(v) {
//     .LAYOUT_JUSTIFY_START => .start,
//     .LAYOUT_JUSTIFY_CENTER => .center,
//     .LAYOUT_JUSTIFY_END => .end,
//     .LAYOUT_JUSTIFY_SPACE_BETWEEN => .spaceBetween,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     .start => .LAYOUT_JUSTIFY_START,
//     .center => .LAYOUT_JUSTIFY_CENTER,
//     .end => .LAYOUT_JUSTIFY_END,
//     .spaceBetween => .LAYOUT_JUSTIFY_SPACE_BETWEEN,
//   },
// );

// extension _LayoutInsetsEncode on LayoutInsets { gen.Layout_Insets encode() => _layoutInsetsCodec.encode(this); }
// extension _LayoutInsetsDecode on gen.Layout_Insets { LayoutInsets decode() => _layoutInsetsCodec.decode(this); }

// final _layoutInsetsCodec = _codec<LayoutInsets, gen.Layout_Insets>(
//   decoder: (v) => .new(v.left, v.top, v.right, v.bottom),
//   encoder: (v) => .new(left: v.left, top: v.top, right: v.right, bottom: v.bottom),
// );

// extension _LayoutStackEncode on StackLayout { gen.Layout_Stack encode() => _layoutStackCodec.encode(this); }
// extension _LayoutStackDecode on gen.Layout_Stack { StackLayout decode() => _layoutStackCodec.decode(this); }

// final _layoutStackCodec = _codec<StackLayout, gen.Layout_Stack>(
//   decoder: (v) => .new(
//     alignHorizontal: _opt(v.hasAlignHorizontal, () => v.alignHorizontal.decode()),
//     alignVertical: _opt(v.hasAlignVertical, () => v.alignVertical.decode()),
//     padding: v.padding.decode(),
//   ),
//   encoder: (v) => .new(
//     alignHorizontal: v.alignHorizontal?.encode(),
//     alignVertical: v.alignVertical?.encode(),
//     padding: v.padding.encode(),
//   ),
// );

// extension _FlexDirectionEncode on FlexDirection { gen.Layout_Flex_Direction encode() => _flexDirectionCodec.encode(this); }
// extension _FlexDirectionDecode on gen.Layout_Flex_Direction { FlexDirection decode() => _flexDirectionCodec.decode(this); }

// final _flexDirectionCodec = _codec<FlexDirection, gen.Layout_Flex_Direction>(
//   decoder: (v) => switch(v) {
//     .LAYOUT_FLEX_DIRECTION_ROW => .row,
//     .LAYOUT_FLEX_DIRECTION_COLUMN => .column,
//     _ => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     .row => .LAYOUT_FLEX_DIRECTION_ROW,
//     .column => .LAYOUT_FLEX_DIRECTION_COLUMN,
//   },
// );

// extension _LayoutFlexEncode on FlexLayout { gen.Layout_Flex encode() => _layoutFlexCodec.encode(this); }
// extension _LayoutFlexDecode on gen.Layout_Flex { FlexLayout decode() => _layoutFlexCodec.decode(this); }

// final _layoutFlexCodec = _codec<FlexLayout, gen.Layout_Flex>(
//   decoder: (v) => .new(
//     direction: v.direction.decode(),
//     justify: v.justify.decode(),
//     crossAlign: v.crossAlign.decode(),
//     gap: v.gap,
//     padding: v.padding.decode(),
//   ),
//   encoder: (v) => .new(
//     direction: v.direction.encode(),
//     justify: v.justify.encode(),
//     crossAlign: v.crossAlign.encode(),
//     gap: v.gap,
//     padding: v.padding.encode(),
//   ),
// );

// extension _LayoutEncode on Layout { gen.Layout encode() => _layoutCodec.encode(this); }
// extension _LayoutDecode on gen.Layout { Layout decode() => _layoutCodec.decode(this); }

// final _layoutCodec = _codec<Layout, gen.Layout>(
//   decoder: (v) => switch(v.whichValue()) {
//     .stack => v.stack.decode(),
//     .flex => v.flex.decode(),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     StackLayout v => .new(stack: v.encode()),
//     FlexLayout v => .new(flex: v.encode()),
//   },
// );

// // ---------------------------------------------------------------------------------------------------------------------
// // Generator nodes
// // ---------------------------------------------------------------------------------------------------------------------

// // ---------------------------------------------------------------------------------------------------------------------
// // Other types
// // ---------------------------------------------------------------------------------------------------------------------

// extension _Mat4Encode on Mat4 { gen.Mat4 encode() => _mat4Codec.encode(this); }
// extension _Mat4Decode on gen.Mat4 { Mat4 decode() => _mat4Codec.decode(this); }

// final _mat4Codec = _codec<Mat4, gen.Mat4>(
//   decoder: (v) => .from(v.m00, v.m01, v.m02, v.m03, v.m10, v.m11, v.m12, v.m13, v.m20, v.m21, v.m22, v.m23, v.m30, v.m31, v.m32, v.m33),
//   encoder: (v) => .new(m00: v.m00, m01: v.m01, m02: v.m02, m03: v.m03, m10: v.m10, m11: v.m11, m12: v.m12, m13: v.m13, m20: v.m20, m21: v.m21, m22: v.m22, m23: v.m23, m30: v.m30, m31: v.m31, m32: v.m32, m33: v.m33),
// );

// extension _Vec2Encode on Vec2 { gen.Vec2 encode() => _vec2Codec.encode(this); }
// extension _Vec2Decode on gen.Vec2 { Vec2 decode() => _vec2Codec.decode(this); }

// final _vec2Codec = _codec<Vec2, gen.Vec2>(
//   decoder: (v) => .new(v.x, v.y),
//   encoder: (v) => .new(x: v.x, y: v.y),
// );

// extension _Size2Encode on Size2 { gen.Size2 encode() => _size2Codec.encode(this); }
// extension _Size2Decode on gen.Size2 { Size2 decode() => _size2Codec.decode(this); }

// final _size2Codec = _codec<Size2, gen.Size2>(
//   decoder: (v) => .new(v.width, v.height),
//   encoder: (v) => .new(width: v.width, height: v.height),
// );

// extension _CornerRadiusEncode on CornerRadius { gen.CornerRadius encode() => _cornerRadiusCodec.encode(this); }
// extension _CornerRadiusDecode on gen.CornerRadius { CornerRadius decode() => _cornerRadiusCodec.decode(this); }

// final _cornerRadiusCodec = _codec<CornerRadius, gen.CornerRadius>(
//   decoder: (v) => .new(v.x, v.y),
//   encoder: (v) => .new(x: v.x, y: v.y),
// );

// extension _ColorDataEncode on ColorData { gen.ColorData encode() => _colorDataCodec.encode(this); }
// extension _ColorDataDecode on gen.ColorData { ColorData decode() => _colorDataCodec.decode(this); }

// final _colorDataCodec = _codec<ColorData, gen.ColorData>(
//   decoder: (v) => switch(v.whichValue()) {
//     .hsv => ColorData.hsv(h: v.hsv.h, s: v.hsv.s, v: v.hsv.v, alpha: v.alpha),
//     .notSet => throw ArgumentError(),
//   },
//   encoder: (v) => switch(v) {
//     HsvColorData v => .new(hsv: .new(h: v.h, s: v.s, v: v.v), alpha: v.alpha),
//   }
// );