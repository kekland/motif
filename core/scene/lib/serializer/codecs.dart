part of 'serializer.dart';

final _sceneCodec = _codec<Scene, pb.Scene>(
  decoder: (v) => .new(
    program: _programCodec.decode(v.program),
  ),
  encoder: (v) => .new(
    program: _programCodec.encode(v.program),
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

final _statementCodec = _codec<Statement, pb.Statement>(
  decoder: (v) => switch (v.whichStatement()) {
    .frame => _frameStatementCodec.decode(v.frame),
    .vertex => _vertexStatementCodec.decode(v.vertex),
    .edge => _edgeStatementCodec.decode(v.edge),
    .face => _faceStatementCodec.decode(v.face),
    .rectangle => _rectangleStatementCodec.decode(v.rectangle),
    .container => _containerStatementCodec.decode(v.container),
    .cutEdge => _cutEdgeStatementCodec.decode(v.cutEdge),
    .glueVertices => _glueVerticesStatementCodec.decode(v.glueVertices),
    _ => throw ArgumentError.value(v, 'v', 'unknown statement'),
  },
  encoder: (v) => switch (v) {
    ContainerStatement s => .new(container: _containerStatementCodec.encode(s)),
    RectangleStatement s => .new(rectangle: _rectangleStatementCodec.encode(s)),
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
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    start: v.start.ref.encode(),
    end: v.end.ref.encode(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _faceStatementCodec = _codec<FaceStatement, pb.FaceStatement>(
  decoder: (v) => .new(
    v.outer.decode(),
    holes: v.holes.map((c) => c.decode()).toList(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    outer: v.outer.map((a) => a.ref).encode(),
    holes: v.holes.map((a) => a.map((e) => e.ref).encode()).toList(),
    id: v.id.encode(),
    parent: v.parent?.ref.encode(),
  ),
);

final _rectangleStatementCodec = _codec<RectangleStatement, pb.RectangleStatement>(
  decoder: (v) => .new(
    transform: v.transform.decode(),
    size: v.size.decode(),
    shape: v.shape.decode(),
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    shape: v.shape.encode(),
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
    id: v.id.decode(),
    parent: v.hasParent() ? v.parent.decode().cast() : null,
  ),
  encoder: (v) => .new(
    transform: v.transform.encode(),
    size: v.size.encode(),
    // shape: v.shape.encode(),
    childLayout: v.childLayout.encode(),
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
extension _RefEncode on Ref { pb.Ref encode() => _refCodec.encode(this); }
extension _RefDecode on pb.Ref { Ref decode() => _refCodec.decode(this); }
extension _RefListEncode on Iterable<Ref> { List<pb.Ref> encode() => map((e) => e.encode()).toList(); }
extension _RefListDecode on Iterable<pb.Ref> { List<Ref> decode() => map((e) => e.decode()).toList(); }
// dart format on

final _refCodec = _codec<Ref, pb.Ref>(
  decoder: (v) => .new(_statementIdCodec.decode(v.id), Symbol(v.product), .face), // TODO fix
  encoder: (v) => .new(id: _statementIdCodec.encode(v.statement), product: v.product.name),
);

// dart format off
extension _FaceCycleEncode on Iterable<EdgeRef> { pb.FaceStatement_Cycle encode() => _faceCycleCodec.encode(toList()); }
extension _FaceCycleDecode on pb.FaceStatement_Cycle { List<EdgeRef> decode() => _faceCycleCodec.decode(this); }
// dart format on

final _faceCycleCodec = _codec<List<EdgeRef>, pb.FaceStatement_Cycle>(
  decoder: (v) => v.edges.map((e) => e.decode().cast<EdgeHandle>()).toList(),
  encoder: (v) => .new(edges: v.map((e) => e.encode()).toList()),
);

// dart format off
extension _LayoutDimensionTypeEncode on LayoutDimensionType { pb.LayoutDimensionType encode() => _layoutDimensionTypeCodec.encode(this); }
extension _LayoutDimensionTypeDecode on pb.LayoutDimensionType { LayoutDimensionType decode() => _layoutDimensionTypeCodec.decode(this); }
// dart format on

final _layoutDimensionTypeCodec = _codec<LayoutDimensionType, pb.LayoutDimensionType>(
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
    v.value,
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
