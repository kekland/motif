// This is a generated file - do not edit.
//
// Generated from program.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'program.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'program.pbenum.dart';

class Program extends $pb.GeneratedMessage {
  factory Program({
    $core.Iterable<Statement>? statements,
    StyleTable? style,
    ZOrderTable? zOrder,
  }) {
    final result = create();
    if (statements != null) result.statements.addAll(statements);
    if (style != null) result.style = style;
    if (zOrder != null) result.zOrder = zOrder;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<Statement>(1, _omitFieldNames ? '' : 'statements',
        subBuilder: Statement.create)
    ..aOM<StyleTable>(2, _omitFieldNames ? '' : 'style',
        subBuilder: StyleTable.create)
    ..aOM<ZOrderTable>(3, _omitFieldNames ? '' : 'zOrder',
        subBuilder: ZOrderTable.create)
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

  @$pb.TagNumber(2)
  StyleTable get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(StyleTable value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  StyleTable ensureStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  ZOrderTable get zOrder => $_getN(2);
  @$pb.TagNumber(3)
  set zOrder(ZOrderTable value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasZOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearZOrder() => $_clearField(3);
  @$pb.TagNumber(3)
  ZOrderTable ensureZOrder() => $_ensure(2);
}

class ProgramSlice extends $pb.GeneratedMessage {
  factory ProgramSlice({
    $core.Iterable<Statement>? statements,
    StyleTable? style,
    ZOrderTable? zOrder,
  }) {
    final result = create();
    if (statements != null) result.statements.addAll(statements);
    if (style != null) result.style = style;
    if (zOrder != null) result.zOrder = zOrder;
    return result;
  }

  ProgramSlice._();

  factory ProgramSlice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProgramSlice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProgramSlice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<Statement>(1, _omitFieldNames ? '' : 'statements',
        subBuilder: Statement.create)
    ..aOM<StyleTable>(2, _omitFieldNames ? '' : 'style',
        subBuilder: StyleTable.create)
    ..aOM<ZOrderTable>(3, _omitFieldNames ? '' : 'zOrder',
        subBuilder: ZOrderTable.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramSlice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramSlice copyWith(void Function(ProgramSlice) updates) =>
      super.copyWith((message) => updates(message as ProgramSlice))
          as ProgramSlice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProgramSlice create() => ProgramSlice._();
  @$core.override
  ProgramSlice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProgramSlice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProgramSlice>(create);
  static ProgramSlice? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Statement> get statements => $_getList(0);

  @$pb.TagNumber(2)
  StyleTable get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(StyleTable value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  StyleTable ensureStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  ZOrderTable get zOrder => $_getN(2);
  @$pb.TagNumber(3)
  set zOrder(ZOrderTable value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasZOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearZOrder() => $_clearField(3);
  @$pb.TagNumber(3)
  ZOrderTable ensureZOrder() => $_ensure(2);
}

enum Statement_Value {
  vertex,
  edge,
  face,
  cutEdge,
  multiCutEdge,
  filletFace,
  glueVertices,
  rectangle,
  polygon,
  ellipse,
  container,
  group,
  generator,
  notSet
}

class Statement extends $pb.GeneratedMessage {
  factory Statement({
    StatementId? id,
    $core.Iterable<Modifier>? modifiers,
    VertexStatement? vertex,
    EdgeStatement? edge,
    FaceStatement? face,
    CutEdgeStatement? cutEdge,
    MultiCutEdgeStatement? multiCutEdge,
    FilletFaceStatement? filletFace,
    GlueVerticesStatement? glueVertices,
    RectangleStatement? rectangle,
    PolygonStatement? polygon,
    EllipseStatement? ellipse,
    ContainerStatement? container,
    GroupStatement? group,
    GeneratorStatement? generator,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (modifiers != null) result.modifiers.addAll(modifiers);
    if (vertex != null) result.vertex = vertex;
    if (edge != null) result.edge = edge;
    if (face != null) result.face = face;
    if (cutEdge != null) result.cutEdge = cutEdge;
    if (multiCutEdge != null) result.multiCutEdge = multiCutEdge;
    if (filletFace != null) result.filletFace = filletFace;
    if (glueVertices != null) result.glueVertices = glueVertices;
    if (rectangle != null) result.rectangle = rectangle;
    if (polygon != null) result.polygon = polygon;
    if (ellipse != null) result.ellipse = ellipse;
    if (container != null) result.container = container;
    if (group != null) result.group = group;
    if (generator != null) result.generator = generator;
    return result;
  }

  Statement._();

  factory Statement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Statement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Statement_Value> _Statement_ValueByTag = {
    10: Statement_Value.vertex,
    11: Statement_Value.edge,
    12: Statement_Value.face,
    13: Statement_Value.cutEdge,
    14: Statement_Value.multiCutEdge,
    15: Statement_Value.filletFace,
    16: Statement_Value.glueVertices,
    17: Statement_Value.rectangle,
    18: Statement_Value.polygon,
    19: Statement_Value.ellipse,
    20: Statement_Value.container,
    21: Statement_Value.group,
    22: Statement_Value.generator,
    0: Statement_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Statement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22])
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..pPM<Modifier>(2, _omitFieldNames ? '' : 'modifiers',
        subBuilder: Modifier.create)
    ..aOM<VertexStatement>(10, _omitFieldNames ? '' : 'vertex',
        subBuilder: VertexStatement.create)
    ..aOM<EdgeStatement>(11, _omitFieldNames ? '' : 'edge',
        subBuilder: EdgeStatement.create)
    ..aOM<FaceStatement>(12, _omitFieldNames ? '' : 'face',
        subBuilder: FaceStatement.create)
    ..aOM<CutEdgeStatement>(13, _omitFieldNames ? '' : 'cutEdge',
        subBuilder: CutEdgeStatement.create)
    ..aOM<MultiCutEdgeStatement>(14, _omitFieldNames ? '' : 'multiCutEdge',
        subBuilder: MultiCutEdgeStatement.create)
    ..aOM<FilletFaceStatement>(15, _omitFieldNames ? '' : 'filletFace',
        subBuilder: FilletFaceStatement.create)
    ..aOM<GlueVerticesStatement>(16, _omitFieldNames ? '' : 'glueVertices',
        subBuilder: GlueVerticesStatement.create)
    ..aOM<RectangleStatement>(17, _omitFieldNames ? '' : 'rectangle',
        subBuilder: RectangleStatement.create)
    ..aOM<PolygonStatement>(18, _omitFieldNames ? '' : 'polygon',
        subBuilder: PolygonStatement.create)
    ..aOM<EllipseStatement>(19, _omitFieldNames ? '' : 'ellipse',
        subBuilder: EllipseStatement.create)
    ..aOM<ContainerStatement>(20, _omitFieldNames ? '' : 'container',
        subBuilder: ContainerStatement.create)
    ..aOM<GroupStatement>(21, _omitFieldNames ? '' : 'group',
        subBuilder: GroupStatement.create)
    ..aOM<GeneratorStatement>(22, _omitFieldNames ? '' : 'generator',
        subBuilder: GeneratorStatement.create)
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

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  Statement_Value whichValue() => _Statement_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  void clearValue() => $_clearField($_whichOneof(0));

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
  $pb.PbList<Modifier> get modifiers => $_getList(1);

  @$pb.TagNumber(10)
  VertexStatement get vertex => $_getN(2);
  @$pb.TagNumber(10)
  set vertex(VertexStatement value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasVertex() => $_has(2);
  @$pb.TagNumber(10)
  void clearVertex() => $_clearField(10);
  @$pb.TagNumber(10)
  VertexStatement ensureVertex() => $_ensure(2);

  @$pb.TagNumber(11)
  EdgeStatement get edge => $_getN(3);
  @$pb.TagNumber(11)
  set edge(EdgeStatement value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasEdge() => $_has(3);
  @$pb.TagNumber(11)
  void clearEdge() => $_clearField(11);
  @$pb.TagNumber(11)
  EdgeStatement ensureEdge() => $_ensure(3);

  @$pb.TagNumber(12)
  FaceStatement get face => $_getN(4);
  @$pb.TagNumber(12)
  set face(FaceStatement value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasFace() => $_has(4);
  @$pb.TagNumber(12)
  void clearFace() => $_clearField(12);
  @$pb.TagNumber(12)
  FaceStatement ensureFace() => $_ensure(4);

  @$pb.TagNumber(13)
  CutEdgeStatement get cutEdge => $_getN(5);
  @$pb.TagNumber(13)
  set cutEdge(CutEdgeStatement value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCutEdge() => $_has(5);
  @$pb.TagNumber(13)
  void clearCutEdge() => $_clearField(13);
  @$pb.TagNumber(13)
  CutEdgeStatement ensureCutEdge() => $_ensure(5);

  @$pb.TagNumber(14)
  MultiCutEdgeStatement get multiCutEdge => $_getN(6);
  @$pb.TagNumber(14)
  set multiCutEdge(MultiCutEdgeStatement value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasMultiCutEdge() => $_has(6);
  @$pb.TagNumber(14)
  void clearMultiCutEdge() => $_clearField(14);
  @$pb.TagNumber(14)
  MultiCutEdgeStatement ensureMultiCutEdge() => $_ensure(6);

  @$pb.TagNumber(15)
  FilletFaceStatement get filletFace => $_getN(7);
  @$pb.TagNumber(15)
  set filletFace(FilletFaceStatement value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasFilletFace() => $_has(7);
  @$pb.TagNumber(15)
  void clearFilletFace() => $_clearField(15);
  @$pb.TagNumber(15)
  FilletFaceStatement ensureFilletFace() => $_ensure(7);

  @$pb.TagNumber(16)
  GlueVerticesStatement get glueVertices => $_getN(8);
  @$pb.TagNumber(16)
  set glueVertices(GlueVerticesStatement value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGlueVertices() => $_has(8);
  @$pb.TagNumber(16)
  void clearGlueVertices() => $_clearField(16);
  @$pb.TagNumber(16)
  GlueVerticesStatement ensureGlueVertices() => $_ensure(8);

  @$pb.TagNumber(17)
  RectangleStatement get rectangle => $_getN(9);
  @$pb.TagNumber(17)
  set rectangle(RectangleStatement value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRectangle() => $_has(9);
  @$pb.TagNumber(17)
  void clearRectangle() => $_clearField(17);
  @$pb.TagNumber(17)
  RectangleStatement ensureRectangle() => $_ensure(9);

  @$pb.TagNumber(18)
  PolygonStatement get polygon => $_getN(10);
  @$pb.TagNumber(18)
  set polygon(PolygonStatement value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasPolygon() => $_has(10);
  @$pb.TagNumber(18)
  void clearPolygon() => $_clearField(18);
  @$pb.TagNumber(18)
  PolygonStatement ensurePolygon() => $_ensure(10);

  @$pb.TagNumber(19)
  EllipseStatement get ellipse => $_getN(11);
  @$pb.TagNumber(19)
  set ellipse(EllipseStatement value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasEllipse() => $_has(11);
  @$pb.TagNumber(19)
  void clearEllipse() => $_clearField(19);
  @$pb.TagNumber(19)
  EllipseStatement ensureEllipse() => $_ensure(11);

  @$pb.TagNumber(20)
  ContainerStatement get container => $_getN(12);
  @$pb.TagNumber(20)
  set container(ContainerStatement value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasContainer() => $_has(12);
  @$pb.TagNumber(20)
  void clearContainer() => $_clearField(20);
  @$pb.TagNumber(20)
  ContainerStatement ensureContainer() => $_ensure(12);

  @$pb.TagNumber(21)
  GroupStatement get group => $_getN(13);
  @$pb.TagNumber(21)
  set group(GroupStatement value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasGroup() => $_has(13);
  @$pb.TagNumber(21)
  void clearGroup() => $_clearField(21);
  @$pb.TagNumber(21)
  GroupStatement ensureGroup() => $_ensure(13);

  @$pb.TagNumber(22)
  GeneratorStatement get generator => $_getN(14);
  @$pb.TagNumber(22)
  set generator(GeneratorStatement value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasGenerator() => $_has(14);
  @$pb.TagNumber(22)
  void clearGenerator() => $_clearField(22);
  @$pb.TagNumber(22)
  GeneratorStatement ensureGenerator() => $_ensure(14);
}

class U64 extends $pb.GeneratedMessage {
  factory U64({
    $core.int? hi,
    $core.int? lo,
  }) {
    final result = create();
    if (hi != null) result.hi = hi;
    if (lo != null) result.lo = lo;
    return result;
  }

  U64._();

  factory U64.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory U64.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'U64',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'hi', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'lo', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  U64 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  U64 copyWith(void Function(U64) updates) =>
      super.copyWith((message) => updates(message as U64)) as U64;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static U64 create() => U64._();
  @$core.override
  U64 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static U64 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<U64>(create);
  static U64? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hi => $_getIZ(0);
  @$pb.TagNumber(1)
  set hi($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHi() => $_has(0);
  @$pb.TagNumber(1)
  void clearHi() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get lo => $_getIZ(1);
  @$pb.TagNumber(2)
  set lo($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLo() => $_has(1);
  @$pb.TagNumber(2)
  void clearLo() => $_clearField(2);
}

class StatementId extends $pb.GeneratedMessage {
  factory StatementId({
    U64? value,
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<U64>(1, _omitFieldNames ? '' : 'value', subBuilder: U64.create)
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
  U64 get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(U64 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
  @$pb.TagNumber(1)
  U64 ensureValue() => $_ensure(0);
}

class CellRef extends $pb.GeneratedMessage {
  factory CellRef({
    U64? namespace,
    $core.int? tag,
    $core.int? sub,
    CellKind? kind,
  }) {
    final result = create();
    if (namespace != null) result.namespace = namespace;
    if (tag != null) result.tag = tag;
    if (sub != null) result.sub = sub;
    if (kind != null) result.kind = kind;
    return result;
  }

  CellRef._();

  factory CellRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CellRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellRef',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<U64>(1, _omitFieldNames ? '' : 'namespace', subBuilder: U64.create)
    ..aI(2, _omitFieldNames ? '' : 'tag', fieldType: $pb.PbFieldType.OU3)
    ..aI(3, _omitFieldNames ? '' : 'sub', fieldType: $pb.PbFieldType.OU3)
    ..aE<CellKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: CellKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellRef copyWith(void Function(CellRef) updates) =>
      super.copyWith((message) => updates(message as CellRef)) as CellRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CellRef create() => CellRef._();
  @$core.override
  CellRef createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CellRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CellRef>(create);
  static CellRef? _defaultInstance;

  @$pb.TagNumber(1)
  U64 get namespace => $_getN(0);
  @$pb.TagNumber(1)
  set namespace(U64 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNamespace() => $_has(0);
  @$pb.TagNumber(1)
  void clearNamespace() => $_clearField(1);
  @$pb.TagNumber(1)
  U64 ensureNamespace() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get tag => $_getIZ(1);
  @$pb.TagNumber(2)
  set tag($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearTag() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sub => $_getIZ(2);
  @$pb.TagNumber(3)
  set sub($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSub() => $_has(2);
  @$pb.TagNumber(3)
  void clearSub() => $_clearField(3);

  @$pb.TagNumber(4)
  CellKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(CellKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);
}

enum ZAnchor_Value { top, bottom, above, below, notSet }

class ZAnchor extends $pb.GeneratedMessage {
  factory ZAnchor({
    $core.bool? top,
    $core.bool? bottom,
    CellRef? above,
    CellRef? below,
  }) {
    final result = create();
    if (top != null) result.top = top;
    if (bottom != null) result.bottom = bottom;
    if (above != null) result.above = above;
    if (below != null) result.below = below;
    return result;
  }

  ZAnchor._();

  factory ZAnchor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ZAnchor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ZAnchor_Value> _ZAnchor_ValueByTag = {
    1: ZAnchor_Value.top,
    2: ZAnchor_Value.bottom,
    3: ZAnchor_Value.above,
    4: ZAnchor_Value.below,
    0: ZAnchor_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ZAnchor',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOB(1, _omitFieldNames ? '' : 'top')
    ..aOB(2, _omitFieldNames ? '' : 'bottom')
    ..aOM<CellRef>(3, _omitFieldNames ? '' : 'above',
        subBuilder: CellRef.create)
    ..aOM<CellRef>(4, _omitFieldNames ? '' : 'below',
        subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZAnchor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZAnchor copyWith(void Function(ZAnchor) updates) =>
      super.copyWith((message) => updates(message as ZAnchor)) as ZAnchor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ZAnchor create() => ZAnchor._();
  @$core.override
  ZAnchor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ZAnchor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ZAnchor>(create);
  static ZAnchor? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ZAnchor_Value whichValue() => _ZAnchor_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get top => $_getBF(0);
  @$pb.TagNumber(1)
  set top($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTop() => $_has(0);
  @$pb.TagNumber(1)
  void clearTop() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get bottom => $_getBF(1);
  @$pb.TagNumber(2)
  set bottom($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBottom() => $_has(1);
  @$pb.TagNumber(2)
  void clearBottom() => $_clearField(2);

  @$pb.TagNumber(3)
  CellRef get above => $_getN(2);
  @$pb.TagNumber(3)
  set above(CellRef value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAbove() => $_has(2);
  @$pb.TagNumber(3)
  void clearAbove() => $_clearField(3);
  @$pb.TagNumber(3)
  CellRef ensureAbove() => $_ensure(2);

  @$pb.TagNumber(4)
  CellRef get below => $_getN(3);
  @$pb.TagNumber(4)
  set below(CellRef value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBelow() => $_has(3);
  @$pb.TagNumber(4)
  void clearBelow() => $_clearField(4);
  @$pb.TagNumber(4)
  CellRef ensureBelow() => $_ensure(3);
}

class ZOrderEntry extends $pb.GeneratedMessage {
  factory ZOrderEntry({
    CellRef? ref,
    ZAnchor? value,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    if (value != null) result.value = value;
    return result;
  }

  ZOrderEntry._();

  factory ZOrderEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ZOrderEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ZOrderEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..aOM<ZAnchor>(2, _omitFieldNames ? '' : 'value',
        subBuilder: ZAnchor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderEntry copyWith(void Function(ZOrderEntry) updates) =>
      super.copyWith((message) => updates(message as ZOrderEntry))
          as ZOrderEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ZOrderEntry create() => ZOrderEntry._();
  @$core.override
  ZOrderEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ZOrderEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ZOrderEntry>(create);
  static ZOrderEntry? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);

  @$pb.TagNumber(2)
  ZAnchor get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(ZAnchor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  ZAnchor ensureValue() => $_ensure(1);
}

class ZOrderTable extends $pb.GeneratedMessage {
  factory ZOrderTable({
    $core.Iterable<ZOrderEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ZOrderTable._();

  factory ZOrderTable.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ZOrderTable.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ZOrderTable',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<ZOrderEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: ZOrderEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderTable clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderTable copyWith(void Function(ZOrderTable) updates) =>
      super.copyWith((message) => updates(message as ZOrderTable))
          as ZOrderTable;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ZOrderTable create() => ZOrderTable._();
  @$core.override
  ZOrderTable createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ZOrderTable getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ZOrderTable>(create);
  static ZOrderTable? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ZOrderEntry> get entries => $_getList(0);
}

class StyleEntry extends $pb.GeneratedMessage {
  factory StyleEntry({
    CellRef? ref,
    CellStyle_Partial? value,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    if (value != null) result.value = value;
    return result;
  }

  StyleEntry._();

  factory StyleEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StyleEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StyleEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..aOM<CellStyle_Partial>(2, _omitFieldNames ? '' : 'value',
        subBuilder: CellStyle_Partial.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleEntry copyWith(void Function(StyleEntry) updates) =>
      super.copyWith((message) => updates(message as StyleEntry)) as StyleEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StyleEntry create() => StyleEntry._();
  @$core.override
  StyleEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StyleEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StyleEntry>(create);
  static StyleEntry? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);

  @$pb.TagNumber(2)
  CellStyle_Partial get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(CellStyle_Partial value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  CellStyle_Partial ensureValue() => $_ensure(1);
}

class StyleTable extends $pb.GeneratedMessage {
  factory StyleTable({
    $core.Iterable<StyleEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  StyleTable._();

  factory StyleTable.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StyleTable.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StyleTable',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<StyleEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: StyleEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleTable clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleTable copyWith(void Function(StyleTable) updates) =>
      super.copyWith((message) => updates(message as StyleTable)) as StyleTable;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StyleTable create() => StyleTable._();
  @$core.override
  StyleTable createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StyleTable getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StyleTable>(create);
  static StyleTable? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StyleEntry> get entries => $_getList(0);
}

enum CellStyle_Partial_Value { vertex, edge, face, notSet }

class CellStyle_Partial extends $pb.GeneratedMessage {
  factory CellStyle_Partial({
    VertexStyle_Partial? vertex,
    EdgeStyle_Partial? edge,
    FaceStyle_Partial? face,
  }) {
    final result = create();
    if (vertex != null) result.vertex = vertex;
    if (edge != null) result.edge = edge;
    if (face != null) result.face = face;
    return result;
  }

  CellStyle_Partial._();

  factory CellStyle_Partial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CellStyle_Partial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CellStyle_Partial_Value>
      _CellStyle_Partial_ValueByTag = {
    1: CellStyle_Partial_Value.vertex,
    2: CellStyle_Partial_Value.edge,
    3: CellStyle_Partial_Value.face,
    0: CellStyle_Partial_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellStyle.Partial',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<VertexStyle_Partial>(1, _omitFieldNames ? '' : 'vertex',
        subBuilder: VertexStyle_Partial.create)
    ..aOM<EdgeStyle_Partial>(2, _omitFieldNames ? '' : 'edge',
        subBuilder: EdgeStyle_Partial.create)
    ..aOM<FaceStyle_Partial>(3, _omitFieldNames ? '' : 'face',
        subBuilder: FaceStyle_Partial.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellStyle_Partial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellStyle_Partial copyWith(void Function(CellStyle_Partial) updates) =>
      super.copyWith((message) => updates(message as CellStyle_Partial))
          as CellStyle_Partial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CellStyle_Partial create() => CellStyle_Partial._();
  @$core.override
  CellStyle_Partial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CellStyle_Partial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CellStyle_Partial>(create);
  static CellStyle_Partial? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  CellStyle_Partial_Value whichValue() =>
      _CellStyle_Partial_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  VertexStyle_Partial get vertex => $_getN(0);
  @$pb.TagNumber(1)
  set vertex(VertexStyle_Partial value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVertex() => $_has(0);
  @$pb.TagNumber(1)
  void clearVertex() => $_clearField(1);
  @$pb.TagNumber(1)
  VertexStyle_Partial ensureVertex() => $_ensure(0);

  @$pb.TagNumber(2)
  EdgeStyle_Partial get edge => $_getN(1);
  @$pb.TagNumber(2)
  set edge(EdgeStyle_Partial value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEdge() => $_has(1);
  @$pb.TagNumber(2)
  void clearEdge() => $_clearField(2);
  @$pb.TagNumber(2)
  EdgeStyle_Partial ensureEdge() => $_ensure(1);

  @$pb.TagNumber(3)
  FaceStyle_Partial get face => $_getN(2);
  @$pb.TagNumber(3)
  set face(FaceStyle_Partial value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);
  @$pb.TagNumber(3)
  FaceStyle_Partial ensureFace() => $_ensure(2);
}

enum CellStyle_Value { vertex, edge, face, notSet }

class CellStyle extends $pb.GeneratedMessage {
  factory CellStyle({
    VertexStyle? vertex,
    EdgeStyle? edge,
    FaceStyle? face,
  }) {
    final result = create();
    if (vertex != null) result.vertex = vertex;
    if (edge != null) result.edge = edge;
    if (face != null) result.face = face;
    return result;
  }

  CellStyle._();

  factory CellStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CellStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CellStyle_Value> _CellStyle_ValueByTag = {
    1: CellStyle_Value.vertex,
    2: CellStyle_Value.edge,
    3: CellStyle_Value.face,
    0: CellStyle_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellStyle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<VertexStyle>(1, _omitFieldNames ? '' : 'vertex',
        subBuilder: VertexStyle.create)
    ..aOM<EdgeStyle>(2, _omitFieldNames ? '' : 'edge',
        subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(3, _omitFieldNames ? '' : 'face',
        subBuilder: FaceStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellStyle copyWith(void Function(CellStyle) updates) =>
      super.copyWith((message) => updates(message as CellStyle)) as CellStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CellStyle create() => CellStyle._();
  @$core.override
  CellStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CellStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CellStyle>(create);
  static CellStyle? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  CellStyle_Value whichValue() => _CellStyle_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  VertexStyle get vertex => $_getN(0);
  @$pb.TagNumber(1)
  set vertex(VertexStyle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVertex() => $_has(0);
  @$pb.TagNumber(1)
  void clearVertex() => $_clearField(1);
  @$pb.TagNumber(1)
  VertexStyle ensureVertex() => $_ensure(0);

  @$pb.TagNumber(2)
  EdgeStyle get edge => $_getN(1);
  @$pb.TagNumber(2)
  set edge(EdgeStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEdge() => $_has(1);
  @$pb.TagNumber(2)
  void clearEdge() => $_clearField(2);
  @$pb.TagNumber(2)
  EdgeStyle ensureEdge() => $_ensure(1);

  @$pb.TagNumber(3)
  FaceStyle get face => $_getN(2);
  @$pb.TagNumber(3)
  set face(FaceStyle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);
  @$pb.TagNumber(3)
  FaceStyle ensureFace() => $_ensure(2);
}

class VertexStyle_Partial extends $pb.GeneratedMessage {
  factory VertexStyle_Partial({
    $core.double? radius,
    ColorData? color,
  }) {
    final result = create();
    if (radius != null) result.radius = radius;
    if (color != null) result.color = color;
    return result;
  }

  VertexStyle_Partial._();

  factory VertexStyle_Partial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VertexStyle_Partial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VertexStyle.Partial',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'radius')
    ..aOM<ColorData>(2, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStyle_Partial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStyle_Partial copyWith(void Function(VertexStyle_Partial) updates) =>
      super.copyWith((message) => updates(message as VertexStyle_Partial))
          as VertexStyle_Partial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VertexStyle_Partial create() => VertexStyle_Partial._();
  @$core.override
  VertexStyle_Partial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VertexStyle_Partial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VertexStyle_Partial>(create);
  static VertexStyle_Partial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get radius => $_getN(0);
  @$pb.TagNumber(1)
  set radius($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRadius() => $_has(0);
  @$pb.TagNumber(1)
  void clearRadius() => $_clearField(1);

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

class VertexStyle extends $pb.GeneratedMessage {
  factory VertexStyle({
    $core.double? radius,
    ColorData? color,
  }) {
    final result = create();
    if (radius != null) result.radius = radius;
    if (color != null) result.color = color;
    return result;
  }

  VertexStyle._();

  factory VertexStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VertexStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VertexStyle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'radius')
    ..aOM<ColorData>(2, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VertexStyle copyWith(void Function(VertexStyle) updates) =>
      super.copyWith((message) => updates(message as VertexStyle))
          as VertexStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VertexStyle create() => VertexStyle._();
  @$core.override
  VertexStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VertexStyle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VertexStyle>(create);
  static VertexStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get radius => $_getN(0);
  @$pb.TagNumber(1)
  set radius($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRadius() => $_has(0);
  @$pb.TagNumber(1)
  void clearRadius() => $_clearField(1);

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

class EdgeStyle_Partial extends $pb.GeneratedMessage {
  factory EdgeStyle_Partial({
    $core.double? width,
    ColorData? color,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (color != null) result.color = color;
    return result;
  }

  EdgeStyle_Partial._();

  factory EdgeStyle_Partial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EdgeStyle_Partial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EdgeStyle.Partial',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'width')
    ..aOM<ColorData>(2, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStyle_Partial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EdgeStyle_Partial copyWith(void Function(EdgeStyle_Partial) updates) =>
      super.copyWith((message) => updates(message as EdgeStyle_Partial))
          as EdgeStyle_Partial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EdgeStyle_Partial create() => EdgeStyle_Partial._();
  @$core.override
  EdgeStyle_Partial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EdgeStyle_Partial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EdgeStyle_Partial>(create);
  static EdgeStyle_Partial? _defaultInstance;

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
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

class FaceStyle_Partial extends $pb.GeneratedMessage {
  factory FaceStyle_Partial({
    ColorData? color,
  }) {
    final result = create();
    if (color != null) result.color = color;
    return result;
  }

  FaceStyle_Partial._();

  factory FaceStyle_Partial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FaceStyle_Partial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaceStyle.Partial',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<ColorData>(1, _omitFieldNames ? '' : 'color',
        subBuilder: ColorData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStyle_Partial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaceStyle_Partial copyWith(void Function(FaceStyle_Partial) updates) =>
      super.copyWith((message) => updates(message as FaceStyle_Partial))
          as FaceStyle_Partial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaceStyle_Partial create() => FaceStyle_Partial._();
  @$core.override
  FaceStyle_Partial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FaceStyle_Partial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FaceStyle_Partial>(create);
  static FaceStyle_Partial? _defaultInstance;

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
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

class CellSelector extends $pb.GeneratedMessage {
  factory CellSelector({
    CellRef? ref,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    return result;
  }

  CellSelector._();

  factory CellSelector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CellSelector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellSelector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellSelector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellSelector copyWith(void Function(CellSelector) updates) =>
      super.copyWith((message) => updates(message as CellSelector))
          as CellSelector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CellSelector create() => CellSelector._();
  @$core.override
  CellSelector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CellSelector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CellSelector>(create);
  static CellSelector? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);
}

class ChainSelector extends $pb.GeneratedMessage {
  factory ChainSelector({
    $core.Iterable<CellRef>? edges,
  }) {
    final result = create();
    if (edges != null) result.edges.addAll(edges);
    return result;
  }

  ChainSelector._();

  factory ChainSelector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChainSelector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChainSelector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<CellRef>(1, _omitFieldNames ? '' : 'edges',
        subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChainSelector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChainSelector copyWith(void Function(ChainSelector) updates) =>
      super.copyWith((message) => updates(message as ChainSelector))
          as ChainSelector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChainSelector create() => ChainSelector._();
  @$core.override
  ChainSelector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChainSelector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChainSelector>(create);
  static ChainSelector? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CellRef> get edges => $_getList(0);
}

class FragmentSelector extends $pb.GeneratedMessage {
  factory FragmentSelector({
    StatementId? id,
    $core.int? modifierIndex,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (modifierIndex != null) result.modifierIndex = modifierIndex;
    return result;
  }

  FragmentSelector._();

  factory FragmentSelector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FragmentSelector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FragmentSelector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<StatementId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: StatementId.create)
    ..aI(2, _omitFieldNames ? '' : 'modifierIndex', protoName: 'modifierIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentSelector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentSelector copyWith(void Function(FragmentSelector) updates) =>
      super.copyWith((message) => updates(message as FragmentSelector))
          as FragmentSelector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FragmentSelector create() => FragmentSelector._();
  @$core.override
  FragmentSelector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FragmentSelector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FragmentSelector>(create);
  static FragmentSelector? _defaultInstance;

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
  $core.int get modifierIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set modifierIndex($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModifierIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearModifierIndex() => $_clearField(2);
}

class ParentSelector extends $pb.GeneratedMessage {
  factory ParentSelector({
    CellRef? ref,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    return result;
  }

  ParentSelector._();

  factory ParentSelector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParentSelector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParentSelector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParentSelector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParentSelector copyWith(void Function(ParentSelector) updates) =>
      super.copyWith((message) => updates(message as ParentSelector))
          as ParentSelector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParentSelector create() => ParentSelector._();
  @$core.override
  ParentSelector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParentSelector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParentSelector>(create);
  static ParentSelector? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);
}

enum Selector_Value { cell, parent, chain, fragment, notSet }

class Selector extends $pb.GeneratedMessage {
  factory Selector({
    CellSelector? cell,
    ParentSelector? parent,
    ChainSelector? chain,
    FragmentSelector? fragment,
  }) {
    final result = create();
    if (cell != null) result.cell = cell;
    if (parent != null) result.parent = parent;
    if (chain != null) result.chain = chain;
    if (fragment != null) result.fragment = fragment;
    return result;
  }

  Selector._();

  factory Selector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Selector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Selector_Value> _Selector_ValueByTag = {
    1: Selector_Value.cell,
    2: Selector_Value.parent,
    3: Selector_Value.chain,
    4: Selector_Value.fragment,
    0: Selector_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Selector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<CellSelector>(1, _omitFieldNames ? '' : 'cell',
        subBuilder: CellSelector.create)
    ..aOM<ParentSelector>(2, _omitFieldNames ? '' : 'parent',
        subBuilder: ParentSelector.create)
    ..aOM<ChainSelector>(3, _omitFieldNames ? '' : 'chain',
        subBuilder: ChainSelector.create)
    ..aOM<FragmentSelector>(4, _omitFieldNames ? '' : 'fragment',
        subBuilder: FragmentSelector.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Selector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Selector copyWith(void Function(Selector) updates) =>
      super.copyWith((message) => updates(message as Selector)) as Selector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Selector create() => Selector._();
  @$core.override
  Selector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Selector getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Selector>(create);
  static Selector? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Selector_Value whichValue() => _Selector_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CellSelector get cell => $_getN(0);
  @$pb.TagNumber(1)
  set cell(CellSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCell() => $_has(0);
  @$pb.TagNumber(1)
  void clearCell() => $_clearField(1);
  @$pb.TagNumber(1)
  CellSelector ensureCell() => $_ensure(0);

  @$pb.TagNumber(2)
  ParentSelector get parent => $_getN(1);
  @$pb.TagNumber(2)
  set parent(ParentSelector value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);
  @$pb.TagNumber(2)
  ParentSelector ensureParent() => $_ensure(1);

  @$pb.TagNumber(3)
  ChainSelector get chain => $_getN(2);
  @$pb.TagNumber(3)
  set chain(ChainSelector value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChain() => $_has(2);
  @$pb.TagNumber(3)
  void clearChain() => $_clearField(3);
  @$pb.TagNumber(3)
  ChainSelector ensureChain() => $_ensure(2);

  @$pb.TagNumber(4)
  FragmentSelector get fragment => $_getN(3);
  @$pb.TagNumber(4)
  set fragment(FragmentSelector value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFragment() => $_has(3);
  @$pb.TagNumber(4)
  void clearFragment() => $_clearField(4);
  @$pb.TagNumber(4)
  FragmentSelector ensureFragment() => $_ensure(3);
}

enum SingleSelector_Value { cell, notSet }

class SingleSelector extends $pb.GeneratedMessage {
  factory SingleSelector({
    CellSelector? cell,
  }) {
    final result = create();
    if (cell != null) result.cell = cell;
    return result;
  }

  SingleSelector._();

  factory SingleSelector.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SingleSelector.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SingleSelector_Value>
      _SingleSelector_ValueByTag = {
    1: SingleSelector_Value.cell,
    0: SingleSelector_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SingleSelector',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<CellSelector>(1, _omitFieldNames ? '' : 'cell',
        subBuilder: CellSelector.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SingleSelector clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SingleSelector copyWith(void Function(SingleSelector) updates) =>
      super.copyWith((message) => updates(message as SingleSelector))
          as SingleSelector;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SingleSelector create() => SingleSelector._();
  @$core.override
  SingleSelector createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SingleSelector getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SingleSelector>(create);
  static SingleSelector? _defaultInstance;

  @$pb.TagNumber(1)
  SingleSelector_Value whichValue() =>
      _SingleSelector_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CellSelector get cell => $_getN(0);
  @$pb.TagNumber(1)
  set cell(CellSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCell() => $_has(0);
  @$pb.TagNumber(1)
  void clearCell() => $_clearField(1);
  @$pb.TagNumber(1)
  CellSelector ensureCell() => $_ensure(0);
}

class FrameStatement extends $pb.GeneratedMessage {
  factory FrameStatement({
    Mat4? transform,
    Size2? size,
    CellRef? parent,
  }) {
    final result = create();
    if (transform != null) result.transform = transform;
    if (size != null) result.size = size;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Mat4>(1, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<Size2>(2, _omitFieldNames ? '' : 'size', subBuilder: Size2.create)
    ..aOM<CellRef>(3, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  Mat4 get transform => $_getN(0);
  @$pb.TagNumber(1)
  set transform(Mat4 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransform() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransform() => $_clearField(1);
  @$pb.TagNumber(1)
  Mat4 ensureTransform() => $_ensure(0);

  @$pb.TagNumber(2)
  Size2 get size => $_getN(1);
  @$pb.TagNumber(2)
  set size(Size2 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);
  @$pb.TagNumber(2)
  Size2 ensureSize() => $_ensure(1);

  @$pb.TagNumber(3)
  CellRef get parent => $_getN(2);
  @$pb.TagNumber(3)
  set parent(CellRef value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearParent() => $_clearField(3);
  @$pb.TagNumber(3)
  CellRef ensureParent() => $_ensure(2);
}

class VertexStatement extends $pb.GeneratedMessage {
  factory VertexStatement({
    Vec2? position,
    VertexStyle? style,
    CellRef? parent,
  }) {
    final result = create();
    if (position != null) result.position = position;
    if (style != null) result.style = style;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Vec2>(1, _omitFieldNames ? '' : 'position', subBuilder: Vec2.create)
    ..aOM<VertexStyle>(2, _omitFieldNames ? '' : 'style',
        subBuilder: VertexStyle.create)
    ..aOM<CellRef>(3, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  Vec2 get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(Vec2 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);
  @$pb.TagNumber(1)
  Vec2 ensurePosition() => $_ensure(0);

  @$pb.TagNumber(2)
  VertexStyle get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(VertexStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  VertexStyle ensureStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  CellRef get parent => $_getN(2);
  @$pb.TagNumber(3)
  set parent(CellRef value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearParent() => $_clearField(3);
  @$pb.TagNumber(3)
  CellRef ensureParent() => $_ensure(2);
}

class EdgeStatement extends $pb.GeneratedMessage {
  factory EdgeStatement({
    SingleSelector? start,
    SingleSelector? end,
    Vec2? startTangent,
    Vec2? endTangent,
    EdgeStyle? style,
    CellRef? parent,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (startTangent != null) result.startTangent = startTangent;
    if (endTangent != null) result.endTangent = endTangent;
    if (style != null) result.style = style;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<SingleSelector>(1, _omitFieldNames ? '' : 'start',
        subBuilder: SingleSelector.create)
    ..aOM<SingleSelector>(2, _omitFieldNames ? '' : 'end',
        subBuilder: SingleSelector.create)
    ..aOM<Vec2>(3, _omitFieldNames ? '' : 'startTangent',
        subBuilder: Vec2.create)
    ..aOM<Vec2>(4, _omitFieldNames ? '' : 'endTangent', subBuilder: Vec2.create)
    ..aOM<EdgeStyle>(5, _omitFieldNames ? '' : 'style',
        subBuilder: EdgeStyle.create)
    ..aOM<CellRef>(6, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  SingleSelector get start => $_getN(0);
  @$pb.TagNumber(1)
  set start(SingleSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);
  @$pb.TagNumber(1)
  SingleSelector ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  SingleSelector get end => $_getN(1);
  @$pb.TagNumber(2)
  set end(SingleSelector value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  SingleSelector ensureEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  Vec2 get startTangent => $_getN(2);
  @$pb.TagNumber(3)
  set startTangent(Vec2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartTangent() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartTangent() => $_clearField(3);
  @$pb.TagNumber(3)
  Vec2 ensureStartTangent() => $_ensure(2);

  @$pb.TagNumber(4)
  Vec2 get endTangent => $_getN(3);
  @$pb.TagNumber(4)
  set endTangent(Vec2 value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEndTangent() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndTangent() => $_clearField(4);
  @$pb.TagNumber(4)
  Vec2 ensureEndTangent() => $_ensure(3);

  @$pb.TagNumber(5)
  EdgeStyle get style => $_getN(4);
  @$pb.TagNumber(5)
  set style(EdgeStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  EdgeStyle ensureStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  CellRef get parent => $_getN(5);
  @$pb.TagNumber(6)
  set parent(CellRef value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasParent() => $_has(5);
  @$pb.TagNumber(6)
  void clearParent() => $_clearField(6);
  @$pb.TagNumber(6)
  CellRef ensureParent() => $_ensure(5);
}

class FaceStatement extends $pb.GeneratedMessage {
  factory FaceStatement({
    ChainSelector? outer,
    $core.Iterable<ChainSelector>? holes,
    FaceStyle? style,
    CellRef? parent,
  }) {
    final result = create();
    if (outer != null) result.outer = outer;
    if (holes != null) result.holes.addAll(holes);
    if (style != null) result.style = style;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<ChainSelector>(1, _omitFieldNames ? '' : 'outer',
        subBuilder: ChainSelector.create)
    ..pPM<ChainSelector>(2, _omitFieldNames ? '' : 'holes',
        subBuilder: ChainSelector.create)
    ..aOM<FaceStyle>(3, _omitFieldNames ? '' : 'style',
        subBuilder: FaceStyle.create)
    ..aOM<CellRef>(4, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  ChainSelector get outer => $_getN(0);
  @$pb.TagNumber(1)
  set outer(ChainSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOuter() => $_has(0);
  @$pb.TagNumber(1)
  void clearOuter() => $_clearField(1);
  @$pb.TagNumber(1)
  ChainSelector ensureOuter() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ChainSelector> get holes => $_getList(1);

  @$pb.TagNumber(3)
  FaceStyle get style => $_getN(2);
  @$pb.TagNumber(3)
  set style(FaceStyle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);
  @$pb.TagNumber(3)
  FaceStyle ensureStyle() => $_ensure(2);

  @$pb.TagNumber(4)
  CellRef get parent => $_getN(3);
  @$pb.TagNumber(4)
  set parent(CellRef value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasParent() => $_has(3);
  @$pb.TagNumber(4)
  void clearParent() => $_clearField(4);
  @$pb.TagNumber(4)
  CellRef ensureParent() => $_ensure(3);
}

class CutEdgeStatement extends $pb.GeneratedMessage {
  factory CutEdgeStatement({
    SingleSelector? target,
    $core.double? t,
  }) {
    final result = create();
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<SingleSelector>(1, _omitFieldNames ? '' : 'target',
        subBuilder: SingleSelector.create)
    ..aD(2, _omitFieldNames ? '' : 't')
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
  SingleSelector get target => $_getN(0);
  @$pb.TagNumber(1)
  set target(SingleSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  SingleSelector ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get t => $_getN(1);
  @$pb.TagNumber(2)
  set t($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasT() => $_has(1);
  @$pb.TagNumber(2)
  void clearT() => $_clearField(2);
}

class MultiCutEdgeStatement extends $pb.GeneratedMessage {
  factory MultiCutEdgeStatement({
    SingleSelector? target,
    $core.Iterable<$core.double>? ts,
  }) {
    final result = create();
    if (target != null) result.target = target;
    if (ts != null) result.ts.addAll(ts);
    return result;
  }

  MultiCutEdgeStatement._();

  factory MultiCutEdgeStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MultiCutEdgeStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiCutEdgeStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<SingleSelector>(1, _omitFieldNames ? '' : 'target',
        subBuilder: SingleSelector.create)
    ..p<$core.double>(2, _omitFieldNames ? '' : 'ts', $pb.PbFieldType.KD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiCutEdgeStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiCutEdgeStatement copyWith(
          void Function(MultiCutEdgeStatement) updates) =>
      super.copyWith((message) => updates(message as MultiCutEdgeStatement))
          as MultiCutEdgeStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiCutEdgeStatement create() => MultiCutEdgeStatement._();
  @$core.override
  MultiCutEdgeStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MultiCutEdgeStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MultiCutEdgeStatement>(create);
  static MultiCutEdgeStatement? _defaultInstance;

  @$pb.TagNumber(1)
  SingleSelector get target => $_getN(0);
  @$pb.TagNumber(1)
  set target(SingleSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTarget() => $_has(0);
  @$pb.TagNumber(1)
  void clearTarget() => $_clearField(1);
  @$pb.TagNumber(1)
  SingleSelector ensureTarget() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get ts => $_getList(1);
}

class FilletFaceStatement_CornerEntry extends $pb.GeneratedMessage {
  factory FilletFaceStatement_CornerEntry({
    $core.int? index,
    CornerRadius? radius,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (radius != null) result.radius = radius;
    return result;
  }

  FilletFaceStatement_CornerEntry._();

  factory FilletFaceStatement_CornerEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilletFaceStatement_CornerEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilletFaceStatement.CornerEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index')
    ..aOM<CornerRadius>(2, _omitFieldNames ? '' : 'radius',
        subBuilder: CornerRadius.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletFaceStatement_CornerEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletFaceStatement_CornerEntry copyWith(
          void Function(FilletFaceStatement_CornerEntry) updates) =>
      super.copyWith(
              (message) => updates(message as FilletFaceStatement_CornerEntry))
          as FilletFaceStatement_CornerEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilletFaceStatement_CornerEntry create() =>
      FilletFaceStatement_CornerEntry._();
  @$core.override
  FilletFaceStatement_CornerEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilletFaceStatement_CornerEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilletFaceStatement_CornerEntry>(
          create);
  static FilletFaceStatement_CornerEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  CornerRadius get radius => $_getN(1);
  @$pb.TagNumber(2)
  set radius(CornerRadius value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRadius() => $_has(1);
  @$pb.TagNumber(2)
  void clearRadius() => $_clearField(2);
  @$pb.TagNumber(2)
  CornerRadius ensureRadius() => $_ensure(1);
}

class FilletFaceStatement extends $pb.GeneratedMessage {
  factory FilletFaceStatement({
    SingleSelector? face,
    $core.Iterable<FilletFaceStatement_CornerEntry>? corners,
    CornerRadius? radius,
  }) {
    final result = create();
    if (face != null) result.face = face;
    if (corners != null) result.corners.addAll(corners);
    if (radius != null) result.radius = radius;
    return result;
  }

  FilletFaceStatement._();

  factory FilletFaceStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilletFaceStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilletFaceStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<SingleSelector>(1, _omitFieldNames ? '' : 'face',
        subBuilder: SingleSelector.create)
    ..pPM<FilletFaceStatement_CornerEntry>(2, _omitFieldNames ? '' : 'corners',
        subBuilder: FilletFaceStatement_CornerEntry.create)
    ..aOM<CornerRadius>(3, _omitFieldNames ? '' : 'radius',
        subBuilder: CornerRadius.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletFaceStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletFaceStatement copyWith(void Function(FilletFaceStatement) updates) =>
      super.copyWith((message) => updates(message as FilletFaceStatement))
          as FilletFaceStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilletFaceStatement create() => FilletFaceStatement._();
  @$core.override
  FilletFaceStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilletFaceStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilletFaceStatement>(create);
  static FilletFaceStatement? _defaultInstance;

  @$pb.TagNumber(1)
  SingleSelector get face => $_getN(0);
  @$pb.TagNumber(1)
  set face(SingleSelector value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFace() => $_has(0);
  @$pb.TagNumber(1)
  void clearFace() => $_clearField(1);
  @$pb.TagNumber(1)
  SingleSelector ensureFace() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FilletFaceStatement_CornerEntry> get corners => $_getList(1);

  @$pb.TagNumber(3)
  CornerRadius get radius => $_getN(2);
  @$pb.TagNumber(3)
  set radius(CornerRadius value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRadius() => $_has(2);
  @$pb.TagNumber(3)
  void clearRadius() => $_clearField(3);
  @$pb.TagNumber(3)
  CornerRadius ensureRadius() => $_ensure(2);
}

class GlueVerticesStatement extends $pb.GeneratedMessage {
  factory GlueVerticesStatement({
    $core.Iterable<SingleSelector>? vertices,
    GlueVerticesStatement_Position? position,
  }) {
    final result = create();
    if (vertices != null) result.vertices.addAll(vertices);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<SingleSelector>(1, _omitFieldNames ? '' : 'vertices',
        subBuilder: SingleSelector.create)
    ..aE<GlueVerticesStatement_Position>(2, _omitFieldNames ? '' : 'position',
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
  $pb.PbList<SingleSelector> get vertices => $_getList(0);

  @$pb.TagNumber(2)
  GlueVerticesStatement_Position get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(GlueVerticesStatement_Position value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
}

class RectangleStatement extends $pb.GeneratedMessage {
  factory RectangleStatement({
    LayoutSize? size,
    Mat4? transform,
    ObjectShape_Rectangle? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    CellRef? parent,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (transform != null) result.transform = transform;
    if (shape != null) result.shape = shape;
    if (vertexStyle != null) result.vertexStyle = vertexStyle;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<LayoutSize>(1, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<Mat4>(2, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<ObjectShape_Rectangle>(3, _omitFieldNames ? '' : 'shape',
        subBuilder: ObjectShape_Rectangle.create)
    ..aOM<VertexStyle>(4, _omitFieldNames ? '' : 'vertexStyle',
        subBuilder: VertexStyle.create)
    ..aOM<EdgeStyle>(5, _omitFieldNames ? '' : 'edgeStyle',
        subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(6, _omitFieldNames ? '' : 'faceStyle',
        subBuilder: FaceStyle.create)
    ..aOM<CellRef>(7, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  LayoutSize get size => $_getN(0);
  @$pb.TagNumber(1)
  set size(LayoutSize value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);
  @$pb.TagNumber(1)
  LayoutSize ensureSize() => $_ensure(0);

  @$pb.TagNumber(2)
  Mat4 get transform => $_getN(1);
  @$pb.TagNumber(2)
  set transform(Mat4 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransform() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransform() => $_clearField(2);
  @$pb.TagNumber(2)
  Mat4 ensureTransform() => $_ensure(1);

  @$pb.TagNumber(3)
  ObjectShape_Rectangle get shape => $_getN(2);
  @$pb.TagNumber(3)
  set shape(ObjectShape_Rectangle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShape() => $_has(2);
  @$pb.TagNumber(3)
  void clearShape() => $_clearField(3);
  @$pb.TagNumber(3)
  ObjectShape_Rectangle ensureShape() => $_ensure(2);

  @$pb.TagNumber(4)
  VertexStyle get vertexStyle => $_getN(3);
  @$pb.TagNumber(4)
  set vertexStyle(VertexStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVertexStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearVertexStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  VertexStyle ensureVertexStyle() => $_ensure(3);

  @$pb.TagNumber(5)
  EdgeStyle get edgeStyle => $_getN(4);
  @$pb.TagNumber(5)
  set edgeStyle(EdgeStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEdgeStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearEdgeStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  EdgeStyle ensureEdgeStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  FaceStyle get faceStyle => $_getN(5);
  @$pb.TagNumber(6)
  set faceStyle(FaceStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFaceStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaceStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  FaceStyle ensureFaceStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  CellRef get parent => $_getN(6);
  @$pb.TagNumber(7)
  set parent(CellRef value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasParent() => $_has(6);
  @$pb.TagNumber(7)
  void clearParent() => $_clearField(7);
  @$pb.TagNumber(7)
  CellRef ensureParent() => $_ensure(6);
}

class PolygonStatement extends $pb.GeneratedMessage {
  factory PolygonStatement({
    LayoutSize? size,
    Mat4? transform,
    ObjectShape_Polygon? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    CellRef? parent,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (transform != null) result.transform = transform;
    if (shape != null) result.shape = shape;
    if (vertexStyle != null) result.vertexStyle = vertexStyle;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    if (parent != null) result.parent = parent;
    return result;
  }

  PolygonStatement._();

  factory PolygonStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PolygonStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PolygonStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<LayoutSize>(1, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<Mat4>(2, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<ObjectShape_Polygon>(3, _omitFieldNames ? '' : 'shape',
        subBuilder: ObjectShape_Polygon.create)
    ..aOM<VertexStyle>(4, _omitFieldNames ? '' : 'vertexStyle',
        subBuilder: VertexStyle.create)
    ..aOM<EdgeStyle>(5, _omitFieldNames ? '' : 'edgeStyle',
        subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(6, _omitFieldNames ? '' : 'faceStyle',
        subBuilder: FaceStyle.create)
    ..aOM<CellRef>(7, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolygonStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolygonStatement copyWith(void Function(PolygonStatement) updates) =>
      super.copyWith((message) => updates(message as PolygonStatement))
          as PolygonStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolygonStatement create() => PolygonStatement._();
  @$core.override
  PolygonStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PolygonStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PolygonStatement>(create);
  static PolygonStatement? _defaultInstance;

  @$pb.TagNumber(1)
  LayoutSize get size => $_getN(0);
  @$pb.TagNumber(1)
  set size(LayoutSize value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);
  @$pb.TagNumber(1)
  LayoutSize ensureSize() => $_ensure(0);

  @$pb.TagNumber(2)
  Mat4 get transform => $_getN(1);
  @$pb.TagNumber(2)
  set transform(Mat4 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransform() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransform() => $_clearField(2);
  @$pb.TagNumber(2)
  Mat4 ensureTransform() => $_ensure(1);

  @$pb.TagNumber(3)
  ObjectShape_Polygon get shape => $_getN(2);
  @$pb.TagNumber(3)
  set shape(ObjectShape_Polygon value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShape() => $_has(2);
  @$pb.TagNumber(3)
  void clearShape() => $_clearField(3);
  @$pb.TagNumber(3)
  ObjectShape_Polygon ensureShape() => $_ensure(2);

  @$pb.TagNumber(4)
  VertexStyle get vertexStyle => $_getN(3);
  @$pb.TagNumber(4)
  set vertexStyle(VertexStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVertexStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearVertexStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  VertexStyle ensureVertexStyle() => $_ensure(3);

  @$pb.TagNumber(5)
  EdgeStyle get edgeStyle => $_getN(4);
  @$pb.TagNumber(5)
  set edgeStyle(EdgeStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEdgeStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearEdgeStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  EdgeStyle ensureEdgeStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  FaceStyle get faceStyle => $_getN(5);
  @$pb.TagNumber(6)
  set faceStyle(FaceStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFaceStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaceStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  FaceStyle ensureFaceStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  CellRef get parent => $_getN(6);
  @$pb.TagNumber(7)
  set parent(CellRef value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasParent() => $_has(6);
  @$pb.TagNumber(7)
  void clearParent() => $_clearField(7);
  @$pb.TagNumber(7)
  CellRef ensureParent() => $_ensure(6);
}

class EllipseStatement extends $pb.GeneratedMessage {
  factory EllipseStatement({
    LayoutSize? size,
    Mat4? transform,
    ObjectShape_Ellipse? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    CellRef? parent,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (transform != null) result.transform = transform;
    if (shape != null) result.shape = shape;
    if (vertexStyle != null) result.vertexStyle = vertexStyle;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    if (parent != null) result.parent = parent;
    return result;
  }

  EllipseStatement._();

  factory EllipseStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EllipseStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EllipseStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<LayoutSize>(1, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<Mat4>(2, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<ObjectShape_Ellipse>(3, _omitFieldNames ? '' : 'shape',
        subBuilder: ObjectShape_Ellipse.create)
    ..aOM<VertexStyle>(4, _omitFieldNames ? '' : 'vertexStyle',
        subBuilder: VertexStyle.create)
    ..aOM<EdgeStyle>(5, _omitFieldNames ? '' : 'edgeStyle',
        subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(6, _omitFieldNames ? '' : 'faceStyle',
        subBuilder: FaceStyle.create)
    ..aOM<CellRef>(7, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EllipseStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EllipseStatement copyWith(void Function(EllipseStatement) updates) =>
      super.copyWith((message) => updates(message as EllipseStatement))
          as EllipseStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EllipseStatement create() => EllipseStatement._();
  @$core.override
  EllipseStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EllipseStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EllipseStatement>(create);
  static EllipseStatement? _defaultInstance;

  @$pb.TagNumber(1)
  LayoutSize get size => $_getN(0);
  @$pb.TagNumber(1)
  set size(LayoutSize value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);
  @$pb.TagNumber(1)
  LayoutSize ensureSize() => $_ensure(0);

  @$pb.TagNumber(2)
  Mat4 get transform => $_getN(1);
  @$pb.TagNumber(2)
  set transform(Mat4 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransform() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransform() => $_clearField(2);
  @$pb.TagNumber(2)
  Mat4 ensureTransform() => $_ensure(1);

  @$pb.TagNumber(3)
  ObjectShape_Ellipse get shape => $_getN(2);
  @$pb.TagNumber(3)
  set shape(ObjectShape_Ellipse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShape() => $_has(2);
  @$pb.TagNumber(3)
  void clearShape() => $_clearField(3);
  @$pb.TagNumber(3)
  ObjectShape_Ellipse ensureShape() => $_ensure(2);

  @$pb.TagNumber(4)
  VertexStyle get vertexStyle => $_getN(3);
  @$pb.TagNumber(4)
  set vertexStyle(VertexStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVertexStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearVertexStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  VertexStyle ensureVertexStyle() => $_ensure(3);

  @$pb.TagNumber(5)
  EdgeStyle get edgeStyle => $_getN(4);
  @$pb.TagNumber(5)
  set edgeStyle(EdgeStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEdgeStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearEdgeStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  EdgeStyle ensureEdgeStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  FaceStyle get faceStyle => $_getN(5);
  @$pb.TagNumber(6)
  set faceStyle(FaceStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFaceStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaceStyle() => $_clearField(6);
  @$pb.TagNumber(6)
  FaceStyle ensureFaceStyle() => $_ensure(5);

  @$pb.TagNumber(7)
  CellRef get parent => $_getN(6);
  @$pb.TagNumber(7)
  set parent(CellRef value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasParent() => $_has(6);
  @$pb.TagNumber(7)
  void clearParent() => $_clearField(7);
  @$pb.TagNumber(7)
  CellRef ensureParent() => $_ensure(6);
}

class ContainerStatement extends $pb.GeneratedMessage {
  factory ContainerStatement({
    Layout? layout,
    LayoutSize? size,
    Mat4? transform,
    ObjectShape? shape,
    VertexStyle? vertexStyle,
    EdgeStyle? edgeStyle,
    FaceStyle? faceStyle,
    CellRef? parent,
  }) {
    final result = create();
    if (layout != null) result.layout = layout;
    if (size != null) result.size = size;
    if (transform != null) result.transform = transform;
    if (shape != null) result.shape = shape;
    if (vertexStyle != null) result.vertexStyle = vertexStyle;
    if (edgeStyle != null) result.edgeStyle = edgeStyle;
    if (faceStyle != null) result.faceStyle = faceStyle;
    if (parent != null) result.parent = parent;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..aOM<LayoutSize>(2, _omitFieldNames ? '' : 'size',
        subBuilder: LayoutSize.create)
    ..aOM<Mat4>(3, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..aOM<ObjectShape>(4, _omitFieldNames ? '' : 'shape',
        subBuilder: ObjectShape.create)
    ..aOM<VertexStyle>(5, _omitFieldNames ? '' : 'vertexStyle',
        subBuilder: VertexStyle.create)
    ..aOM<EdgeStyle>(6, _omitFieldNames ? '' : 'edgeStyle',
        subBuilder: EdgeStyle.create)
    ..aOM<FaceStyle>(7, _omitFieldNames ? '' : 'faceStyle',
        subBuilder: FaceStyle.create)
    ..aOM<CellRef>(8, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
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
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);

  @$pb.TagNumber(2)
  LayoutSize get size => $_getN(1);
  @$pb.TagNumber(2)
  set size(LayoutSize value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);
  @$pb.TagNumber(2)
  LayoutSize ensureSize() => $_ensure(1);

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
  ObjectShape get shape => $_getN(3);
  @$pb.TagNumber(4)
  set shape(ObjectShape value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasShape() => $_has(3);
  @$pb.TagNumber(4)
  void clearShape() => $_clearField(4);
  @$pb.TagNumber(4)
  ObjectShape ensureShape() => $_ensure(3);

  @$pb.TagNumber(5)
  VertexStyle get vertexStyle => $_getN(4);
  @$pb.TagNumber(5)
  set vertexStyle(VertexStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVertexStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearVertexStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  VertexStyle ensureVertexStyle() => $_ensure(4);

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

  @$pb.TagNumber(8)
  CellRef get parent => $_getN(7);
  @$pb.TagNumber(8)
  set parent(CellRef value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasParent() => $_has(7);
  @$pb.TagNumber(8)
  void clearParent() => $_clearField(8);
  @$pb.TagNumber(8)
  CellRef ensureParent() => $_ensure(7);
}

class GroupStatement extends $pb.GeneratedMessage {
  factory GroupStatement({
    CellRef? parent,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    return result;
  }

  GroupStatement._();

  factory GroupStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupStatement copyWith(void Function(GroupStatement) updates) =>
      super.copyWith((message) => updates(message as GroupStatement))
          as GroupStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupStatement create() => GroupStatement._();
  @$core.override
  GroupStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupStatement>(create);
  static GroupStatement? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get parent => $_getN(0);
  @$pb.TagNumber(1)
  set parent(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureParent() => $_ensure(0);
}

class GeneratorStatement extends $pb.GeneratedMessage {
  factory GeneratorStatement({
    Generator? generator,
    $core.Iterable<FragmentSelector>? inputs,
    CellRef? parent,
    Mat4? transform,
  }) {
    final result = create();
    if (generator != null) result.generator = generator;
    if (inputs != null) result.inputs.addAll(inputs);
    if (parent != null) result.parent = parent;
    if (transform != null) result.transform = transform;
    return result;
  }

  GeneratorStatement._();

  factory GeneratorStatement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GeneratorStatement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeneratorStatement',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Generator>(1, _omitFieldNames ? '' : 'generator',
        subBuilder: Generator.create)
    ..pPM<FragmentSelector>(2, _omitFieldNames ? '' : 'inputs',
        subBuilder: FragmentSelector.create)
    ..aOM<CellRef>(3, _omitFieldNames ? '' : 'parent',
        subBuilder: CellRef.create)
    ..aOM<Mat4>(4, _omitFieldNames ? '' : 'transform', subBuilder: Mat4.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneratorStatement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneratorStatement copyWith(void Function(GeneratorStatement) updates) =>
      super.copyWith((message) => updates(message as GeneratorStatement))
          as GeneratorStatement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeneratorStatement create() => GeneratorStatement._();
  @$core.override
  GeneratorStatement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GeneratorStatement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GeneratorStatement>(create);
  static GeneratorStatement? _defaultInstance;

  @$pb.TagNumber(1)
  Generator get generator => $_getN(0);
  @$pb.TagNumber(1)
  set generator(Generator value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGenerator() => $_has(0);
  @$pb.TagNumber(1)
  void clearGenerator() => $_clearField(1);
  @$pb.TagNumber(1)
  Generator ensureGenerator() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FragmentSelector> get inputs => $_getList(1);

  @$pb.TagNumber(3)
  CellRef get parent => $_getN(2);
  @$pb.TagNumber(3)
  set parent(CellRef value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearParent() => $_clearField(3);
  @$pb.TagNumber(3)
  CellRef ensureParent() => $_ensure(2);

  @$pb.TagNumber(4)
  Mat4 get transform => $_getN(3);
  @$pb.TagNumber(4)
  set transform(Mat4 value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTransform() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransform() => $_clearField(4);
  @$pb.TagNumber(4)
  Mat4 ensureTransform() => $_ensure(3);
}

class ObjectShape_Rectangle extends $pb.GeneratedMessage {
  factory ObjectShape_Rectangle() => create();

  ObjectShape_Rectangle._();

  factory ObjectShape_Rectangle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObjectShape_Rectangle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectShape.Rectangle',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Rectangle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Rectangle copyWith(
          void Function(ObjectShape_Rectangle) updates) =>
      super.copyWith((message) => updates(message as ObjectShape_Rectangle))
          as ObjectShape_Rectangle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectShape_Rectangle create() => ObjectShape_Rectangle._();
  @$core.override
  ObjectShape_Rectangle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObjectShape_Rectangle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObjectShape_Rectangle>(create);
  static ObjectShape_Rectangle? _defaultInstance;
}

class ObjectShape_Polygon extends $pb.GeneratedMessage {
  factory ObjectShape_Polygon({
    $core.int? sides,
  }) {
    final result = create();
    if (sides != null) result.sides = sides;
    return result;
  }

  ObjectShape_Polygon._();

  factory ObjectShape_Polygon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObjectShape_Polygon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectShape.Polygon',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sides')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Polygon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Polygon copyWith(void Function(ObjectShape_Polygon) updates) =>
      super.copyWith((message) => updates(message as ObjectShape_Polygon))
          as ObjectShape_Polygon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectShape_Polygon create() => ObjectShape_Polygon._();
  @$core.override
  ObjectShape_Polygon createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObjectShape_Polygon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObjectShape_Polygon>(create);
  static ObjectShape_Polygon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sides => $_getIZ(0);
  @$pb.TagNumber(1)
  set sides($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSides() => $_has(0);
  @$pb.TagNumber(1)
  void clearSides() => $_clearField(1);
}

class ObjectShape_Ellipse extends $pb.GeneratedMessage {
  factory ObjectShape_Ellipse() => create();

  ObjectShape_Ellipse._();

  factory ObjectShape_Ellipse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObjectShape_Ellipse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectShape.Ellipse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Ellipse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectShape_Ellipse copyWith(void Function(ObjectShape_Ellipse) updates) =>
      super.copyWith((message) => updates(message as ObjectShape_Ellipse))
          as ObjectShape_Ellipse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObjectShape_Ellipse create() => ObjectShape_Ellipse._();
  @$core.override
  ObjectShape_Ellipse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObjectShape_Ellipse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObjectShape_Ellipse>(create);
  static ObjectShape_Ellipse? _defaultInstance;
}

enum ObjectShape_Value { rectangle, polygon, ellipse, notSet }

class ObjectShape extends $pb.GeneratedMessage {
  factory ObjectShape({
    ObjectShape_Rectangle? rectangle,
    ObjectShape_Polygon? polygon,
    ObjectShape_Ellipse? ellipse,
  }) {
    final result = create();
    if (rectangle != null) result.rectangle = rectangle;
    if (polygon != null) result.polygon = polygon;
    if (ellipse != null) result.ellipse = ellipse;
    return result;
  }

  ObjectShape._();

  factory ObjectShape.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObjectShape.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ObjectShape_Value> _ObjectShape_ValueByTag =
      {
    1: ObjectShape_Value.rectangle,
    2: ObjectShape_Value.polygon,
    3: ObjectShape_Value.ellipse,
    0: ObjectShape_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectShape',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ObjectShape_Rectangle>(1, _omitFieldNames ? '' : 'rectangle',
        subBuilder: ObjectShape_Rectangle.create)
    ..aOM<ObjectShape_Polygon>(2, _omitFieldNames ? '' : 'polygon',
        subBuilder: ObjectShape_Polygon.create)
    ..aOM<ObjectShape_Ellipse>(3, _omitFieldNames ? '' : 'ellipse',
        subBuilder: ObjectShape_Ellipse.create)
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
  ObjectShape_Value whichValue() => _ObjectShape_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ObjectShape_Rectangle get rectangle => $_getN(0);
  @$pb.TagNumber(1)
  set rectangle(ObjectShape_Rectangle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRectangle() => $_has(0);
  @$pb.TagNumber(1)
  void clearRectangle() => $_clearField(1);
  @$pb.TagNumber(1)
  ObjectShape_Rectangle ensureRectangle() => $_ensure(0);

  @$pb.TagNumber(2)
  ObjectShape_Polygon get polygon => $_getN(1);
  @$pb.TagNumber(2)
  set polygon(ObjectShape_Polygon value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPolygon() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolygon() => $_clearField(2);
  @$pb.TagNumber(2)
  ObjectShape_Polygon ensurePolygon() => $_ensure(1);

  @$pb.TagNumber(3)
  ObjectShape_Ellipse get ellipse => $_getN(2);
  @$pb.TagNumber(3)
  set ellipse(ObjectShape_Ellipse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEllipse() => $_has(2);
  @$pb.TagNumber(3)
  void clearEllipse() => $_clearField(3);
  @$pb.TagNumber(3)
  ObjectShape_Ellipse ensureEllipse() => $_ensure(2);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
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

class LayoutDimension_Range extends $pb.GeneratedMessage {
  factory LayoutDimension_Range({
    $core.double? min,
    $core.double? max,
  }) {
    final result = create();
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  LayoutDimension_Range._();

  factory LayoutDimension_Range.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LayoutDimension_Range.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayoutDimension.Range',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'min')
    ..aD(2, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutDimension_Range clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayoutDimension_Range copyWith(
          void Function(LayoutDimension_Range) updates) =>
      super.copyWith((message) => updates(message as LayoutDimension_Range))
          as LayoutDimension_Range;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutDimension_Range create() => LayoutDimension_Range._();
  @$core.override
  LayoutDimension_Range createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LayoutDimension_Range getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayoutDimension_Range>(create);
  static LayoutDimension_Range? _defaultInstance;

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
    LayoutDimension_Range? range,
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aE<LayoutDimension_Type>(2, _omitFieldNames ? '' : 'type',
        enumValues: LayoutDimension_Type.values)
    ..aOM<LayoutDimension_Range>(3, _omitFieldNames ? '' : 'range',
        subBuilder: LayoutDimension_Range.create)
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
  LayoutDimension_Range get range => $_getN(2);
  @$pb.TagNumber(3)
  set range(LayoutDimension_Range value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearRange() => $_clearField(3);
  @$pb.TagNumber(3)
  LayoutDimension_Range ensureRange() => $_ensure(2);
}

class Layout_Insets extends $pb.GeneratedMessage {
  factory Layout_Insets({
    $core.double? top,
    $core.double? right,
    $core.double? bottom,
    $core.double? left,
  }) {
    final result = create();
    if (top != null) result.top = top;
    if (right != null) result.right = right;
    if (bottom != null) result.bottom = bottom;
    if (left != null) result.left = left;
    return result;
  }

  Layout_Insets._();

  factory Layout_Insets.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Layout_Insets.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Layout.Insets',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'top')
    ..aD(2, _omitFieldNames ? '' : 'right')
    ..aD(3, _omitFieldNames ? '' : 'bottom')
    ..aD(4, _omitFieldNames ? '' : 'left')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Insets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Insets copyWith(void Function(Layout_Insets) updates) =>
      super.copyWith((message) => updates(message as Layout_Insets))
          as Layout_Insets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Layout_Insets create() => Layout_Insets._();
  @$core.override
  Layout_Insets createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Layout_Insets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Layout_Insets>(create);
  static Layout_Insets? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get top => $_getN(0);
  @$pb.TagNumber(1)
  set top($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTop() => $_has(0);
  @$pb.TagNumber(1)
  void clearTop() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get right => $_getN(1);
  @$pb.TagNumber(2)
  set right($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get bottom => $_getN(2);
  @$pb.TagNumber(3)
  set bottom($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBottom() => $_has(2);
  @$pb.TagNumber(3)
  void clearBottom() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get left => $_getN(3);
  @$pb.TagNumber(4)
  set left($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearLeft() => $_clearField(4);
}

class Layout_Stack extends $pb.GeneratedMessage {
  factory Layout_Stack({
    Layout_Align? alignHorizontal,
    Layout_Align? alignVertical,
    Layout_Insets? padding,
  }) {
    final result = create();
    if (alignHorizontal != null) result.alignHorizontal = alignHorizontal;
    if (alignVertical != null) result.alignVertical = alignVertical;
    if (padding != null) result.padding = padding;
    return result;
  }

  Layout_Stack._();

  factory Layout_Stack.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Layout_Stack.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Layout.Stack',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aE<Layout_Align>(1, _omitFieldNames ? '' : 'alignHorizontal',
        enumValues: Layout_Align.values)
    ..aE<Layout_Align>(2, _omitFieldNames ? '' : 'alignVertical',
        enumValues: Layout_Align.values)
    ..aOM<Layout_Insets>(5, _omitFieldNames ? '' : 'padding',
        subBuilder: Layout_Insets.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Stack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Stack copyWith(void Function(Layout_Stack) updates) =>
      super.copyWith((message) => updates(message as Layout_Stack))
          as Layout_Stack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Layout_Stack create() => Layout_Stack._();
  @$core.override
  Layout_Stack createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Layout_Stack getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Layout_Stack>(create);
  static Layout_Stack? _defaultInstance;

  @$pb.TagNumber(1)
  Layout_Align get alignHorizontal => $_getN(0);
  @$pb.TagNumber(1)
  set alignHorizontal(Layout_Align value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlignHorizontal() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlignHorizontal() => $_clearField(1);

  @$pb.TagNumber(2)
  Layout_Align get alignVertical => $_getN(1);
  @$pb.TagNumber(2)
  set alignVertical(Layout_Align value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAlignVertical() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlignVertical() => $_clearField(2);

  @$pb.TagNumber(5)
  Layout_Insets get padding => $_getN(2);
  @$pb.TagNumber(5)
  set padding(Layout_Insets value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPadding() => $_has(2);
  @$pb.TagNumber(5)
  void clearPadding() => $_clearField(5);
  @$pb.TagNumber(5)
  Layout_Insets ensurePadding() => $_ensure(2);
}

class Layout_Flex extends $pb.GeneratedMessage {
  factory Layout_Flex({
    Layout_Flex_Direction? direction,
    Layout_Justify? justify,
    Layout_Align? crossAlign,
    $core.double? gap,
    Layout_Insets? padding,
  }) {
    final result = create();
    if (direction != null) result.direction = direction;
    if (justify != null) result.justify = justify;
    if (crossAlign != null) result.crossAlign = crossAlign;
    if (gap != null) result.gap = gap;
    if (padding != null) result.padding = padding;
    return result;
  }

  Layout_Flex._();

  factory Layout_Flex.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Layout_Flex.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Layout.Flex',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aE<Layout_Flex_Direction>(1, _omitFieldNames ? '' : 'direction',
        enumValues: Layout_Flex_Direction.values)
    ..aE<Layout_Justify>(2, _omitFieldNames ? '' : 'justify',
        enumValues: Layout_Justify.values)
    ..aE<Layout_Align>(3, _omitFieldNames ? '' : 'crossAlign',
        enumValues: Layout_Align.values)
    ..aD(4, _omitFieldNames ? '' : 'gap')
    ..aOM<Layout_Insets>(5, _omitFieldNames ? '' : 'padding',
        subBuilder: Layout_Insets.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Flex clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout_Flex copyWith(void Function(Layout_Flex) updates) =>
      super.copyWith((message) => updates(message as Layout_Flex))
          as Layout_Flex;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Layout_Flex create() => Layout_Flex._();
  @$core.override
  Layout_Flex createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Layout_Flex getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Layout_Flex>(create);
  static Layout_Flex? _defaultInstance;

  @$pb.TagNumber(1)
  Layout_Flex_Direction get direction => $_getN(0);
  @$pb.TagNumber(1)
  set direction(Layout_Flex_Direction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDirection() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirection() => $_clearField(1);

  @$pb.TagNumber(2)
  Layout_Justify get justify => $_getN(1);
  @$pb.TagNumber(2)
  set justify(Layout_Justify value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJustify() => $_has(1);
  @$pb.TagNumber(2)
  void clearJustify() => $_clearField(2);

  @$pb.TagNumber(3)
  Layout_Align get crossAlign => $_getN(2);
  @$pb.TagNumber(3)
  set crossAlign(Layout_Align value) => $_setField(3, value);
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
  Layout_Insets get padding => $_getN(4);
  @$pb.TagNumber(5)
  set padding(Layout_Insets value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPadding() => $_has(4);
  @$pb.TagNumber(5)
  void clearPadding() => $_clearField(5);
  @$pb.TagNumber(5)
  Layout_Insets ensurePadding() => $_ensure(4);
}

enum Layout_Value { stack, flex, notSet }

class Layout extends $pb.GeneratedMessage {
  factory Layout({
    Layout_Stack? stack,
    Layout_Flex? flex,
  }) {
    final result = create();
    if (stack != null) result.stack = stack;
    if (flex != null) result.flex = flex;
    return result;
  }

  Layout._();

  factory Layout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Layout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Layout_Value> _Layout_ValueByTag = {
    1: Layout_Value.stack,
    2: Layout_Value.flex,
    0: Layout_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Layout',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<Layout_Stack>(1, _omitFieldNames ? '' : 'stack',
        subBuilder: Layout_Stack.create)
    ..aOM<Layout_Flex>(2, _omitFieldNames ? '' : 'flex',
        subBuilder: Layout_Flex.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layout copyWith(void Function(Layout) updates) =>
      super.copyWith((message) => updates(message as Layout)) as Layout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Layout create() => Layout._();
  @$core.override
  Layout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Layout getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Layout>(create);
  static Layout? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  Layout_Value whichValue() => _Layout_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Layout_Stack get stack => $_getN(0);
  @$pb.TagNumber(1)
  set stack(Layout_Stack value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStack() => $_has(0);
  @$pb.TagNumber(1)
  void clearStack() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout_Stack ensureStack() => $_ensure(0);

  @$pb.TagNumber(2)
  Layout_Flex get flex => $_getN(1);
  @$pb.TagNumber(2)
  set flex(Layout_Flex value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFlex() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlex() => $_clearField(2);
  @$pb.TagNumber(2)
  Layout_Flex ensureFlex() => $_ensure(1);
}

class NodeId extends $pb.GeneratedMessage {
  factory NodeId({
    $fixnum.Int64? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  NodeId._();

  factory NodeId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NodeId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodeId',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeId copyWith(void Function(NodeId) updates) =>
      super.copyWith((message) => updates(message as NodeId)) as NodeId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodeId create() => NodeId._();
  @$core.override
  NodeId createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NodeId getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NodeId>(create);
  static NodeId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class Generator extends $pb.GeneratedMessage {
  factory Generator() => create();

  Generator._();

  factory Generator.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Generator.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Generator',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Generator clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Generator copyWith(void Function(Generator) updates) =>
      super.copyWith((message) => updates(message as Generator)) as Generator;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Generator create() => Generator._();
  @$core.override
  Generator createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Generator getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Generator>(create);
  static Generator? _defaultInstance;
}

enum Modifier_Value { fillet, notSet }

class Modifier extends $pb.GeneratedMessage {
  factory Modifier({
    FilletModifier? fillet,
  }) {
    final result = create();
    if (fillet != null) result.fillet = fillet;
    return result;
  }

  Modifier._();

  factory Modifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Modifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Modifier_Value> _Modifier_ValueByTag = {
    1: Modifier_Value.fillet,
    0: Modifier_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Modifier',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<FilletModifier>(1, _omitFieldNames ? '' : 'fillet',
        subBuilder: FilletModifier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Modifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Modifier copyWith(void Function(Modifier) updates) =>
      super.copyWith((message) => updates(message as Modifier)) as Modifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Modifier create() => Modifier._();
  @$core.override
  Modifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Modifier getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Modifier>(create);
  static Modifier? _defaultInstance;

  @$pb.TagNumber(1)
  Modifier_Value whichValue() => _Modifier_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  FilletModifier get fillet => $_getN(0);
  @$pb.TagNumber(1)
  set fillet(FilletModifier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFillet() => $_has(0);
  @$pb.TagNumber(1)
  void clearFillet() => $_clearField(1);
  @$pb.TagNumber(1)
  FilletModifier ensureFillet() => $_ensure(0);
}

class FilletModifier_Corner extends $pb.GeneratedMessage {
  factory FilletModifier_Corner({
    $core.int? index,
    CornerRadius? radius,
  }) {
    final result = create();
    if (index != null) result.index = index;
    if (radius != null) result.radius = radius;
    return result;
  }

  FilletModifier_Corner._();

  factory FilletModifier_Corner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilletModifier_Corner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilletModifier.Corner',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'index')
    ..aOM<CornerRadius>(2, _omitFieldNames ? '' : 'radius',
        subBuilder: CornerRadius.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletModifier_Corner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletModifier_Corner copyWith(
          void Function(FilletModifier_Corner) updates) =>
      super.copyWith((message) => updates(message as FilletModifier_Corner))
          as FilletModifier_Corner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilletModifier_Corner create() => FilletModifier_Corner._();
  @$core.override
  FilletModifier_Corner createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilletModifier_Corner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilletModifier_Corner>(create);
  static FilletModifier_Corner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  CornerRadius get radius => $_getN(1);
  @$pb.TagNumber(2)
  set radius(CornerRadius value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRadius() => $_has(1);
  @$pb.TagNumber(2)
  void clearRadius() => $_clearField(2);
  @$pb.TagNumber(2)
  CornerRadius ensureRadius() => $_ensure(1);
}

class FilletModifier extends $pb.GeneratedMessage {
  factory FilletModifier({
    CornerRadius? radius,
    $core.Iterable<FilletModifier_Corner>? corners,
  }) {
    final result = create();
    if (radius != null) result.radius = radius;
    if (corners != null) result.corners.addAll(corners);
    return result;
  }

  FilletModifier._();

  factory FilletModifier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilletModifier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilletModifier',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CornerRadius>(1, _omitFieldNames ? '' : 'radius',
        subBuilder: CornerRadius.create)
    ..pPM<FilletModifier_Corner>(2, _omitFieldNames ? '' : 'corners',
        subBuilder: FilletModifier_Corner.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletModifier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilletModifier copyWith(void Function(FilletModifier) updates) =>
      super.copyWith((message) => updates(message as FilletModifier))
          as FilletModifier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilletModifier create() => FilletModifier._();
  @$core.override
  FilletModifier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilletModifier getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilletModifier>(create);
  static FilletModifier? _defaultInstance;

  @$pb.TagNumber(1)
  CornerRadius get radius => $_getN(0);
  @$pb.TagNumber(1)
  set radius(CornerRadius value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRadius() => $_has(0);
  @$pb.TagNumber(1)
  void clearRadius() => $_clearField(1);
  @$pb.TagNumber(1)
  CornerRadius ensureRadius() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FilletModifier_Corner> get corners => $_getList(1);
}

class ProgramDelta extends $pb.GeneratedMessage {
  factory ProgramDelta({
    $core.Iterable<ProgramChange>? changes,
  }) {
    final result = create();
    if (changes != null) result.changes.addAll(changes);
    return result;
  }

  ProgramDelta._();

  factory ProgramDelta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProgramDelta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProgramDelta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..pPM<ProgramChange>(1, _omitFieldNames ? '' : 'changes',
        subBuilder: ProgramChange.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramDelta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramDelta copyWith(void Function(ProgramDelta) updates) =>
      super.copyWith((message) => updates(message as ProgramDelta))
          as ProgramDelta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProgramDelta create() => ProgramDelta._();
  @$core.override
  ProgramDelta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProgramDelta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProgramDelta>(create);
  static ProgramDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProgramChange> get changes => $_getList(0);
}

enum ProgramAnchor_Value { start, end, at, after, notSet }

class ProgramAnchor extends $pb.GeneratedMessage {
  factory ProgramAnchor({
    $core.bool? start,
    $core.bool? end,
    StatementId? at,
    StatementId? after,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (at != null) result.at = at;
    if (after != null) result.after = after;
    return result;
  }

  ProgramAnchor._();

  factory ProgramAnchor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProgramAnchor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ProgramAnchor_Value>
      _ProgramAnchor_ValueByTag = {
    1: ProgramAnchor_Value.start,
    2: ProgramAnchor_Value.end,
    3: ProgramAnchor_Value.at,
    4: ProgramAnchor_Value.after,
    0: ProgramAnchor_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProgramAnchor',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOB(1, _omitFieldNames ? '' : 'start')
    ..aOB(2, _omitFieldNames ? '' : 'end')
    ..aOM<StatementId>(3, _omitFieldNames ? '' : 'at',
        subBuilder: StatementId.create)
    ..aOM<StatementId>(4, _omitFieldNames ? '' : 'after',
        subBuilder: StatementId.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramAnchor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramAnchor copyWith(void Function(ProgramAnchor) updates) =>
      super.copyWith((message) => updates(message as ProgramAnchor))
          as ProgramAnchor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProgramAnchor create() => ProgramAnchor._();
  @$core.override
  ProgramAnchor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProgramAnchor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProgramAnchor>(create);
  static ProgramAnchor? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ProgramAnchor_Value whichValue() =>
      _ProgramAnchor_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get start => $_getBF(0);
  @$pb.TagNumber(1)
  set start($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get end => $_getBF(1);
  @$pb.TagNumber(2)
  set end($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  StatementId get at => $_getN(2);
  @$pb.TagNumber(3)
  set at(StatementId value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAt() => $_clearField(3);
  @$pb.TagNumber(3)
  StatementId ensureAt() => $_ensure(2);

  @$pb.TagNumber(4)
  StatementId get after => $_getN(3);
  @$pb.TagNumber(4)
  set after(StatementId value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAfter() => $_has(3);
  @$pb.TagNumber(4)
  void clearAfter() => $_clearField(4);
  @$pb.TagNumber(4)
  StatementId ensureAfter() => $_ensure(3);
}

class StatementChange extends $pb.GeneratedMessage {
  factory StatementChange({
    ProgramAnchor? anchor,
    $core.Iterable<Statement>? removed,
    $core.Iterable<Statement>? inserted,
  }) {
    final result = create();
    if (anchor != null) result.anchor = anchor;
    if (removed != null) result.removed.addAll(removed);
    if (inserted != null) result.inserted.addAll(inserted);
    return result;
  }

  StatementChange._();

  factory StatementChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatementChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatementChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<ProgramAnchor>(1, _omitFieldNames ? '' : 'anchor',
        subBuilder: ProgramAnchor.create)
    ..pPM<Statement>(2, _omitFieldNames ? '' : 'removed',
        subBuilder: Statement.create)
    ..pPM<Statement>(3, _omitFieldNames ? '' : 'inserted',
        subBuilder: Statement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementChange copyWith(void Function(StatementChange) updates) =>
      super.copyWith((message) => updates(message as StatementChange))
          as StatementChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatementChange create() => StatementChange._();
  @$core.override
  StatementChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatementChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatementChange>(create);
  static StatementChange? _defaultInstance;

  @$pb.TagNumber(1)
  ProgramAnchor get anchor => $_getN(0);
  @$pb.TagNumber(1)
  set anchor(ProgramAnchor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAnchor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnchor() => $_clearField(1);
  @$pb.TagNumber(1)
  ProgramAnchor ensureAnchor() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Statement> get removed => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Statement> get inserted => $_getList(2);
}

class StyleChange extends $pb.GeneratedMessage {
  factory StyleChange({
    CellRef? ref,
    CellStyle_Partial? before,
    CellStyle_Partial? after,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    if (before != null) result.before = before;
    if (after != null) result.after = after;
    return result;
  }

  StyleChange._();

  factory StyleChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StyleChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StyleChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..aOM<CellStyle_Partial>(2, _omitFieldNames ? '' : 'before',
        subBuilder: CellStyle_Partial.create)
    ..aOM<CellStyle_Partial>(3, _omitFieldNames ? '' : 'after',
        subBuilder: CellStyle_Partial.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StyleChange copyWith(void Function(StyleChange) updates) =>
      super.copyWith((message) => updates(message as StyleChange))
          as StyleChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StyleChange create() => StyleChange._();
  @$core.override
  StyleChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StyleChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StyleChange>(create);
  static StyleChange? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);

  @$pb.TagNumber(2)
  CellStyle_Partial get before => $_getN(1);
  @$pb.TagNumber(2)
  set before(CellStyle_Partial value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBefore() => $_has(1);
  @$pb.TagNumber(2)
  void clearBefore() => $_clearField(2);
  @$pb.TagNumber(2)
  CellStyle_Partial ensureBefore() => $_ensure(1);

  @$pb.TagNumber(3)
  CellStyle_Partial get after => $_getN(2);
  @$pb.TagNumber(3)
  set after(CellStyle_Partial value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAfter() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfter() => $_clearField(3);
  @$pb.TagNumber(3)
  CellStyle_Partial ensureAfter() => $_ensure(2);
}

class ZOrderChange extends $pb.GeneratedMessage {
  factory ZOrderChange({
    CellRef? ref,
    ZAnchor? before,
    ZAnchor? after,
  }) {
    final result = create();
    if (ref != null) result.ref = ref;
    if (before != null) result.before = before;
    if (after != null) result.after = after;
    return result;
  }

  ZOrderChange._();

  factory ZOrderChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ZOrderChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ZOrderChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<CellRef>(1, _omitFieldNames ? '' : 'ref', subBuilder: CellRef.create)
    ..aOM<ZAnchor>(2, _omitFieldNames ? '' : 'before',
        subBuilder: ZAnchor.create)
    ..aOM<ZAnchor>(3, _omitFieldNames ? '' : 'after',
        subBuilder: ZAnchor.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ZOrderChange copyWith(void Function(ZOrderChange) updates) =>
      super.copyWith((message) => updates(message as ZOrderChange))
          as ZOrderChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ZOrderChange create() => ZOrderChange._();
  @$core.override
  ZOrderChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ZOrderChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ZOrderChange>(create);
  static ZOrderChange? _defaultInstance;

  @$pb.TagNumber(1)
  CellRef get ref => $_getN(0);
  @$pb.TagNumber(1)
  set ref(CellRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRef() => $_has(0);
  @$pb.TagNumber(1)
  void clearRef() => $_clearField(1);
  @$pb.TagNumber(1)
  CellRef ensureRef() => $_ensure(0);

  @$pb.TagNumber(2)
  ZAnchor get before => $_getN(1);
  @$pb.TagNumber(2)
  set before(ZAnchor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBefore() => $_has(1);
  @$pb.TagNumber(2)
  void clearBefore() => $_clearField(2);
  @$pb.TagNumber(2)
  ZAnchor ensureBefore() => $_ensure(1);

  @$pb.TagNumber(3)
  ZAnchor get after => $_getN(2);
  @$pb.TagNumber(3)
  set after(ZAnchor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAfter() => $_has(2);
  @$pb.TagNumber(3)
  void clearAfter() => $_clearField(3);
  @$pb.TagNumber(3)
  ZAnchor ensureAfter() => $_ensure(2);
}

enum ProgramChange_Value { statement, style, zOrder, empty, notSet }

class ProgramChange extends $pb.GeneratedMessage {
  factory ProgramChange({
    StatementChange? statement,
    StyleChange? style,
    ZOrderChange? zOrder,
    $core.bool? empty,
  }) {
    final result = create();
    if (statement != null) result.statement = statement;
    if (style != null) result.style = style;
    if (zOrder != null) result.zOrder = zOrder;
    if (empty != null) result.empty = empty;
    return result;
  }

  ProgramChange._();

  factory ProgramChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProgramChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ProgramChange_Value>
      _ProgramChange_ValueByTag = {
    1: ProgramChange_Value.statement,
    2: ProgramChange_Value.style,
    3: ProgramChange_Value.zOrder,
    4: ProgramChange_Value.empty,
    0: ProgramChange_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProgramChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<StatementChange>(1, _omitFieldNames ? '' : 'statement',
        subBuilder: StatementChange.create)
    ..aOM<StyleChange>(2, _omitFieldNames ? '' : 'style',
        subBuilder: StyleChange.create)
    ..aOM<ZOrderChange>(3, _omitFieldNames ? '' : 'zOrder',
        subBuilder: ZOrderChange.create)
    ..aOB(4, _omitFieldNames ? '' : 'empty')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProgramChange copyWith(void Function(ProgramChange) updates) =>
      super.copyWith((message) => updates(message as ProgramChange))
          as ProgramChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProgramChange create() => ProgramChange._();
  @$core.override
  ProgramChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProgramChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProgramChange>(create);
  static ProgramChange? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ProgramChange_Value whichValue() =>
      _ProgramChange_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StatementChange get statement => $_getN(0);
  @$pb.TagNumber(1)
  set statement(StatementChange value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatement() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatement() => $_clearField(1);
  @$pb.TagNumber(1)
  StatementChange ensureStatement() => $_ensure(0);

  @$pb.TagNumber(2)
  StyleChange get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(StyleChange value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  StyleChange ensureStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  ZOrderChange get zOrder => $_getN(2);
  @$pb.TagNumber(3)
  set zOrder(ZOrderChange value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasZOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearZOrder() => $_clearField(3);
  @$pb.TagNumber(3)
  ZOrderChange ensureZOrder() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get empty => $_getBF(3);
  @$pb.TagNumber(4)
  set empty($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmpty() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmpty() => $_clearField(4);
}

class Mat4 extends $pb.GeneratedMessage {
  factory Mat4({
    $core.double? m00,
    $core.double? m01,
    $core.double? m02,
    $core.double? m03,
    $core.double? m10,
    $core.double? m11,
    $core.double? m12,
    $core.double? m13,
    $core.double? m20,
    $core.double? m21,
    $core.double? m22,
    $core.double? m23,
    $core.double? m30,
    $core.double? m31,
    $core.double? m32,
    $core.double? m33,
  }) {
    final result = create();
    if (m00 != null) result.m00 = m00;
    if (m01 != null) result.m01 = m01;
    if (m02 != null) result.m02 = m02;
    if (m03 != null) result.m03 = m03;
    if (m10 != null) result.m10 = m10;
    if (m11 != null) result.m11 = m11;
    if (m12 != null) result.m12 = m12;
    if (m13 != null) result.m13 = m13;
    if (m20 != null) result.m20 = m20;
    if (m21 != null) result.m21 = m21;
    if (m22 != null) result.m22 = m22;
    if (m23 != null) result.m23 = m23;
    if (m30 != null) result.m30 = m30;
    if (m31 != null) result.m31 = m31;
    if (m32 != null) result.m32 = m32;
    if (m33 != null) result.m33 = m33;
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'm00')
    ..aD(2, _omitFieldNames ? '' : 'm01')
    ..aD(3, _omitFieldNames ? '' : 'm02')
    ..aD(4, _omitFieldNames ? '' : 'm03')
    ..aD(5, _omitFieldNames ? '' : 'm10')
    ..aD(6, _omitFieldNames ? '' : 'm11')
    ..aD(7, _omitFieldNames ? '' : 'm12')
    ..aD(8, _omitFieldNames ? '' : 'm13')
    ..aD(9, _omitFieldNames ? '' : 'm20')
    ..aD(10, _omitFieldNames ? '' : 'm21')
    ..aD(11, _omitFieldNames ? '' : 'm22')
    ..aD(12, _omitFieldNames ? '' : 'm23')
    ..aD(13, _omitFieldNames ? '' : 'm30')
    ..aD(14, _omitFieldNames ? '' : 'm31')
    ..aD(15, _omitFieldNames ? '' : 'm32')
    ..aD(16, _omitFieldNames ? '' : 'm33')
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
  $core.double get m00 => $_getN(0);
  @$pb.TagNumber(1)
  set m00($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasM00() => $_has(0);
  @$pb.TagNumber(1)
  void clearM00() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get m01 => $_getN(1);
  @$pb.TagNumber(2)
  set m01($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasM01() => $_has(1);
  @$pb.TagNumber(2)
  void clearM01() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get m02 => $_getN(2);
  @$pb.TagNumber(3)
  set m02($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasM02() => $_has(2);
  @$pb.TagNumber(3)
  void clearM02() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get m03 => $_getN(3);
  @$pb.TagNumber(4)
  set m03($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasM03() => $_has(3);
  @$pb.TagNumber(4)
  void clearM03() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get m10 => $_getN(4);
  @$pb.TagNumber(5)
  set m10($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasM10() => $_has(4);
  @$pb.TagNumber(5)
  void clearM10() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get m11 => $_getN(5);
  @$pb.TagNumber(6)
  set m11($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasM11() => $_has(5);
  @$pb.TagNumber(6)
  void clearM11() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get m12 => $_getN(6);
  @$pb.TagNumber(7)
  set m12($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasM12() => $_has(6);
  @$pb.TagNumber(7)
  void clearM12() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get m13 => $_getN(7);
  @$pb.TagNumber(8)
  set m13($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasM13() => $_has(7);
  @$pb.TagNumber(8)
  void clearM13() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get m20 => $_getN(8);
  @$pb.TagNumber(9)
  set m20($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasM20() => $_has(8);
  @$pb.TagNumber(9)
  void clearM20() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get m21 => $_getN(9);
  @$pb.TagNumber(10)
  set m21($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasM21() => $_has(9);
  @$pb.TagNumber(10)
  void clearM21() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get m22 => $_getN(10);
  @$pb.TagNumber(11)
  set m22($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasM22() => $_has(10);
  @$pb.TagNumber(11)
  void clearM22() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get m23 => $_getN(11);
  @$pb.TagNumber(12)
  set m23($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasM23() => $_has(11);
  @$pb.TagNumber(12)
  void clearM23() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get m30 => $_getN(12);
  @$pb.TagNumber(13)
  set m30($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasM30() => $_has(12);
  @$pb.TagNumber(13)
  void clearM30() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get m31 => $_getN(13);
  @$pb.TagNumber(14)
  set m31($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasM31() => $_has(13);
  @$pb.TagNumber(14)
  void clearM31() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get m32 => $_getN(14);
  @$pb.TagNumber(15)
  set m32($core.double value) => $_setDouble(14, value);
  @$pb.TagNumber(15)
  $core.bool hasM32() => $_has(14);
  @$pb.TagNumber(15)
  void clearM32() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get m33 => $_getN(15);
  @$pb.TagNumber(16)
  set m33($core.double value) => $_setDouble(15, value);
  @$pb.TagNumber(16)
  $core.bool hasM33() => $_has(15);
  @$pb.TagNumber(16)
  void clearM33() => $_clearField(16);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
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

class Size2 extends $pb.GeneratedMessage {
  factory Size2({
    $core.double? width,
    $core.double? height,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  Size2._();

  factory Size2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Size2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Size2',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'width')
    ..aD(2, _omitFieldNames ? '' : 'height')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Size2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Size2 copyWith(void Function(Size2) updates) =>
      super.copyWith((message) => updates(message as Size2)) as Size2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Size2 create() => Size2._();
  @$core.override
  Size2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Size2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Size2>(create);
  static Size2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);
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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
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

class ColorData_Hsv extends $pb.GeneratedMessage {
  factory ColorData_Hsv({
    $core.double? h,
    $core.double? s,
    $core.double? v,
  }) {
    final result = create();
    if (h != null) result.h = h;
    if (s != null) result.s = s;
    if (v != null) result.v = v;
    return result;
  }

  ColorData_Hsv._();

  factory ColorData_Hsv.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ColorData_Hsv.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorData.Hsv',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'h')
    ..aD(2, _omitFieldNames ? '' : 's')
    ..aD(3, _omitFieldNames ? '' : 'v')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorData_Hsv clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorData_Hsv copyWith(void Function(ColorData_Hsv) updates) =>
      super.copyWith((message) => updates(message as ColorData_Hsv))
          as ColorData_Hsv;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ColorData_Hsv create() => ColorData_Hsv._();
  @$core.override
  ColorData_Hsv createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ColorData_Hsv getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ColorData_Hsv>(create);
  static ColorData_Hsv? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get h => $_getN(0);
  @$pb.TagNumber(1)
  set h($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasH() => $_has(0);
  @$pb.TagNumber(1)
  void clearH() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get s => $_getN(1);
  @$pb.TagNumber(2)
  set s($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasS() => $_has(1);
  @$pb.TagNumber(2)
  void clearS() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get v => $_getN(2);
  @$pb.TagNumber(3)
  set v($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasV() => $_has(2);
  @$pb.TagNumber(3)
  void clearV() => $_clearField(3);
}

enum ColorData_Value { hsv, notSet }

class ColorData extends $pb.GeneratedMessage {
  factory ColorData({
    ColorData_Hsv? hsv,
    $core.double? alpha,
  }) {
    final result = create();
    if (hsv != null) result.hsv = hsv;
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

  static const $core.Map<$core.int, ColorData_Value> _ColorData_ValueByTag = {
    1: ColorData_Value.hsv,
    0: ColorData_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<ColorData_Hsv>(1, _omitFieldNames ? '' : 'hsv',
        subBuilder: ColorData_Hsv.create)
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
  ColorData_Value whichValue() => _ColorData_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ColorData_Hsv get hsv => $_getN(0);
  @$pb.TagNumber(1)
  set hsv(ColorData_Hsv value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHsv() => $_has(0);
  @$pb.TagNumber(1)
  void clearHsv() => $_clearField(1);
  @$pb.TagNumber(1)
  ColorData_Hsv ensureHsv() => $_ensure(0);

  @$pb.TagNumber(5)
  $core.double get alpha => $_getN(1);
  @$pb.TagNumber(5)
  set alpha($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(5)
  $core.bool hasAlpha() => $_has(1);
  @$pb.TagNumber(5)
  void clearAlpha() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
