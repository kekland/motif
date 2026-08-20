// This is a generated file - do not edit.
//
// Generated from scene.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'scene.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'scene.pbenum.dart';

class Scene extends $pb.GeneratedMessage {
  factory Scene({
    Program? program,
  }) {
    final result = create();
    if (program != null) result.program = program;
    return result;
  }

  Scene._();

  factory Scene.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Scene.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Scene',
      createEmptyInstance: create)
    ..aOM<Program>(1, _omitFieldNames ? '' : 'program',
        subBuilder: Program.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scene clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scene copyWith(void Function(Scene) updates) =>
      super.copyWith((message) => updates(message as Scene)) as Scene;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Scene create() => Scene._();
  @$core.override
  Scene createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Scene getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Scene>(create);
  static Scene? _defaultInstance;

  @$pb.TagNumber(1)
  Program get program => $_getN(0);
  @$pb.TagNumber(1)
  set program(Program value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgram() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgram() => $_clearField(1);
  @$pb.TagNumber(1)
  Program ensureProgram() => $_ensure(0);
}

class Program extends $pb.GeneratedMessage {
  factory Program({
    $core.Iterable<Statement>? statements,
  }) {
    final result = create();
    if (statements != null) result.statements.addAll(statements);
    return result;
  }

  Program._();

  factory Program.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Program.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Program',
      createEmptyInstance: create)
    ..pPM<Statement>(1, _omitFieldNames ? '' : 'statements',
        subBuilder: Statement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Program clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Program copyWith(void Function(Program) updates) =>
      super.copyWith((message) => updates(message as Program)) as Program;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Program create() => Program._();
  @$core.override
  Program createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Program getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Program>(create);
  static Program? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Statement> get statements => $_getList(0);
}

enum Statement_Statement {
  frame,
  vertex,
  edge,
  face,
  cutEdge,
  glueVertices,
  circle,
  rectangle,
  triangle,
  container,
  notSet
}

class Statement extends $pb.GeneratedMessage {
  factory Statement({
    FrameStatement? frame,
    VertexStatement? vertex,
    EdgeStatement? edge,
    FaceStatement? face,
    CutEdgeStatement? cutEdge,
    GlueVerticesStatement? glueVertices,
    CircleStatement? circle,
    RectangleStatement? rectangle,
    TriangleStatement? triangle,
    ContainerStatement? container,
  }) {
    final result = create();
    if (frame != null) result.frame = frame;
    if (vertex != null) result.vertex = vertex;
    if (edge != null) result.edge = edge;
    if (face != null) result.face = face;
    if (cutEdge != null) result.cutEdge = cutEdge;
    if (glueVertices != null) result.glueVertices = glueVertices;
    if (circle != null) result.circle = circle;
    if (rectangle != null) result.rectangle = rectangle;
    if (triangle != null) result.triangle = triangle;
    if (container != null) result.container = container;
    return result;
  }

  Statement._();

  factory Statement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Statement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Statement_Statement>
      _Statement_StatementByTag = {
    1: Statement_Statement.frame,
    2: Statement_Statement.vertex,
    3: Statement_Statement.edge,
    4: Statement_Statement.face,
    5: Statement_Statement.cutEdge,
    6: Statement_Statement.glueVertices,
    7: Statement_Statement.circle,
    8: Statement_Statement.rectangle,
    9: Statement_Statement.triangle,
    10: Statement_Statement.container,
    0: Statement_Statement.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Statement',
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOM<FrameStatement>(1, _omitFieldNames ? '' : 'frame',
        subBuilder: FrameStatement.create)
    ..aOM<VertexStatement>(2, _omitFieldNames ? '' : 'vertex',
        subBuilder: VertexStatement.create)
    ..aOM<EdgeStatement>(3, _omitFieldNames ? '' : 'edge',
        subBuilder: EdgeStatement.create)
    ..aOM<FaceStatement>(4, _omitFieldNames ? '' : 'face',
        subBuilder: FaceStatement.create)
    ..aOM<CutEdgeStatement>(5, _omitFieldNames ? '' : 'cutEdge',
        protoName: 'cutEdge', subBuilder: CutEdgeStatement.create)
    ..aOM<GlueVerticesStatement>(6, _omitFieldNames ? '' : 'glueVertices',
        protoName: 'glueVertices', subBuilder: GlueVerticesStatement.create)
    ..aOM<CircleStatement>(7, _omitFieldNames ? '' : 'circle',
        subBuilder: CircleStatement.create)
    ..aOM<RectangleStatement>(8, _omitFieldNames ? '' : 'rectangle',
        subBuilder: RectangleStatement.create)
    ..aOM<TriangleStatement>(9, _omitFieldNames ? '' : 'triangle',
        subBuilder: TriangleStatement.create)
    ..aOM<ContainerStatement>(10, _omitFieldNames ? '' : 'container',
        subBuilder: ContainerStatement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Statement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Statement copyWith(void Function(Statement) updates) =>
      super.copyWith((message) => updates(message as Statement)) as Statement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Statement create() => Statement._();
  @$core.override
  Statement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Statement getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Statement>(create);
  static Statement? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  Statement_Statement whichStatement() =>
      _Statement_StatementByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  void clearStatement() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  FrameStatement get frame => $_getN(0);
  @$pb.TagNumber(1)
  set frame(FrameStatement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrame() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrame() => $_clearField(1);
  @$pb.TagNumber(1)
  FrameStatement ensureFrame() => $_ensure(0);

  @$pb.TagNumber(2)
  VertexStatement get vertex => $_getN(1);
  @$pb.TagNumber(2)
  set vertex(VertexStatement value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVertex() => $_has(1);
  @$pb.TagNumber(2)
  void clearVertex() => $_clearField(2);
  @$pb.TagNumber(2)
  VertexStatement ensureVertex() => $_ensure(1);

  @$pb.TagNumber(3)
  EdgeStatement get edge => $_getN(2);
  @$pb.TagNumber(3)
  set edge(EdgeStatement value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEdge() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdge() => $_clearField(3);
  @$pb.TagNumber(3)
  EdgeStatement ensureEdge() => $_ensure(2);

  @$pb.TagNumber(4)
  FaceStatement get face => $_getN(3);
  @$pb.TagNumber(4)
  set face(FaceStatement value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);
  @$pb.TagNumber(4)
  FaceStatement ensureFace() => $_ensure(3);

  @$pb.TagNumber(5)
  CutEdgeStatement get cutEdge => $_getN(4);
  @$pb.TagNumber(5)
  set cutEdge(CutEdgeStatement value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCutEdge() => $_has(4);
  @$pb.TagNumber(5)
  void clearCutEdge() => $_clearField(5);
  @$pb.TagNumber(5)
  CutEdgeStatement ensureCutEdge() => $_ensure(4);

  @$pb.TagNumber(6)
  GlueVerticesStatement get glueVertices => $_getN(5);
  @$pb.TagNumber(6)
  set glueVertices(GlueVerticesStatement value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGlueVertices() => $_has(5);
  @$pb.TagNumber(6)
  void clearGlueVertices() => $_clearField(6);
  @$pb.TagNumber(6)
  GlueVerticesStatement ensureGlueVertices() => $_ensure(5);

  @$pb.TagNumber(7)
  CircleStatement get circle => $_getN(6);
  @$pb.TagNumber(7)
  set circle(CircleStatement value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCircle() => $_has(6);
  @$pb.TagNumber(7)
  void clearCircle() => $_clearField(7);
  @$pb.TagNumber(7)
  CircleStatement ensureCircle() => $_ensure(6);

  @$pb.TagNumber(8)
  RectangleStatement get rectangle => $_getN(7);
  @$pb.TagNumber(8)
  set rectangle(RectangleStatement value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRectangle() => $_has(7);
  @$pb.TagNumber(8)
  void clearRectangle() => $_clearField(8);
  @$pb.TagNumber(8)
  RectangleStatement ensureRectangle() => $_ensure(7);

  @$pb.TagNumber(9)
  TriangleStatement get triangle => $_getN(8);
  @$pb.TagNumber(9)
  set triangle(TriangleStatement value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTriangle() => $_has(8);
  @$pb.TagNumber(9)
  void clearTriangle() => $_clearField(9);
  @$pb.TagNumber(9)
  TriangleStatement ensureTriangle() => $_ensure(8);

  @$pb.TagNumber(10)
  ContainerStatement get container => $_getN(9);
  @$pb.TagNumber(10)
  set container(ContainerStatement value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasContainer() => $_has(9);
  @$pb.TagNumber(10)
  void clearContainer() => $_clearField(10);
  @$pb.TagNumber(10)
  ContainerStatement ensureContainer() => $_ensure(9);
}

class FrameStatement extends $pb.GeneratedMessage {
  factory FrameStatement({
    StatementId? id,
    Ref? parent,
    Mat4? transform,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    return result;
  }

  FrameStatement._();

  factory FrameStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FrameStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FrameStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FrameStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FrameStatement copyWith(void Function(FrameStatement) updates) =>
      super.copyWith((message) => updates(message as FrameStatement))
          as FrameStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FrameStatement create() => FrameStatement._();
  @$core.override
  FrameStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FrameStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FrameStatement>(create);
  static FrameStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Mat4 get transform => $_getN(2);
  @$pb.TagNumber(3)
  set transform(Mat4 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTransform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransform() => $_clearField(3);
  @$pb.TagNumber(3)
  Mat4 ensureTransform() => $_ensure(2);
}

class VertexStatement extends $pb.GeneratedMessage {
  factory VertexStatement({
    StatementId? id,
    Ref? parent,
    Vec2? position,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (position != null) result.position = position;
    return result;
  }

  VertexStatement._();

  factory VertexStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VertexStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VertexStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Vec2>(3, _omitFieldNames ? '' : 'position', subBuilder: Vec2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStatement copyWith(void Function(VertexStatement) updates) =>
      super.copyWith((message) => updates(message as VertexStatement))
          as VertexStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VertexStatement create() => VertexStatement._();
  @$core.override
  VertexStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VertexStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VertexStatement>(create);
  static VertexStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Vec2 get position => $_getN(2);
  @$pb.TagNumber(3)
  set position(Vec2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);
  @$pb.TagNumber(3)
  Vec2 ensurePosition() => $_ensure(2);
}

class EdgeStatement extends $pb.GeneratedMessage {
  factory EdgeStatement({
    StatementId? id,
    Ref? parent,
    Ref? start,
    Ref? end,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (startTangent != null) result.startTangent = startTangent;
    if (endTangent != null) result.endTangent = endTangent;
    if (style != null) result.style = style;
    return result;
  }

  EdgeStatement._();

  factory EdgeStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EdgeStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EdgeStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Ref>(3, _omitFieldNames ? '' : 'start', subBuilder: Ref.create)
    ..aOM<Ref>(4, _omitFieldNames ? '' : 'end', subBuilder: Ref.create)
    ..aOM<Vec2>(5, _omitFieldNames ? '' : 'startTangent',
        protoName: 'startTangent', subBuilder: Vec2.create)
    ..aOM<Vec2>(6, _omitFieldNames ? '' : 'endTangent',
        protoName: 'endTangent', subBuilder: Vec2.create)
    ..aOM<EdgeStyle>(7, _omitFieldNames ? '' : 'style',
        subBuilder: EdgeStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStatement copyWith(void Function(EdgeStatement) updates) =>
      super.copyWith((message) => updates(message as EdgeStatement))
          as EdgeStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EdgeStatement create() => EdgeStatement._();
  @$core.override
  EdgeStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EdgeStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EdgeStatement>(create);
  static EdgeStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Ref get start => $_getN(2);
  @$pb.TagNumber(3)
  set start(Ref value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearStart() => $_clearField(3);
  @$pb.TagNumber(3)
  Ref ensureStart() => $_ensure(2);

  @$pb.TagNumber(4)
  Ref get end => $_getN(3);
  @$pb.TagNumber(4)
  set end(Ref value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  Ref ensureEnd() => $_ensure(3);

  @$pb.TagNumber(5)
  Vec2 get startTangent => $_getN(4);
  @$pb.TagNumber(5)
  set startTangent(Vec2 value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStartTangent() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartTangent() => $_clearField(5);
  @$pb.TagNumber(5)
  Vec2 ensureStartTangent() => $_ensure(4);

  @$pb.TagNumber(6)
  Vec2 get endTangent => $_getN(5);
  @$pb.TagNumber(6)
  set endTangent(Vec2 value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndTangent() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndTangent() => $_clearField(6);
  @$pb.TagNumber(6)
  Vec2 ensureEndTangent() => $_ensure(5);

  @$pb.TagNumber(7)
  EdgeStyle get style => $_getN(6);
  @$pb.TagNumber(7)
  set style(EdgeStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  EdgeStyle ensureStyle() => $_ensure(6);
}

class FaceStatement_Cycle extends $pb.GeneratedMessage {
  factory FaceStatement_Cycle({
    $core.Iterable<Ref>? edges,
  }) {
    final result = create();
    if (edges != null) result.edges.addAll(edges);
    return result;
  }

  FaceStatement_Cycle._();

  factory FaceStatement_Cycle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FaceStatement_Cycle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaceStatement.Cycle',
      createEmptyInstance: create)
    ..pPM<Ref>(1, _omitFieldNames ? '' : 'edges', subBuilder: Ref.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStatement_Cycle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStatement_Cycle copyWith(void Function(FaceStatement_Cycle) updates) =>
      super.copyWith((message) => updates(message as FaceStatement_Cycle))
          as FaceStatement_Cycle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaceStatement_Cycle create() => FaceStatement_Cycle._();
  @$core.override
  FaceStatement_Cycle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FaceStatement_Cycle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FaceStatement_Cycle>(create);
  static FaceStatement_Cycle? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Ref> get edges => $_getList(0);
}

class FaceStatement extends $pb.GeneratedMessage {
  factory FaceStatement({
    StatementId? id,
    Ref? parent,
    FaceStatement_Cycle? outer,
    $core.Iterable<FaceStatement_Cycle>? holes,
    FaceStyle? style,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (outer != null) result.outer = outer;
    if (holes != null) result.holes.addAll(holes);
    if (style != null) result.style = style;
    return result;
  }

  FaceStatement._();

  factory FaceStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FaceStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaceStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<FaceStatement_Cycle>(3, _omitFieldNames ? '' : 'outer',
        subBuilder: FaceStatement_Cycle.create)
    ..pPM<FaceStatement_Cycle>(4, _omitFieldNames ? '' : 'holes',
        subBuilder: FaceStatement_Cycle.create)
    ..aOM<FaceStyle>(5, _omitFieldNames ? '' : 'style',
        subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStatement copyWith(void Function(FaceStatement) updates) =>
      super.copyWith((message) => updates(message as FaceStatement))
          as FaceStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaceStatement create() => FaceStatement._();
  @$core.override
  FaceStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FaceStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FaceStatement>(create);
  static FaceStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  FaceStatement_Cycle get outer => $_getN(2);
  @$pb.TagNumber(3)
  set outer(FaceStatement_Cycle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOuter() => $_has(2);
  @$pb.TagNumber(3)
  void clearOuter() => $_clearField(3);
  @$pb.TagNumber(3)
  FaceStatement_Cycle ensureOuter() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<FaceStatement_Cycle> get holes => $_getList(3);

  @$pb.TagNumber(5)
  FaceStyle get style => $_getN(4);
  @$pb.TagNumber(5)
  set style(FaceStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  FaceStyle ensureStyle() => $_ensure(4);
}

class CutEdgeStatement extends $pb.GeneratedMessage {
  factory CutEdgeStatement({
    StatementId? id,
    Ref? target,
    $core.double? t,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (target != null) result.target = target;
    if (t != null) result.t = t;
    return result;
  }

  CutEdgeStatement._();

  factory CutEdgeStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CutEdgeStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CutEdgeStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'target', subBuilder: Ref.create)
    ..aD(3, _omitFieldNames ? '' : 't')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CutEdgeStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CutEdgeStatement copyWith(void Function(CutEdgeStatement) updates) =>
      super.copyWith((message) => updates(message as CutEdgeStatement))
          as CutEdgeStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CutEdgeStatement create() => CutEdgeStatement._();
  @$core.override
  CutEdgeStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CutEdgeStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CutEdgeStatement>(create);
  static CutEdgeStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get target => $_getN(1);
  @$pb.TagNumber(2)
  set target(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTarget() => $_has(1);
  @$pb.TagNumber(2)
  void clearTarget() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureTarget() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get t => $_getN(2);
  @$pb.TagNumber(3)
  set t($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasT() => $_has(2);
  @$pb.TagNumber(3)
  void clearT() => $_clearField(3);
}

class GlueVerticesStatement extends $pb.GeneratedMessage {
  factory GlueVerticesStatement({
    StatementId? id,
    $core.Iterable<Ref>? targets,
    GlueVerticesStatement_Position? position,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (targets != null) result.targets.addAll(targets);
    if (position != null) result.position = position;
    return result;
  }

  GlueVerticesStatement._();

  factory GlueVerticesStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GlueVerticesStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GlueVerticesStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..pPM<Ref>(2, _omitFieldNames ? '' : 'targets', subBuilder: Ref.create)
    ..aE<GlueVerticesStatement_Position>(3, _omitFieldNames ? '' : 'position',
        enumValues: GlueVerticesStatement_Position.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GlueVerticesStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GlueVerticesStatement copyWith(
          void Function(GlueVerticesStatement) updates) =>
      super.copyWith((message) => updates(message as GlueVerticesStatement))
          as GlueVerticesStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GlueVerticesStatement create() => GlueVerticesStatement._();
  @$core.override
  GlueVerticesStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GlueVerticesStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GlueVerticesStatement>(create);
  static GlueVerticesStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Ref> get targets => $_getList(1);

  @$pb.TagNumber(3)
  GlueVerticesStatement_Position get position => $_getN(2);
  @$pb.TagNumber(3)
  set position(GlueVerticesStatement_Position value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => $_clearField(3);
}

class CircleStatement extends $pb.GeneratedMessage {
  factory CircleStatement({
    StatementId? id,
    Ref? parent,
    Mat4? transform,
    LayoutSize? size,
    CircleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    if (size != null) result.size = size;
    if (shape != null) result.shape = shape;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    return result;
  }

  CircleStatement._();

  factory CircleStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CircleStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CircleStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<LayoutSize>(4, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<CircleObjectShape>(5, _omitFieldNames ? '' : 'shape',
        subBuilder: CircleObjectShape.create)
    ..aOM<EdgeStyle>(6, _omitFieldNames ? '' : 'edgeStyle',
        protoName: 'edgeStyle', subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(7, _omitFieldNames ? '' : 'faceStyle',
        protoName: 'faceStyle', subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CircleStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CircleStatement copyWith(void Function(CircleStatement) updates) =>
      super.copyWith((message) => updates(message as CircleStatement))
          as CircleStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CircleStatement create() => CircleStatement._();
  @$core.override
  CircleStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CircleStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CircleStatement>(create);
  static CircleStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Mat4 get transform => $_getN(2);
  @$pb.TagNumber(3)
  set transform(Mat4 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTransform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransform() => $_clearField(3);
  @$pb.TagNumber(3)
  Mat4 ensureTransform() => $_ensure(2);

  @$pb.TagNumber(4)
  LayoutSize get size => $_getN(3);
  @$pb.TagNumber(4)
  set size(LayoutSize value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);
  @$pb.TagNumber(4)
  LayoutSize ensureSize() => $_ensure(3);

  @$pb.TagNumber(5)
  CircleObjectShape get shape => $_getN(4);
  @$pb.TagNumber(5)
  set shape(CircleObjectShape value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasShape() => $_has(4);
  @$pb.TagNumber(5)
  void clearShape() => $_clearField(5);
  @$pb.TagNumber(5)
  CircleObjectShape ensureShape() => $_ensure(4);

  @$pb.TagNumber(6)
  EdgeStyle get edgeStyle => $_getN(5);
  @$pb.TagNumber(6)
  set edgeStyle(EdgeStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEdgeStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearEdgeStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  EdgeStyle ensureEdgeStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  FaceStyle get faceStyle => $_getN(6);
  @$pb.TagNumber(7)
  set faceStyle(FaceStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFaceStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearFaceStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  FaceStyle ensureFaceStyle() => $_ensure(6);
}

class RectangleStatement extends $pb.GeneratedMessage {
  factory RectangleStatement({
    StatementId? id,
    Ref? parent,
    Mat4? transform,
    LayoutSize? size,
    RectangleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    if (size != null) result.size = size;
    if (shape != null) result.shape = shape;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    return result;
  }

  RectangleStatement._();

  factory RectangleStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RectangleStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RectangleStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<LayoutSize>(4, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<RectangleObjectShape>(5, _omitFieldNames ? '' : 'shape',
        subBuilder: RectangleObjectShape.create)
    ..aOM<EdgeStyle>(6, _omitFieldNames ? '' : 'edgeStyle',
        protoName: 'edgeStyle', subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(7, _omitFieldNames ? '' : 'faceStyle',
        protoName: 'faceStyle', subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RectangleStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RectangleStatement copyWith(void Function(RectangleStatement) updates) =>
      super.copyWith((message) => updates(message as RectangleStatement))
          as RectangleStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RectangleStatement create() => RectangleStatement._();
  @$core.override
  RectangleStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RectangleStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RectangleStatement>(create);
  static RectangleStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Mat4 get transform => $_getN(2);
  @$pb.TagNumber(3)
  set transform(Mat4 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTransform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransform() => $_clearField(3);
  @$pb.TagNumber(3)
  Mat4 ensureTransform() => $_ensure(2);

  @$pb.TagNumber(4)
  LayoutSize get size => $_getN(3);
  @$pb.TagNumber(4)
  set size(LayoutSize value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);
  @$pb.TagNumber(4)
  LayoutSize ensureSize() => $_ensure(3);

  @$pb.TagNumber(5)
  RectangleObjectShape get shape => $_getN(4);
  @$pb.TagNumber(5)
  set shape(RectangleObjectShape value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasShape() => $_has(4);
  @$pb.TagNumber(5)
  void clearShape() => $_clearField(5);
  @$pb.TagNumber(5)
  RectangleObjectShape ensureShape() => $_ensure(4);

  @$pb.TagNumber(6)
  EdgeStyle get edgeStyle => $_getN(5);
  @$pb.TagNumber(6)
  set edgeStyle(EdgeStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEdgeStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearEdgeStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  EdgeStyle ensureEdgeStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  FaceStyle get faceStyle => $_getN(6);
  @$pb.TagNumber(7)
  set faceStyle(FaceStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFaceStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearFaceStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  FaceStyle ensureFaceStyle() => $_ensure(6);
}

class TriangleStatement extends $pb.GeneratedMessage {
  factory TriangleStatement({
    StatementId? id,
    Ref? parent,
    Mat4? transform,
    LayoutSize? size,
    TriangleObjectShape? shape,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    if (size != null) result.size = size;
    if (shape != null) result.shape = shape;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    return result;
  }

  TriangleStatement._();

  factory TriangleStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriangleStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriangleStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<LayoutSize>(4, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<TriangleObjectShape>(5, _omitFieldNames ? '' : 'shape',
        subBuilder: TriangleObjectShape.create)
    ..aOM<EdgeStyle>(6, _omitFieldNames ? '' : 'edgeStyle',
        protoName: 'edgeStyle', subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(7, _omitFieldNames ? '' : 'faceStyle',
        protoName: 'faceStyle', subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriangleStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriangleStatement copyWith(void Function(TriangleStatement) updates) =>
      super.copyWith((message) => updates(message as TriangleStatement))
          as TriangleStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriangleStatement create() => TriangleStatement._();
  @$core.override
  TriangleStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TriangleStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriangleStatement>(create);
  static TriangleStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Mat4 get transform => $_getN(2);
  @$pb.TagNumber(3)
  set transform(Mat4 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTransform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransform() => $_clearField(3);
  @$pb.TagNumber(3)
  Mat4 ensureTransform() => $_ensure(2);

  @$pb.TagNumber(4)
  LayoutSize get size => $_getN(3);
  @$pb.TagNumber(4)
  set size(LayoutSize value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);
  @$pb.TagNumber(4)
  LayoutSize ensureSize() => $_ensure(3);

  @$pb.TagNumber(5)
  TriangleObjectShape get shape => $_getN(4);
  @$pb.TagNumber(5)
  set shape(TriangleObjectShape value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasShape() => $_has(4);
  @$pb.TagNumber(5)
  void clearShape() => $_clearField(5);
  @$pb.TagNumber(5)
  TriangleObjectShape ensureShape() => $_ensure(4);

  @$pb.TagNumber(6)
  EdgeStyle get edgeStyle => $_getN(5);
  @$pb.TagNumber(6)
  set edgeStyle(EdgeStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEdgeStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearEdgeStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  EdgeStyle ensureEdgeStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  FaceStyle get faceStyle => $_getN(6);
  @$pb.TagNumber(7)
  set faceStyle(FaceStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFaceStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearFaceStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  FaceStyle ensureFaceStyle() => $_ensure(6);
}

class ContainerStatement extends $pb.GeneratedMessage {
  factory ContainerStatement({
    StatementId? id,
    Ref? parent,
    Mat4? transform,
    LayoutSize? size,
    ObjectShape? shape,
    ChildLayout? childLayout,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    if (size != null) result.size = size;
    if (shape != null) result.shape = shape;
    if (childLayout != null) result.childLayout = childLayout;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    return result;
  }

  ContainerStatement._();

  factory ContainerStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContainerStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContainerStatement',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOM<Ref>(2, _omitFieldNames ? '' : 'parent', subBuilder: Ref.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<LayoutSize>(4, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<ObjectShape>(5, _omitFieldNames ? '' : 'shape',
        subBuilder: ObjectShape.create)
    ..aOM<ChildLayout>(6, _omitFieldNames ? '' : 'childLayout',
        protoName: 'childLayout', subBuilder: ChildLayout.create)
    ..aOM<EdgeStyle>(7, _omitFieldNames ? '' : 'edgeStyle',
        protoName: 'edgeStyle', subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(8, _omitFieldNames ? '' : 'faceStyle',
        protoName: 'faceStyle', subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContainerStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContainerStatement copyWith(void Function(ContainerStatement) updates) =>
      super.copyWith((message) => updates(message as ContainerStatement))
          as ContainerStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContainerStatement create() => ContainerStatement._();
  @$core.override
  ContainerStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContainerStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContainerStatement>(create);
  static ContainerStatement? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  Ref get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(Ref value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  Ref ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  Mat4 get transform => $_getN(2);
  @$pb.TagNumber(3)
  set transform(Mat4 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTransform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransform() => $_clearField(3);
  @$pb.TagNumber(3)
  Mat4 ensureTransform() => $_ensure(2);

  @$pb.TagNumber(4)
  LayoutSize get size => $_getN(3);
  @$pb.TagNumber(4)
  set size(LayoutSize value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);
  @$pb.TagNumber(4)
  LayoutSize ensureSize() => $_ensure(3);

  @$pb.TagNumber(5)
  ObjectShape get shape => $_getN(4);
  @$pb.TagNumber(5)
  set shape(ObjectShape value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasShape() => $_has(4);
  @$pb.TagNumber(5)
  void clearShape() => $_clearField(5);
  @$pb.TagNumber(5)
  ObjectShape ensureShape() => $_ensure(4);

  @$pb.TagNumber(6)
  ChildLayout get childLayout => $_getN(5);
  @$pb.TagNumber(6)
  set childLayout(ChildLayout value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasChildLayout() => $_has(5);
  @$pb.TagNumber(6)
  void clearChildLayout() => $_clearField(6);
  @$pb.TagNumber(6)
  ChildLayout ensureChildLayout() => $_ensure(5);

  @$pb.TagNumber(7)
  EdgeStyle get edgeStyle => $_getN(6);
  @$pb.TagNumber(7)
  set edgeStyle(EdgeStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEdgeStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearEdgeStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  EdgeStyle ensureEdgeStyle() => $_ensure(6);

  @$pb.TagNumber(8)
  FaceStyle get faceStyle => $_getN(7);
  @$pb.TagNumber(8)
  set faceStyle(FaceStyle value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFaceStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearFaceStyle() => $_clearField(8);
  @$pb.TagNumber(8)
  FaceStyle ensureFaceStyle() => $_ensure(7);
}

class StatementId extends $pb.GeneratedMessage {
  factory StatementId({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  StatementId._();

  factory StatementId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatementId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatementId',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementId copyWith(void Function(StatementId) updates) =>
      super.copyWith((message) => updates(message as StatementId))
          as StatementId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatementId create() => StatementId._();
  @$core.override
  StatementId createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatementId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatementId>(create);
  static StatementId? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class Vec2 extends $pb.GeneratedMessage {
  factory Vec2({
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  Vec2._();

  factory Vec2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vec2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vec2',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x')
    ..aD(2, _omitFieldNames ? '' : 'y')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vec2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vec2 copyWith(void Function(Vec2) updates) =>
      super.copyWith((message) => updates(message as Vec2)) as Vec2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vec2 create() => Vec2._();
  @$core.override
  Vec2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vec2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vec2>(create);
  static Vec2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

class Mat4 extends $pb.GeneratedMessage {
  factory Mat4({
    $core.Iterable<$core.double>? values,
  }) {
    final result = create();
    if (values != null) result.values.addAll(values);
    return result;
  }

  Mat4._();

  factory Mat4.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Mat4.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Mat4',
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mat4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mat4 copyWith(void Function(Mat4) updates) =>
      super.copyWith((message) => updates(message as Mat4)) as Mat4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Mat4 create() => Mat4._();
  @$core.override
  Mat4 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Mat4 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mat4>(create);
  static Mat4? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get values => $_getList(0);
}

class Ref extends $pb.GeneratedMessage {
  factory Ref({
    StatementId? id,
    $core.String? product,
    Ref_Kind? kind,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (product != null) result.product = product;
    if (kind != null) result.kind = kind;
    return result;
  }

  Ref._();

  factory Ref.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ref.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ref',
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aOS(2, _omitFieldNames ? '' : 'product')
    ..aE<Ref_Kind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: Ref_Kind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ref clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ref copyWith(void Function(Ref) updates) =>
      super.copyWith((message) => updates(message as Ref)) as Ref;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ref create() => Ref._();
  @$core.override
  Ref createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ref getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ref>(create);
  static Ref? _defaultInstance;

  @$pb.TagNumber(1)
  StatementId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(StatementId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get product => $_getSZ(1);
  @$pb.TagNumber(2)
  set product($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => $_clearField(2);

  @$pb.TagNumber(3)
  Ref_Kind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(Ref_Kind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);
}

class LayoutRange extends $pb.GeneratedMessage {
  factory LayoutRange({
    $core.double? min,
    $core.double? max,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  LayoutRange._();

  factory LayoutRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LayoutRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayoutRange',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min')
    ..aD(2, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutRange copyWith(void Function(LayoutRange) updates) =>
      super.copyWith((message) => updates(message as LayoutRange))
          as LayoutRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutRange create() => LayoutRange._();
  @$core.override
  LayoutRange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LayoutRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayoutRange>(create);
  static LayoutRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}

class LayoutDimension extends $pb.GeneratedMessage {
  factory LayoutDimension({
    $core.double? value,
    LayoutDimension_Type? type,
    LayoutRange? range,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (type != null) result.type = type;
    if (range != null) result.range = range;
    return result;
  }

  LayoutDimension._();

  factory LayoutDimension.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LayoutDimension.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayoutDimension',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aE<LayoutDimension_Type>(2, _omitFieldNames ? '' : 'type',
        enumValues: LayoutDimension_Type.values)
    ..aOM<LayoutRange>(3, _omitFieldNames ? '' : 'range',
        subBuilder: LayoutRange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutDimension clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutDimension copyWith(void Function(LayoutDimension) updates) =>
      super.copyWith((message) => updates(message as LayoutDimension))
          as LayoutDimension;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutDimension create() => LayoutDimension._();
  @$core.override
  LayoutDimension createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LayoutDimension getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayoutDimension>(create);
  static LayoutDimension? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  LayoutDimension_Type get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(LayoutDimension_Type value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  LayoutRange get range => $_getN(2);
  @$pb.TagNumber(3)
  set range(LayoutRange value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearRange() => $_clearField(3);
  @$pb.TagNumber(3)
  LayoutRange ensureRange() => $_ensure(2);
}

class LayoutSize extends $pb.GeneratedMessage {
  factory LayoutSize({
    LayoutDimension? width,
    LayoutDimension? height,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  LayoutSize._();

  factory LayoutSize.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LayoutSize.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayoutSize',
      createEmptyInstance: create)
    ..aOM<LayoutDimension>(1, _omitFieldNames ? '' : 'width',
        subBuilder: LayoutDimension.create)
    ..aOM<LayoutDimension>(2, _omitFieldNames ? '' : 'height',
        subBuilder: LayoutDimension.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutSize clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutSize copyWith(void Function(LayoutSize) updates) =>
      super.copyWith((message) => updates(message as LayoutSize)) as LayoutSize;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutSize create() => LayoutSize._();
  @$core.override
  LayoutSize createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LayoutSize getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayoutSize>(create);
  static LayoutSize? _defaultInstance;

  @$pb.TagNumber(1)
  LayoutDimension get width => $_getN(0);
  @$pb.TagNumber(1)
  set width(LayoutDimension value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);
  @$pb.TagNumber(1)
  LayoutDimension ensureWidth() => $_ensure(0);

  @$pb.TagNumber(2)
  LayoutDimension get height => $_getN(1);
  @$pb.TagNumber(2)
  set height(LayoutDimension value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);
  @$pb.TagNumber(2)
  LayoutDimension ensureHeight() => $_ensure(1);
}

class CornerRadius extends $pb.GeneratedMessage {
  factory CornerRadius({
    $core.double? x,
    $core.double? y,
  }) {
    final result = create();
    if (x != null) result.x = x;
    if (y != null) result.y = y;
    return result;
  }

  CornerRadius._();

  factory CornerRadius.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CornerRadius.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CornerRadius',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'x')
    ..aD(2, _omitFieldNames ? '' : 'y')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CornerRadius clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CornerRadius copyWith(void Function(CornerRadius) updates) =>
      super.copyWith((message) => updates(message as CornerRadius))
          as CornerRadius;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CornerRadius create() => CornerRadius._();
  @$core.override
  CornerRadius createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CornerRadius getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CornerRadius>(create);
  static CornerRadius? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

class CircleObjectShape extends $pb.GeneratedMessage {
  factory CircleObjectShape() => create();

  CircleObjectShape._();

  factory CircleObjectShape.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CircleObjectShape.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CircleObjectShape',
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CircleObjectShape clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CircleObjectShape copyWith(void Function(CircleObjectShape) updates) =>
      super.copyWith((message) => updates(message as CircleObjectShape))
          as CircleObjectShape;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CircleObjectShape create() => CircleObjectShape._();
  @$core.override
  CircleObjectShape createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CircleObjectShape getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CircleObjectShape>(create);
  static CircleObjectShape? _defaultInstance;
}

class RectangleObjectShape extends $pb.GeneratedMessage {
  factory RectangleObjectShape({
    CornerRadius? topLeftRadius,
    CornerRadius? topRightRadius,
    CornerRadius? bottomRightRadius,
    CornerRadius? bottomLeftRadius,
  }) {
    final result = create();
    if (topLeftRadius != null) result.topLeftRadius = topLeftRadius;
    if (topRightRadius != null) result.topRightRadius = topRightRadius;
    if (bottomRightRadius != null) result.bottomRightRadius = bottomRightRadius;
    if (bottomLeftRadius != null) result.bottomLeftRadius = bottomLeftRadius;
    return result;
  }

  RectangleObjectShape._();

  factory RectangleObjectShape.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RectangleObjectShape.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RectangleObjectShape',
      createEmptyInstance: create)
    ..aOM<CornerRadius>(1, _omitFieldNames ? '' : 'topLeftRadius',
        subBuilder: CornerRadius.create)
    ..aOM<CornerRadius>(2, _omitFieldNames ? '' : 'topRightRadius',
        subBuilder: CornerRadius.create)
    ..aOM<CornerRadius>(3, _omitFieldNames ? '' : 'bottomRightRadius',
        subBuilder: CornerRadius.create)
    ..aOM<CornerRadius>(4, _omitFieldNames ? '' : 'bottomLeftRadius',
        subBuilder: CornerRadius.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RectangleObjectShape clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RectangleObjectShape copyWith(void Function(RectangleObjectShape) updates) =>
      super.copyWith((message) => updates(message as RectangleObjectShape))
          as RectangleObjectShape;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RectangleObjectShape create() => RectangleObjectShape._();
  @$core.override
  RectangleObjectShape createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RectangleObjectShape getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RectangleObjectShape>(create);
  static RectangleObjectShape? _defaultInstance;

  @$pb.TagNumber(1)
  CornerRadius get topLeftRadius => $_getN(0);
  @$pb.TagNumber(1)
  set topLeftRadius(CornerRadius value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTopLeftRadius() => $_has(0);
  @$pb.TagNumber(1)
  void clearTopLeftRadius() => $_clearField(1);
  @$pb.TagNumber(1)
  CornerRadius ensureTopLeftRadius() => $_ensure(0);

  @$pb.TagNumber(2)
  CornerRadius get topRightRadius => $_getN(1);
  @$pb.TagNumber(2)
  set topRightRadius(CornerRadius value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTopRightRadius() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopRightRadius() => $_clearField(2);
  @$pb.TagNumber(2)
  CornerRadius ensureTopRightRadius() => $_ensure(1);

  @$pb.TagNumber(3)
  CornerRadius get bottomRightRadius => $_getN(2);
  @$pb.TagNumber(3)
  set bottomRightRadius(CornerRadius value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBottomRightRadius() => $_has(2);
  @$pb.TagNumber(3)
  void clearBottomRightRadius() => $_clearField(3);
  @$pb.TagNumber(3)
  CornerRadius ensureBottomRightRadius() => $_ensure(2);

  @$pb.TagNumber(4)
  CornerRadius get bottomLeftRadius => $_getN(3);
  @$pb.TagNumber(4)
  set bottomLeftRadius(CornerRadius value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBottomLeftRadius() => $_has(3);
  @$pb.TagNumber(4)
  void clearBottomLeftRadius() => $_clearField(4);
  @$pb.TagNumber(4)
  CornerRadius ensureBottomLeftRadius() => $_ensure(3);
}

class TriangleObjectShape extends $pb.GeneratedMessage {
  factory TriangleObjectShape() => create();

  TriangleObjectShape._();

  factory TriangleObjectShape.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriangleObjectShape.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriangleObjectShape',
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriangleObjectShape clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriangleObjectShape copyWith(void Function(TriangleObjectShape) updates) =>
      super.copyWith((message) => updates(message as TriangleObjectShape))
          as TriangleObjectShape;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriangleObjectShape create() => TriangleObjectShape._();
  @$core.override
  TriangleObjectShape createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TriangleObjectShape getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriangleObjectShape>(create);
  static TriangleObjectShape? _defaultInstance;
}

enum ObjectShape_Shape { circle, rectangle, triangle, notSet }

class ObjectShape extends $pb.GeneratedMessage {
  factory ObjectShape({
    CircleObjectShape? circle,
    RectangleObjectShape? rectangle,
    TriangleObjectShape? triangle,
  }) {
    final result = create();
    if (circle != null) result.circle = circle;
    if (rectangle != null) result.rectangle = rectangle;
    if (triangle != null) result.triangle = triangle;
    return result;
  }

  ObjectShape._();

  factory ObjectShape.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObjectShape.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ObjectShape_Shape> _ObjectShape_ShapeByTag =
      {
    1: ObjectShape_Shape.circle,
    2: ObjectShape_Shape.rectangle,
    3: ObjectShape_Shape.triangle,
    0: ObjectShape_Shape.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectShape',
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<CircleObjectShape>(1, _omitFieldNames ? '' : 'circle',
        subBuilder: CircleObjectShape.create)
    ..aOM<RectangleObjectShape>(2, _omitFieldNames ? '' : 'rectangle',
        subBuilder: RectangleObjectShape.create)
    ..aOM<TriangleObjectShape>(3, _omitFieldNames ? '' : 'triangle',
        subBuilder: TriangleObjectShape.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape copyWith(void Function(ObjectShape) updates) =>
      super.copyWith((message) => updates(message as ObjectShape))
          as ObjectShape;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectShape create() => ObjectShape._();
  @$core.override
  ObjectShape createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObjectShape getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObjectShape>(create);
  static ObjectShape? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ObjectShape_Shape whichShape() => _ObjectShape_ShapeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearShape() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CircleObjectShape get circle => $_getN(0);
  @$pb.TagNumber(1)
  set circle(CircleObjectShape value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCircle() => $_has(0);
  @$pb.TagNumber(1)
  void clearCircle() => $_clearField(1);
  @$pb.TagNumber(1)
  CircleObjectShape ensureCircle() => $_ensure(0);

  @$pb.TagNumber(2)
  RectangleObjectShape get rectangle => $_getN(1);
  @$pb.TagNumber(2)
  set rectangle(RectangleObjectShape value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRectangle() => $_has(1);
  @$pb.TagNumber(2)
  void clearRectangle() => $_clearField(2);
  @$pb.TagNumber(2)
  RectangleObjectShape ensureRectangle() => $_ensure(1);

  @$pb.TagNumber(3)
  TriangleObjectShape get triangle => $_getN(2);
  @$pb.TagNumber(3)
  set triangle(TriangleObjectShape value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTriangle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTriangle() => $_clearField(3);
  @$pb.TagNumber(3)
  TriangleObjectShape ensureTriangle() => $_ensure(2);
}

class ColorData extends $pb.GeneratedMessage {
  factory ColorData({
    ColorData_Type? type,
    $core.double? v1,
    $core.double? v2,
    $core.double? v3,
    $core.double? alpha,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (v1 != null) result.v1 = v1;
    if (v2 != null) result.v2 = v2;
    if (v3 != null) result.v3 = v3;
    if (alpha != null) result.alpha = alpha;
    return result;
  }

  ColorData._();

  factory ColorData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ColorData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorData',
      createEmptyInstance: create)
    ..aE<ColorData_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: ColorData_Type.values)
    ..aD(2, _omitFieldNames ? '' : 'v1')
    ..aD(3, _omitFieldNames ? '' : 'v2')
    ..aD(4, _omitFieldNames ? '' : 'v3')
    ..aD(5, _omitFieldNames ? '' : 'alpha')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorData copyWith(void Function(ColorData) updates) =>
      super.copyWith((message) => updates(message as ColorData)) as ColorData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ColorData create() => ColorData._();
  @$core.override
  ColorData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ColorData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ColorData>(create);
  static ColorData? _defaultInstance;

  @$pb.TagNumber(1)
  ColorData_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ColorData_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get v1 => $_getN(1);
  @$pb.TagNumber(2)
  set v1($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasV1() => $_has(1);
  @$pb.TagNumber(2)
  void clearV1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get v2 => $_getN(2);
  @$pb.TagNumber(3)
  set v2($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasV2() => $_has(2);
  @$pb.TagNumber(3)
  void clearV2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get v3 => $_getN(3);
  @$pb.TagNumber(4)
  set v3($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasV3() => $_has(3);
  @$pb.TagNumber(4)
  void clearV3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get alpha => $_getN(4);
  @$pb.TagNumber(5)
  set alpha($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAlpha() => $_has(4);
  @$pb.TagNumber(5)
  void clearAlpha() => $_clearField(5);
}

class EdgeStyle extends $pb.GeneratedMessage {
  factory EdgeStyle({
    $core.double? width,
    ColorData? color,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (color != null) result.color = color;
    return result;
  }

  EdgeStyle._();

  factory EdgeStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EdgeStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EdgeStyle',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'width')
    ..aOM<ColorData>(2, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStyle copyWith(void Function(EdgeStyle) updates) =>
      super.copyWith((message) => updates(message as EdgeStyle)) as EdgeStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EdgeStyle create() => EdgeStyle._();
  @$core.override
  EdgeStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EdgeStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EdgeStyle>(create);
  static EdgeStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  ColorData get color => $_getN(1);
  @$pb.TagNumber(2)
  set color(ColorData value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearColor() => $_clearField(2);
  @$pb.TagNumber(2)
  ColorData ensureColor() => $_ensure(1);
}

class FaceStyle extends $pb.GeneratedMessage {
  factory FaceStyle({
    ColorData? color,
  }) {
    final result = create();
    if (color != null) result.color = color;
    return result;
  }

  FaceStyle._();

  factory FaceStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FaceStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaceStyle',
      createEmptyInstance: create)
    ..aOM<ColorData>(1, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStyle copyWith(void Function(FaceStyle) updates) =>
      super.copyWith((message) => updates(message as FaceStyle)) as FaceStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaceStyle create() => FaceStyle._();
  @$core.override
  FaceStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FaceStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FaceStyle>(create);
  static FaceStyle? _defaultInstance;

  @$pb.TagNumber(1)
  ColorData get color => $_getN(0);
  @$pb.TagNumber(1)
  set color(ColorData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => $_clearField(1);
  @$pb.TagNumber(1)
  ColorData ensureColor() => $_ensure(0);
}

class LayoutInsets extends $pb.GeneratedMessage {
  factory LayoutInsets({
    $core.double? left,
    $core.double? top,
    $core.double? right,
    $core.double? bottom,
  }) {
    final result = create();
    if (left != null) result.left = left;
    if (top != null) result.top = top;
    if (right != null) result.right = right;
    if (bottom != null) result.bottom = bottom;
    return result;
  }

  LayoutInsets._();

  factory LayoutInsets.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LayoutInsets.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayoutInsets',
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'left')
    ..aD(2, _omitFieldNames ? '' : 'top')
    ..aD(3, _omitFieldNames ? '' : 'right')
    ..aD(4, _omitFieldNames ? '' : 'bottom')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutInsets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutInsets copyWith(void Function(LayoutInsets) updates) =>
      super.copyWith((message) => updates(message as LayoutInsets))
          as LayoutInsets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutInsets create() => LayoutInsets._();
  @$core.override
  LayoutInsets createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LayoutInsets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayoutInsets>(create);
  static LayoutInsets? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get left => $_getN(0);
  @$pb.TagNumber(1)
  set left($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get top => $_getN(1);
  @$pb.TagNumber(2)
  set top($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTop() => $_has(1);
  @$pb.TagNumber(2)
  void clearTop() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get right => $_getN(2);
  @$pb.TagNumber(3)
  set right($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRight() => $_has(2);
  @$pb.TagNumber(3)
  void clearRight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get bottom => $_getN(3);
  @$pb.TagNumber(4)
  set bottom($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBottom() => $_has(3);
  @$pb.TagNumber(4)
  void clearBottom() => $_clearField(4);
}

enum ChildLayout_Layout { stack, flex, notSet }

class ChildLayout extends $pb.GeneratedMessage {
  factory ChildLayout({
    StackChildLayout? stack,
    FlexChildLayout? flex,
  }) {
    final result = create();
    if (stack != null) result.stack = stack;
    if (flex != null) result.flex = flex;
    return result;
  }

  ChildLayout._();

  factory ChildLayout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChildLayout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ChildLayout_Layout>
      _ChildLayout_LayoutByTag = {
    1: ChildLayout_Layout.stack,
    2: ChildLayout_Layout.flex,
    0: ChildLayout_Layout.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChildLayout',
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<StackChildLayout>(1, _omitFieldNames ? '' : 'stack',
        subBuilder: StackChildLayout.create)
    ..aOM<FlexChildLayout>(2, _omitFieldNames ? '' : 'flex',
        subBuilder: FlexChildLayout.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChildLayout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChildLayout copyWith(void Function(ChildLayout) updates) =>
      super.copyWith((message) => updates(message as ChildLayout))
          as ChildLayout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChildLayout create() => ChildLayout._();
  @$core.override
  ChildLayout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChildLayout getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChildLayout>(create);
  static ChildLayout? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  ChildLayout_Layout whichLayout() =>
      _ChildLayout_LayoutByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearLayout() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StackChildLayout get stack => $_getN(0);
  @$pb.TagNumber(1)
  set stack(StackChildLayout value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStack() => $_has(0);
  @$pb.TagNumber(1)
  void clearStack() => $_clearField(1);
  @$pb.TagNumber(1)
  StackChildLayout ensureStack() => $_ensure(0);

  @$pb.TagNumber(2)
  FlexChildLayout get flex => $_getN(1);
  @$pb.TagNumber(2)
  set flex(FlexChildLayout value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFlex() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlex() => $_clearField(2);
  @$pb.TagNumber(2)
  FlexChildLayout ensureFlex() => $_ensure(1);
}

class StackChildLayout extends $pb.GeneratedMessage {
  factory StackChildLayout({
    LayoutAlign? alignHorizontal,
    LayoutAlign? alignVertical,
    LayoutInsets? padding,
  }) {
    final result = create();
    if (alignHorizontal != null) result.alignHorizontal = alignHorizontal;
    if (alignVertical != null) result.alignVertical = alignVertical;
    if (padding != null) result.padding = padding;
    return result;
  }

  StackChildLayout._();

  factory StackChildLayout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StackChildLayout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StackChildLayout',
      createEmptyInstance: create)
    ..aE<LayoutAlign>(1, _omitFieldNames ? '' : 'alignHorizontal',
        protoName: 'alignHorizontal', enumValues: LayoutAlign.values)
    ..aE<LayoutAlign>(2, _omitFieldNames ? '' : 'alignVertical',
        protoName: 'alignVertical', enumValues: LayoutAlign.values)
    ..aOM<LayoutInsets>(3, _omitFieldNames ? '' : 'padding',
        subBuilder: LayoutInsets.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StackChildLayout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StackChildLayout copyWith(void Function(StackChildLayout) updates) =>
      super.copyWith((message) => updates(message as StackChildLayout))
          as StackChildLayout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StackChildLayout create() => StackChildLayout._();
  @$core.override
  StackChildLayout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StackChildLayout getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StackChildLayout>(create);
  static StackChildLayout? _defaultInstance;

  @$pb.TagNumber(1)
  LayoutAlign get alignHorizontal => $_getN(0);
  @$pb.TagNumber(1)
  set alignHorizontal(LayoutAlign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlignHorizontal() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlignHorizontal() => $_clearField(1);

  @$pb.TagNumber(2)
  LayoutAlign get alignVertical => $_getN(1);
  @$pb.TagNumber(2)
  set alignVertical(LayoutAlign value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAlignVertical() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlignVertical() => $_clearField(2);

  @$pb.TagNumber(3)
  LayoutInsets get padding => $_getN(2);
  @$pb.TagNumber(3)
  set padding(LayoutInsets value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPadding() => $_has(2);
  @$pb.TagNumber(3)
  void clearPadding() => $_clearField(3);
  @$pb.TagNumber(3)
  LayoutInsets ensurePadding() => $_ensure(2);
}

class FlexChildLayout extends $pb.GeneratedMessage {
  factory FlexChildLayout({
    FlexDirection? direction,
    LayoutJustify? justify,
    LayoutAlign? crossAlign,
    $core.double? gap,
    LayoutInsets? padding,
  }) {
    final result = create();
    if (direction != null) result.direction = direction;
    if (justify != null) result.justify = justify;
    if (crossAlign != null) result.crossAlign = crossAlign;
    if (gap != null) result.gap = gap;
    if (padding != null) result.padding = padding;
    return result;
  }

  FlexChildLayout._();

  factory FlexChildLayout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FlexChildLayout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FlexChildLayout',
      createEmptyInstance: create)
    ..aE<FlexDirection>(1, _omitFieldNames ? '' : 'direction',
        enumValues: FlexDirection.values)
    ..aE<LayoutJustify>(2, _omitFieldNames ? '' : 'justify',
        enumValues: LayoutJustify.values)
    ..aE<LayoutAlign>(3, _omitFieldNames ? '' : 'crossAlign',
        protoName: 'crossAlign', enumValues: LayoutAlign.values)
    ..aD(4, _omitFieldNames ? '' : 'gap')
    ..aOM<LayoutInsets>(5, _omitFieldNames ? '' : 'padding',
        subBuilder: LayoutInsets.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlexChildLayout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlexChildLayout copyWith(void Function(FlexChildLayout) updates) =>
      super.copyWith((message) => updates(message as FlexChildLayout))
          as FlexChildLayout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FlexChildLayout create() => FlexChildLayout._();
  @$core.override
  FlexChildLayout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FlexChildLayout getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FlexChildLayout>(create);
  static FlexChildLayout? _defaultInstance;

  @$pb.TagNumber(1)
  FlexDirection get direction => $_getN(0);
  @$pb.TagNumber(1)
  set direction(FlexDirection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDirection() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirection() => $_clearField(1);

  @$pb.TagNumber(2)
  LayoutJustify get justify => $_getN(1);
  @$pb.TagNumber(2)
  set justify(LayoutJustify value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJustify() => $_has(1);
  @$pb.TagNumber(2)
  void clearJustify() => $_clearField(2);

  @$pb.TagNumber(3)
  LayoutAlign get crossAlign => $_getN(2);
  @$pb.TagNumber(3)
  set crossAlign(LayoutAlign value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCrossAlign() => $_has(2);
  @$pb.TagNumber(3)
  void clearCrossAlign() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get gap => $_getN(3);
  @$pb.TagNumber(4)
  set gap($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGap() => $_has(3);
  @$pb.TagNumber(4)
  void clearGap() => $_clearField(4);

  @$pb.TagNumber(5)
  LayoutInsets get padding => $_getN(4);
  @$pb.TagNumber(5)
  set padding(LayoutInsets value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPadding() => $_has(4);
  @$pb.TagNumber(5)
  void clearPadding() => $_clearField(5);
  @$pb.TagNumber(5)
  LayoutInsets ensurePadding() => $_ensure(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
