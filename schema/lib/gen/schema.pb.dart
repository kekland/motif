// This is a generated file - do not edit.
//
// Generated from schema.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'scene.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ServerEvent_Event { snapshot, delta, notSet }

class ServerEvent extends $pb.GeneratedMessage {
  factory ServerEvent({
    $0.Scene? snapshot,
    DeltaBatch? delta,
  }) {
    final result = create();
    if (snapshot != null) result.snapshot = snapshot;
    if (delta != null) result.delta = delta;
    return result;
  }

  ServerEvent._();

  factory ServerEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerEvent_Event> _ServerEvent_EventByTag =
      {
    1: ServerEvent_Event.snapshot,
    2: ServerEvent_Event.delta,
    0: ServerEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerEvent',
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<$0.Scene>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: $0.Scene.create)
    ..aOM<DeltaBatch>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: DeltaBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEvent copyWith(void Function(ServerEvent) updates) =>
      super.copyWith((message) => updates(message as ServerEvent))
          as ServerEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerEvent create() => ServerEvent._();
  @$core.override
  ServerEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerEvent>(create);
  static ServerEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  ServerEvent_Event whichEvent() => _ServerEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Scene get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot($0.Scene value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Scene ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  DeltaBatch get delta => $_getN(1);
  @$pb.TagNumber(2)
  set delta(DeltaBatch value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDelta() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelta() => $_clearField(2);
  @$pb.TagNumber(2)
  DeltaBatch ensureDelta() => $_ensure(1);
}

enum Anchor_Anchor { start, after, at, end, notSet }

class Anchor extends $pb.GeneratedMessage {
  factory Anchor({
    $core.bool? start,
    $0.StatementId? after,
    $0.StatementId? at,
    $core.bool? end,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (after != null) result.after = after;
    if (at != null) result.at = at;
    if (end != null) result.end = end;
    return result;
  }

  Anchor._();

  factory Anchor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Anchor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Anchor_Anchor> _Anchor_AnchorByTag = {
    1: Anchor_Anchor.start,
    2: Anchor_Anchor.after,
    3: Anchor_Anchor.at,
    4: Anchor_Anchor.end,
    0: Anchor_Anchor.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Anchor',
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOB(1, _omitFieldNames ? '' : 'start')
    ..aOM<$0.StatementId>(2, _omitFieldNames ? '' : 'after',
        subBuilder: $0.StatementId.create)
    ..aOM<$0.StatementId>(3, _omitFieldNames ? '' : 'at',
        subBuilder: $0.StatementId.create)
    ..aOB(4, _omitFieldNames ? '' : 'end')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Anchor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Anchor copyWith(void Function(Anchor) updates) =>
      super.copyWith((message) => updates(message as Anchor)) as Anchor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Anchor create() => Anchor._();
  @$core.override
  Anchor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Anchor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Anchor>(create);
  static Anchor? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Anchor_Anchor whichAnchor() => _Anchor_AnchorByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearAnchor() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get start => $_getBF(0);
  @$pb.TagNumber(1)
  set start($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StatementId get after => $_getN(1);
  @$pb.TagNumber(2)
  set after($0.StatementId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StatementId ensureAfter() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.StatementId get at => $_getN(2);
  @$pb.TagNumber(3)
  set at($0.StatementId value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.StatementId ensureAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get end => $_getBF(3);
  @$pb.TagNumber(4)
  set end($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnd() => $_clearField(4);
}

class ProgramDelta extends $pb.GeneratedMessage {
  factory ProgramDelta({
    Anchor? anchor,
    $core.Iterable<$0.StatementId>? removed,
    $core.Iterable<$0.Statement>? inserted,
  }) {
    final result = create();
    if (anchor != null) result.anchor = anchor;
    if (removed != null) result.removed.addAll(removed);
    if (inserted != null) result.inserted.addAll(inserted);
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
      createEmptyInstance: create)
    ..aOM<Anchor>(1, _omitFieldNames ? '' : 'anchor', subBuilder: Anchor.create)
    ..pPM<$0.StatementId>(2, _omitFieldNames ? '' : 'removed',
        subBuilder: $0.StatementId.create)
    ..pPM<$0.Statement>(3, _omitFieldNames ? '' : 'inserted',
        subBuilder: $0.Statement.create)
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
  Anchor get anchor => $_getN(0);
  @$pb.TagNumber(1)
  set anchor(Anchor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAnchor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnchor() => $_clearField(1);
  @$pb.TagNumber(1)
  Anchor ensureAnchor() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$0.StatementId> get removed => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$0.Statement> get inserted => $_getList(2);
}

enum Delta_Delta { program, notSet }

class Delta extends $pb.GeneratedMessage {
  factory Delta({
    ProgramDelta? program,
  }) {
    final result = create();
    if (program != null) result.program = program;
    return result;
  }

  Delta._();

  factory Delta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Delta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Delta_Delta> _Delta_DeltaByTag = {
    1: Delta_Delta.program,
    0: Delta_Delta.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Delta',
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<ProgramDelta>(1, _omitFieldNames ? '' : 'program',
        subBuilder: ProgramDelta.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Delta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Delta copyWith(void Function(Delta) updates) =>
      super.copyWith((message) => updates(message as Delta)) as Delta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Delta create() => Delta._();
  @$core.override
  Delta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Delta getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Delta>(create);
  static Delta? _defaultInstance;

  @$pb.TagNumber(1)
  Delta_Delta whichDelta() => _Delta_DeltaByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearDelta() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ProgramDelta get program => $_getN(0);
  @$pb.TagNumber(1)
  set program(ProgramDelta value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgram() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgram() => $_clearField(1);
  @$pb.TagNumber(1)
  ProgramDelta ensureProgram() => $_ensure(0);
}

class DeltaBatch extends $pb.GeneratedMessage {
  factory DeltaBatch({
    $core.Iterable<Delta>? deltas,
  }) {
    final result = create();
    if (deltas != null) result.deltas.addAll(deltas);
    return result;
  }

  DeltaBatch._();

  factory DeltaBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeltaBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeltaBatch',
      createEmptyInstance: create)
    ..pPM<Delta>(1, _omitFieldNames ? '' : 'deltas', subBuilder: Delta.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeltaBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeltaBatch copyWith(void Function(DeltaBatch) updates) =>
      super.copyWith((message) => updates(message as DeltaBatch)) as DeltaBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeltaBatch create() => DeltaBatch._();
  @$core.override
  DeltaBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeltaBatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeltaBatch>(create);
  static DeltaBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Delta> get deltas => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
