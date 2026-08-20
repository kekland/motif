part of 'serializer.dart';

final _sceneCodec = _codec<Scene, pb.Scene>(
  decoder: (v) => .new(
    program: _programCodec.decode(v.program),
    styleOverrides: _styleOverridesCodec.decode(v.styleOverrides),
  ),
  encoder: (v) => .new(
    program: _programCodec.encode(v.program),
    styleOverrides: _styleOverridesCodec.encode(v.styleOverrides),
  ),
);

final _programCodec = _codec<Program, pb.Program>(
  decoder: (v) => .new(
    v.statements.map((s) => _statementCodec.decode(s)).toList(),
  ),
  encoder: (v) => .new(
    statements: v.statements.map((s) => _statementCodec.encode(s)).toList(),
  ),
);

final _sceneSliceCodec = _codec<SceneSlice, pb.SceneSlice>(
  decoder: (v) => .new(
    statements: v.statements.map((s) => _statementCodec.decode(s)).toList(),
    styleOverrides: _styleOverridesCodec.decode(v.styleOverrides),
  ),
  encoder: (v) => .new(
    statements: v.statements.map((s) => _statementCodec.encode(s)).toList(),
    styleOverrides: _styleOverridesCodec.encode(v.styleOverrides),
  ),
);

// ---------------------------------------------------------------------------
// Style overrides
// ---------------------------------------------------------------------------

// dart format off
extension _StyleOverridesEncode on StyleOverrides { pb.StyleOverrides encode() => _styleOverridesCodec.encode(this); }
extension _StyleOverridesDecode on pb.StyleOverrides { StyleOverrides decode() => _styleOverridesCodec.decode(this); }
// dart format on

final _styleOverridesCodec = _codec<StyleOverrides, pb.StyleOverrides>(
  decoder: (v) {
    final overrides = StyleOverrides();
    for (final entry in v.entries) {
      overrides.set(entry.ref.decode(), entry.style.decode());
    }
    return overrides;
  },
  encoder: (v) => .new(
    entries: v.entries.map((e) => pb.StyleOverrides_Entry(ref: e.key.encode(), style: e.value.encode())).toList(),
  ),
);

// ---------------------------------------------------------------------------
// Statements
// ---------------------------------------------------------------------------

final _statementCodec = _codec<Statement, pb.Statement>(
  decoder: (v) => switch (v.whichStatement()) {
    .frame => _frameStatementCodec.decode(v.frame),
    .vertex => _vertexStatementCodec.decode(v.vertex),
    .edge => _edgeStatementCodec.decode(v.edge),
    .face => _faceStatementCodec.decode(v.face),
    .circle => _circleStatementCodec.decode(v.circle),
    .rectangle => _rectangleStatementCodec.decode(v.rectangle),
    .triangle => _triangleStatementCodec.decode(v.triangle),
    .container => _containerStatementCodec.decode(v.container),
    .cutEdge => _cutEdgeStatementCodec.decode(v.cutEdge),
    .glueVertices => _glueVerticesStatementCodec.decode(v.glueVertices),
    _ => throw ArgumentError.value(v, 'v', 'unknown statement'),
  },
  encoder: (v) => switch (v) {
    // Order matters: ContainerStatement before the other ShapeStatement
    // subclasses, and shape subclasses before FrameStatement.
    ContainerStatement s => .new(container: _containerStatementCodec.encode(s)),
    CircleStatement s => .new(circle: _circleStatementCodec.encode(s)),
    RectangleStatement s => .new(rectangle: _rectangleStatementCodec.encode(s)),
    TriangleStatement s => .new(triangle: _triangleStatementCodec.encode(s)),
    FrameStatement s => .new(frame: _frameStatementCodec.encode(s)),
    VertexStatement s => .new(vertex: _vertexStatementCodec.encode(s)),
    EdgeStatement s => .new(edge: _edgeStatementCodec.encode(s)),
    FaceStatement s => .new(face: _faceStatementCodec.encode(s)),
    CutEdgeStatement s => .new(cutEdge: _cutEdgeStatementCodec.encode(s)),
    GlueVerticesStatement s => .new(glueVertices: _glueVerticesStatementCodec.encode(s)),
    _ => throw ArgumentError.value(v, 'v', 'unknown statement'),
  },
);

final _frameStatementCodec = _codec<FrameStatement, pb.FrameStatement>(
  decoder: (v) => .new(
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
    transform: v.transform.decode(),
  ),
  encoder: (v) => .new(
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
    transform: v.transform.encode(),
  ),
);

final _vertexStatementCodec = _codec<VertexStatement, pb.VertexStatement>(
  decoder: (v) => .new(
    v.position.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    position: v.position.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _edgeStatementCodec = _codec<EdgeStatement, pb.EdgeStatement>(
  decoder: (v) => .new(
    v.start.decode().cast(),
    v.end.decode().cast(),
    startTangent: v.hasStartTangent() ? v.startTangent.decode() : null,
    endTangent: v.hasEndTangent() ? v.endTangent.decode() : null,
    style: v.style.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    start: v.start.ref.encode(),
    end: v.end.ref.encode(),
    startTangent: v.startTangent?.encode(),
    endTangent: v.endTangent?.encode(),
    style: v.style.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _faceStatementCodec = _codec<FaceStatement, pb.FaceStatement>(
  decoder: (v) => .new(
    v.outer.decode(),
    holes: v.holes.map((c) => c.decode()).toList(),
    style: v.style.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    outer: v.outer.map((a) => a.ref).encode(),
    holes: v.holes.map((a) => a.map((e) => e.ref).encode()).toList(),
    style: v.style.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _circleStatementCodec = _codec<CircleStatement, pb.CircleStatement>(
  decoder: (v) => .new(
    transform: v.transform.decode(),
    size: v.size.decode(),
    edgeStyle: v.edgeStyle.decode(),
    faceStyle: v.faceStyle.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    shape: pb.CircleObjectShape(),
    edgeStyle: v.edgeStyle.encode(),
    faceStyle: v.faceStyle.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _rectangleStatementCodec = _codec<RectangleStatement, pb.RectangleStatement>(
  decoder: (v) => .new(
    transform: v.transform.decode(),
    size: v.size.decode(),
    shape: v.shape.decode(),
    edgeStyle: v.edgeStyle.decode(),
    faceStyle: v.faceStyle.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    shape: v.shape.encode(),
    edgeStyle: v.edgeStyle.encode(),
    faceStyle: v.faceStyle.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _triangleStatementCodec = _codec<TriangleStatement, pb.TriangleStatement>(
  decoder: (v) => .new(
    transform: v.transform.decode(),
    size: v.size.decode(),
    edgeStyle: v.edgeStyle.decode(),
    faceStyle: v.faceStyle.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    shape: pb.TriangleObjectShape(),
    edgeStyle: v.edgeStyle.encode(),
    faceStyle: v.faceStyle.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _containerStatementCodec = _codec<ContainerStatement, pb.ContainerStatement>(
  decoder: (v) => .new(
    transform: v.transform.decode(),
    size: v.size.decode(),
    shape: v.shape.decode(),
    childLayout: v.childLayout.decode(),
    edgeStyle: v.edgeStyle.decode(),
    faceStyle: v.faceStyle.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    shape: v.shape.encode(),
    childLayout: v.childLayout.encode(),
    edgeStyle: v.edgeStyle.encode(),
    faceStyle: v.faceStyle.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _cutEdgeStatementCodec = _codec<CutEdgeStatement, pb.CutEdgeStatement>(
  decoder: (v) => .new(
    v.target.decode().cast(),
    t: v.t,
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    target: v.target.ref.encode(),
    t: v.t,
    id: v.id.encode(),
  ),
);

// dart format off
extension _GlueVerticesPositionEncode on GlueVerticesPosition { pb.GlueVerticesStatement_Position encode() => _glueVerticesPositionCodec.encode(this); }
extension _GlueVerticesPositionDecode on pb.GlueVerticesStatement_Position { GlueVerticesPosition decode() => _glueVerticesPositionCodec.decode(this); }
// dart format on

final _glueVerticesPositionCodec = _codec<GlueVerticesPosition, pb.GlueVerticesStatement_Position>(
  decoder: (v) => switch (v) {
    .GLUE_VERTICES_STATEMENT_POSITION_CENTROID => .centroid,
    .GLUE_VERTICES_STATEMENT_POSITION_FIRST => .first,
    _ => throw ArgumentError.value(v, 'v', 'Unknown GlueVerticesPosition'),
  },
  encoder: (v) => switch (v) {
    .centroid => .GLUE_VERTICES_STATEMENT_POSITION_CENTROID,
    .first => .GLUE_VERTICES_STATEMENT_POSITION_FIRST,
  },
);

final _glueVerticesStatementCodec = _codec<GlueVerticesStatement, pb.GlueVerticesStatement>(
  decoder: (v) => .new(
    v.targets.decode().cast(),
    position: v.position.decode(),
    id: v.id.decode(),
  ),
  encoder: (v) => .new(
    targets: v.targets.map((e) => e.ref).encode(),
    position: v.position.encode(),
    id: v.id.encode(),
  ),
);

// ---------------------------------------------------------------------------
// Primitives
// ---------------------------------------------------------------------------

// dart format off
extension _Vec2Encode on Vec2 { pb.Vec2 encode() => _vec2Codec.encode(this); }
extension _Vec2Decode on pb.Vec2 { Vec2 decode() => _vec2Codec.decode(this); }
// dart format on

final _vec2Codec = _codec<Vec2, pb.Vec2>(
  decoder: (v) => .new(v.x, v.y),
  encoder: (v) => .new(x: v.x, y: v.y),
);

// dart format off
extension _Mat4Encode on Mat4 { pb.Mat4 encode() => _mat4Codec.encode(this); }
extension _Mat4Decode on pb.Mat4 { Mat4 decode() => _mat4Codec.decode(this); }
// dart format on

final _mat4Codec = _codec<Mat4, pb.Mat4>(
  decoder: (v) => .fromListFloat64(v.values),
  encoder: (v) => .new(values: v.storage.buffer.asFloat64List().toList()),
);

// dart format off
extension _StatementIdEncode on StatementId { pb.StatementId encode() => _statementIdCodec.encode(this); }
extension _StatementIdDecode on pb.StatementId { StatementId decode() => _statementIdCodec.decode(this); }
// dart format on

final _statementIdCodec = _codec<StatementId, pb.StatementId>(
  decoder: (v) => .fromValue(v.value),
  encoder: (v) => .new(value: v.value),
);

// dart format off
extension _RefKindEncode on CellKind { pb.Ref_Kind encode() => _refKindCodec.encode(this); }
extension _RefKindDecode on pb.Ref_Kind { CellKind decode() => _refKindCodec.decode(this); }
// dart format on

final _refKindCodec = _codec<CellKind, pb.Ref_Kind>(
  decoder: (v) => switch (v) {
    .REF_KIND_FRAME => .frame,
    .REF_KIND_VERTEX => .vertex,
    .REF_KIND_EDGE => .edge,
    .REF_KIND_FACE => .face,
    _ => throw ArgumentError.value(v, 'v', 'unknown ref kind'),
  },
  encoder: (v) => switch (v) {
    .frame => .REF_KIND_FRAME,
    .vertex => .REF_KIND_VERTEX,
    .edge => .REF_KIND_EDGE,
    .face => .REF_KIND_FACE,
  },
);

// dart format off
extension _RefEncode on Ref { pb.Ref encode() => _refCodec.encode(this); }
extension _RefDecode on pb.Ref { Ref decode() => _refCodec.decode(this); }
extension _RefListEncode on Iterable<Ref> { List<pb.Ref> encode() => map((e) => e.encode()).toList(); }
extension _RefListDecode on Iterable<pb.Ref> { List<Ref> decode() => map((e) => e.decode()).toList(); }
// dart format on

final _refCodec = _codec<Ref, pb.Ref>(
  decoder: (v) => .new(_statementIdCodec.decode(v.id), Symbol(v.product), v.kind.decode()),
  encoder: (v) => .new(id: _statementIdCodec.encode(v.statement), product: v.product.name, kind: v.kind.encode()),
);

// dart format off
extension _FaceCycleEncode on Iterable<EdgeRef> { pb.FaceStatement_Cycle encode() => _faceCycleCodec.encode(toList()); }
extension _FaceCycleDecode on pb.FaceStatement_Cycle { List<EdgeRef> decode() => _faceCycleCodec.decode(this); }
// dart format on

final _faceCycleCodec = _codec<List<EdgeRef>, pb.FaceStatement_Cycle>(
  decoder: (v) => v.edges.map((e) => e.decode().cast<EdgeHandle>()).toList(),
  encoder: (v) => .new(edges: v.map((e) => e.encode()).toList()),
);

// ---------------------------------------------------------------------------
// Styles
// ---------------------------------------------------------------------------

// dart format off
extension _ColorDataEncode on ColorData { pb.ColorData encode() => _colorDataCodec.encode(this); }
extension _ColorDataDecode on pb.ColorData { ColorData decode() => _colorDataCodec.decode(this); }
// dart format on

final _colorDataCodec = _codec<ColorData, pb.ColorData>(
  decoder: (v) => switch (v.type) {
    .COLOR_DATA_TYPE_HSV => .hsv(h: v.v1, s: v.v2, v: v.v3, alpha: v.alpha),
    _ => throw ArgumentError.value(v, 'v', 'Unknown ColorData type'),
  },
  encoder: (v) => .new(
    type: .COLOR_DATA_TYPE_HSV,
    v1: v.v1,
    v2: v.v2,
    v3: v.v3,
    alpha: v.alpha,
  ),
);

// dart format off
extension _CellStyleEncode on CellStyle { pb.CellStyle encode() => _cellStyleCodec.encode(this); }
extension _CellStyleDecode on pb.CellStyle { CellStyle decode() => _cellStyleCodec.decode(this); }
// dart format on

final _cellStyleCodec = _codec<CellStyle, pb.CellStyle>(
  decoder: (v) => switch (v.whichStyle()) {
    .edge => v.edge.decode(),
    .face => v.face.decode(),
    _ => throw ArgumentError.value(v, 'v', 'Unknown CellStyle'),
  },
  encoder: (v) => switch (v) {
    EdgeStyle e => .new(edge: e.encode()),
    FaceStyle f => .new(face: f.encode()),
  },
);

// dart format off
extension _EdgeStyleEncode on EdgeStyle { pb.EdgeStyle encode() => _edgeStyleCodec.encode(this); }
extension _EdgeStyleDecode on pb.EdgeStyle { EdgeStyle decode() => _edgeStyleCodec.decode(this); }
// dart format on

final _edgeStyleCodec = _codec<EdgeStyle, pb.EdgeStyle>(
  decoder: (v) => .new(width: v.width, color: v.color.decode()),
  encoder: (v) => .new(width: v.width, color: v.color.encode()),
);

// dart format off
extension _FaceStyleEncode on FaceStyle { pb.FaceStyle encode() => _faceStyleCodec.encode(this); }
extension _FaceStyleDecode on pb.FaceStyle { FaceStyle decode() => _faceStyleCodec.decode(this); }
// dart format on

final _faceStyleCodec = _codec<FaceStyle, pb.FaceStyle>(
  decoder: (v) => .new(color: v.color.decode()),
  encoder: (v) => .new(color: v.color.encode()),
);

// dart format off
extension _CellStylePartialEncode on CellStylePartial { pb.CellStylePartial encode() => _cellStylePartialCodec.encode(this); }
extension _CellStylePartialDecode on pb.CellStylePartial { CellStylePartial decode() => _cellStylePartialCodec.decode(this); }
// dart format on

final _cellStylePartialCodec = _codec<CellStylePartial, pb.CellStylePartial>(
  decoder: (v) => switch (v.whichStyle()) {
    .edge => v.edge.decode(),
    .face => v.face.decode(),
    _ => throw ArgumentError.value(v, 'v', 'Unknown CellStyle'),
  },
  encoder: (v) => switch (v) {
    EdgeStylePartial e => .new(edge: e.encode()),
    FaceStylePartial f => .new(face: f.encode()),
  },
);

// dart format off
extension _EdgeStylePartialEncode on EdgeStylePartial { pb.EdgeStylePartial encode() => _edgeStylePartialCodec.encode(this); }
extension _EdgeStylePartialDecode on pb.EdgeStylePartial { EdgeStylePartial decode() => _edgeStylePartialCodec.decode(this); }
// dart format on

final _edgeStylePartialCodec = _codec<EdgeStylePartial, pb.EdgeStylePartial>(
  decoder: (v) => .new(width: v.width, color: v.hasColor() ? v.color.decode() : null),
  encoder: (v) => .new(width: v.width, color: v.color?.encode()),
);

// dart format off
extension _FaceStylePartialEncode on FaceStylePartial { pb.FaceStylePartial encode() => _faceStylePartialCodec.encode(this); }
extension _FaceStylePartialDecode on pb.FaceStylePartial { FaceStylePartial decode() => _faceStylePartialCodec.decode(this); }
// dart format on

final _faceStylePartialCodec = _codec<FaceStylePartial, pb.FaceStylePartial>(
  decoder: (v) => .new(color: v.hasColor() ? v.color.decode() : null),
  encoder: (v) => .new(color: v.color?.encode()),
);

// ---------------------------------------------------------------------------
// Shapes
// ---------------------------------------------------------------------------

// dart format off
extension _CornerRadiusEncode on CornerRadius { pb.CornerRadius encode() => _cornerRadiusCodec.encode(this); }
extension _CornerRadiusDecode on pb.CornerRadius { CornerRadius decode() => _cornerRadiusCodec.decode(this); }
// dart format on

final _cornerRadiusCodec = _codec<CornerRadius, pb.CornerRadius>(
  decoder: (v) => .new(v.x, v.y),
  encoder: (v) => .new(x: v.x, y: v.y),
);

// dart format off
extension _RectangleObjectShapeEncode on RectangleObjectShape { pb.RectangleObjectShape encode() => _rectangleObjectShapeCodec.encode(this); }
extension _RectangleObjectShapeDecode on pb.RectangleObjectShape { RectangleObjectShape decode() => _rectangleObjectShapeCodec.decode(this); }
// dart format on

final _rectangleObjectShapeCodec = _codec<RectangleObjectShape, pb.RectangleObjectShape>(
  decoder: (v) => .new(
    topLeftRadius: v.topLeftRadius.decode(),
    topRightRadius: v.topRightRadius.decode(),
    bottomLeftRadius: v.bottomLeftRadius.decode(),
    bottomRightRadius: v.bottomRightRadius.decode(),
  ),
  encoder: (v) => .new(
    topLeftRadius: v.topLeftRadius.encode(),
    topRightRadius: v.topRightRadius.encode(),
    bottomLeftRadius: v.bottomLeftRadius.encode(),
    bottomRightRadius: v.bottomRightRadius.encode(),
  ),
);

// dart format off
extension _ObjectShapeEncode on ObjectShape { pb.ObjectShape encode() => _objectShapeCodec.encode(this); }
extension _ObjectShapeDecode on pb.ObjectShape { ObjectShape decode() => _objectShapeCodec.decode(this); }
// dart format on

final _objectShapeCodec = _codec<ObjectShape, pb.ObjectShape>(
  decoder: (v) => switch (v.whichShape()) {
    .circle => const CircleObjectShape(),
    .rectangle => v.rectangle.decode(),
    .triangle => const TriangleObjectShape(),
    _ => throw ArgumentError.value(v, 'v', 'Unknown ObjectShape'),
  },
  encoder: (v) => switch (v) {
    CircleObjectShape _ => .new(circle: pb.CircleObjectShape()),
    RectangleObjectShape s => .new(rectangle: s.encode()),
    TriangleObjectShape _ => .new(triangle: pb.TriangleObjectShape()),
  },
);

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

// dart format off
extension _LayoutDimensionTypeEncode on LayoutDimensionType { pb.LayoutDimension_Type encode() => _layoutDimensionTypeCodec.encode(this); }
extension _LayoutDimensionTypeDecode on pb.LayoutDimension_Type { LayoutDimensionType decode() => _layoutDimensionTypeCodec.decode(this); }
// dart format on

final _layoutDimensionTypeCodec = _codec<LayoutDimensionType, pb.LayoutDimension_Type>(
  decoder: (v) => switch (v) {
    .LAYOUT_DIMENSION_TYPE_FIXED => .fixed,
    .LAYOUT_DIMENSION_TYPE_CONTAIN => .contain,
    .LAYOUT_DIMENSION_TYPE_EXPAND => .expand,
    _ => throw ArgumentError.value(v, 'v', 'Unknown LayoutDimensionType'),
  },
  encoder: (v) => switch (v) {
    .fixed => .LAYOUT_DIMENSION_TYPE_FIXED,
    .contain => .LAYOUT_DIMENSION_TYPE_CONTAIN,
    .expand => .LAYOUT_DIMENSION_TYPE_EXPAND,
  },
);

// dart format off
extension _LayoutRangeEncode on LayoutRange { pb.LayoutRange encode() => _layoutRangeCodec.encode(this); }
extension _LayoutRangeDecode on pb.LayoutRange { LayoutRange decode() => _layoutRangeCodec.decode(this); }
// dart format on

final _layoutRangeCodec = _codec<LayoutRange, pb.LayoutRange>(
  decoder: (v) => .new(min: v.min, max: v.max),
  encoder: (v) => .new(min: v.min, max: v.max),
);

// dart format off
extension _LayoutDimensionEncode on LayoutDimension { pb.LayoutDimension encode() => _layoutDimensionCodec.encode(this); }
extension _LayoutDimensionDecode on pb.LayoutDimension { LayoutDimension decode() => _layoutDimensionCodec.decode(this); }
// dart format on

final _layoutDimensionCodec = _codec<LayoutDimension, pb.LayoutDimension>(
  decoder: (v) => .new(
    v.hasValue() ? v.value : null,
    v.type.decode(),
    v.range.decode(),
  ),
  encoder: (v) => .new(
    value: v.value,
    type: v.type.encode(),
    range: v.range.encode(),
  ),
);

// dart format off
extension _LayoutSizeEncode on LayoutSize { pb.LayoutSize encode() => _layoutSizeCodec.encode(this); }
extension _LayoutSizeDecode on pb.LayoutSize { LayoutSize decode() => _layoutSizeCodec.decode(this); }
// dart format on

final _layoutSizeCodec = _codec<LayoutSize, pb.LayoutSize>(
  decoder: (v) => .new(v.width.decode(), v.height.decode()),
  encoder: (v) => .new(width: v.width.encode(), height: v.height.encode()),
);

// dart format off
extension _LayoutInsetsEncode on LayoutInsets { pb.LayoutInsets encode() => _layoutInsetsCodec.encode(this); }
extension _LayoutInsetsDecode on pb.LayoutInsets { LayoutInsets decode() => _layoutInsetsCodec.decode(this); }
// dart format on

final _layoutInsetsCodec = _codec<LayoutInsets, pb.LayoutInsets>(
  decoder: (v) => .new(v.left, v.top, v.right, v.bottom),
  encoder: (v) => .new(left: v.left, top: v.top, right: v.right, bottom: v.bottom),
);

// dart format off
extension _LayoutAlignEncode on LayoutAlign { pb.LayoutAlign encode() => _layoutAlignCodec.encode(this); }
extension _LayoutAlignDecode on pb.LayoutAlign { LayoutAlign decode() => _layoutAlignCodec.decode(this); }
// dart format on

final _layoutAlignCodec = _codec<LayoutAlign, pb.LayoutAlign>(
  decoder: (v) => switch (v) {
    .LAYOUT_ALIGN_START => .start,
    .LAYOUT_ALIGN_CENTER => .center,
    .LAYOUT_ALIGN_END => .end,
    _ => throw ArgumentError.value(v, 'v', 'Unknown LayoutAlign'),
  },
  encoder: (v) => switch (v) {
    .start => .LAYOUT_ALIGN_START,
    .center => .LAYOUT_ALIGN_CENTER,
    .end => .LAYOUT_ALIGN_END,
  },
);

// dart format off
extension _LayoutJustifyEncode on LayoutJustify { pb.LayoutJustify encode() => _layoutJustifyCodec.encode(this); }
extension _LayoutJustifyDecode on pb.LayoutJustify { LayoutJustify decode() => _layoutJustifyCodec.decode(this); }
// dart format on

final _layoutJustifyCodec = _codec<LayoutJustify, pb.LayoutJustify>(
  decoder: (v) => switch (v) {
    .LAYOUT_JUSTIFY_START => .start,
    .LAYOUT_JUSTIFY_CENTER => .center,
    .LAYOUT_JUSTIFY_END => .end,
    .LAYOUT_JUSTIFY_SPACE_BETWEEN => .spaceBetween,
    _ => throw ArgumentError.value(v, 'v', 'Unknown LayoutJustify'),
  },
  encoder: (v) => switch (v) {
    .start => .LAYOUT_JUSTIFY_START,
    .center => .LAYOUT_JUSTIFY_CENTER,
    .end => .LAYOUT_JUSTIFY_END,
    .spaceBetween => .LAYOUT_JUSTIFY_SPACE_BETWEEN,
  },
);

// dart format off
extension _FlexDirectionEncode on FlexDirection { pb.FlexDirection encode() => _flexDirectionCodec.encode(this); }
extension _FlexDirectionDecode on pb.FlexDirection { FlexDirection decode() => _flexDirectionCodec.decode(this); }
// dart format on

final _flexDirectionCodec = _codec<FlexDirection, pb.FlexDirection>(
  decoder: (v) => switch (v) {
    .FLEX_DIRECTION_ROW => .row,
    .FLEX_DIRECTION_COLUMN => .column,
    _ => throw ArgumentError.value(v, 'v', 'Unknown FlexDirection'),
  },
  encoder: (v) => switch (v) {
    .row => .FLEX_DIRECTION_ROW,
    .column => .FLEX_DIRECTION_COLUMN,
  },
);

// dart format off
extension _StackChildLayoutEncode on StackChildLayout { pb.StackChildLayout encode() => _stackChildLayoutCodec.encode(this); }
extension _StackChildLayoutDecode on pb.StackChildLayout { StackChildLayout decode() => _stackChildLayoutCodec.decode(this); }
// dart format on

final _stackChildLayoutCodec = _codec<StackChildLayout, pb.StackChildLayout>(
  decoder: (v) => .new(
    alignHorizontal: v.hasAlignHorizontal() ? v.alignHorizontal.decode() : null,
    alignVertical: v.hasAlignVertical() ? v.alignVertical.decode() : null,
    padding: v.padding.decode(),
  ),
  encoder: (v) => .new(
    alignHorizontal: v.alignHorizontal?.encode(),
    alignVertical: v.alignVertical?.encode(),
    padding: v.padding.encode(),
  ),
);

// dart format off
extension _FlexChildLayoutEncode on FlexChildLayout { pb.FlexChildLayout encode() => _flexChildLayoutCodec.encode(this); }
extension _FlexChildLayoutDecode on pb.FlexChildLayout { FlexChildLayout decode() => _flexChildLayoutCodec.decode(this); }
// dart format on

final _flexChildLayoutCodec = _codec<FlexChildLayout, pb.FlexChildLayout>(
  decoder: (v) => .new(
    direction: v.direction.decode(),
    justify: v.justify.decode(),
    crossAlign: v.crossAlign.decode(),
    padding: v.padding.decode(),
    gap: v.gap,
  ),
  encoder: (v) => .new(
    direction: v.direction.encode(),
    justify: v.justify.encode(),
    crossAlign: v.crossAlign.encode(),
    padding: v.padding.encode(),
    gap: v.gap,
  ),
);

// dart format off
extension _ChildLayoutEncode on ChildLayout { pb.ChildLayout encode() => _childLayoutCodec.encode(this); }
extension _ChildLayoutDecode on pb.ChildLayout { ChildLayout decode() => _childLayoutCodec.decode(this); }
// dart format on

final _childLayoutCodec = _codec<ChildLayout, pb.ChildLayout>(
  decoder: (v) => switch (v.whichLayout()) {
    .stack => v.stack.decode(),
    .flex => v.flex.decode(),
    _ => throw ArgumentError.value(v, 'v', 'Unknown ChildLayout'),
  },
  encoder: (v) => switch (v) {
    StackChildLayout s => .new(stack: s.encode()),
    FlexChildLayout f => .new(flex: f.encode()),
  },
);
