// This is a generated file - do not edit.
//
// Generated from server.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'program.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Client extends $pb.GeneratedMessage {
  factory Client({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  Client._();

  factory Client.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Client.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Client',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Client clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Client copyWith(void Function(Client) updates) =>
      super.copyWith((message) => updates(message as Client)) as Client;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Client create() => Client._();
  @$core.override
  Client createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Client getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Client>(create);
  static Client? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class CreateSceneRequest extends $pb.GeneratedMessage {
  factory CreateSceneRequest({
    $0.Program? program,
  }) {
    final result = create();
    if (program != null) result.program = program;
    return result;
  }

  CreateSceneRequest._();

  factory CreateSceneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateSceneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateSceneRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.Program>(1, _omitFieldNames ? '' : 'program',
        subBuilder: $0.Program.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSceneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSceneRequest copyWith(void Function(CreateSceneRequest) updates) =>
      super.copyWith((message) => updates(message as CreateSceneRequest))
          as CreateSceneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSceneRequest create() => CreateSceneRequest._();
  @$core.override
  CreateSceneRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateSceneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateSceneRequest>(create);
  static CreateSceneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Program get program => $_getN(0);
  @$pb.TagNumber(1)
  set program($0.Program value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgram() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgram() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Program ensureProgram() => $_ensure(0);
}

class CreateSceneResponse extends $pb.GeneratedMessage {
  factory CreateSceneResponse({
    $core.String? id,
    $0.Program? program,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (program != null) result.program = program;
    return result;
  }

  CreateSceneResponse._();

  factory CreateSceneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateSceneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateSceneResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.Program>(2, _omitFieldNames ? '' : 'program',
        subBuilder: $0.Program.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSceneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateSceneResponse copyWith(void Function(CreateSceneResponse) updates) =>
      super.copyWith((message) => updates(message as CreateSceneResponse))
          as CreateSceneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSceneResponse create() => CreateSceneResponse._();
  @$core.override
  CreateSceneResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateSceneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateSceneResponse>(create);
  static CreateSceneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Program get program => $_getN(1);
  @$pb.TagNumber(2)
  set program($0.Program value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgram() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgram() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Program ensureProgram() => $_ensure(1);
}

class GetSceneRequest extends $pb.GeneratedMessage {
  factory GetSceneRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetSceneRequest._();

  factory GetSceneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSceneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSceneRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSceneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSceneRequest copyWith(void Function(GetSceneRequest) updates) =>
      super.copyWith((message) => updates(message as GetSceneRequest))
          as GetSceneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSceneRequest create() => GetSceneRequest._();
  @$core.override
  GetSceneRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSceneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSceneRequest>(create);
  static GetSceneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetSceneResponse extends $pb.GeneratedMessage {
  factory GetSceneResponse({
    $0.Program? program,
  }) {
    final result = create();
    if (program != null) result.program = program;
    return result;
  }

  GetSceneResponse._();

  factory GetSceneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSceneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSceneResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.Program>(1, _omitFieldNames ? '' : 'program',
        subBuilder: $0.Program.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSceneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSceneResponse copyWith(void Function(GetSceneResponse) updates) =>
      super.copyWith((message) => updates(message as GetSceneResponse))
          as GetSceneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSceneResponse create() => GetSceneResponse._();
  @$core.override
  GetSceneResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSceneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSceneResponse>(create);
  static GetSceneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Program get program => $_getN(0);
  @$pb.TagNumber(1)
  set program($0.Program value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgram() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgram() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Program ensureProgram() => $_ensure(0);
}

class ClientPresence extends $pb.GeneratedMessage {
  factory ClientPresence({
    Client? client,
    $0.Vec2? pointerPosition,
    $core.String? pointerType,
  }) {
    final result = create();
    if (client != null) result.client = client;
    if (pointerPosition != null) result.pointerPosition = pointerPosition;
    if (pointerType != null) result.pointerType = pointerType;
    return result;
  }

  ClientPresence._();

  factory ClientPresence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientPresence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientPresence',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<Client>(1, _omitFieldNames ? '' : 'client', subBuilder: Client.create)
    ..aOM<$0.Vec2>(2, _omitFieldNames ? '' : 'pointerPosition',
        subBuilder: $0.Vec2.create)
    ..aOS(3, _omitFieldNames ? '' : 'pointerType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientPresence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientPresence copyWith(void Function(ClientPresence) updates) =>
      super.copyWith((message) => updates(message as ClientPresence))
          as ClientPresence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientPresence create() => ClientPresence._();
  @$core.override
  ClientPresence createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientPresence getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientPresence>(create);
  static ClientPresence? _defaultInstance;

  @$pb.TagNumber(1)
  Client get client => $_getN(0);
  @$pb.TagNumber(1)
  set client(Client value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClient() => $_has(0);
  @$pb.TagNumber(1)
  void clearClient() => $_clearField(1);
  @$pb.TagNumber(1)
  Client ensureClient() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Vec2 get pointerPosition => $_getN(1);
  @$pb.TagNumber(2)
  set pointerPosition($0.Vec2 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPointerPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPointerPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Vec2 ensurePointerPosition() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get pointerType => $_getSZ(2);
  @$pb.TagNumber(3)
  set pointerType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPointerType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPointerType() => $_clearField(3);
}

class ClientDelta extends $pb.GeneratedMessage {
  factory ClientDelta({
    $0.ProgramDelta? delta,
    Client? client,
  }) {
    final result = create();
    if (delta != null) result.delta = delta;
    if (client != null) result.client = client;
    return result;
  }

  ClientDelta._();

  factory ClientDelta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientDelta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientDelta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.ProgramDelta>(1, _omitFieldNames ? '' : 'delta',
        subBuilder: $0.ProgramDelta.create)
    ..aOM<Client>(2, _omitFieldNames ? '' : 'client', subBuilder: Client.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientDelta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientDelta copyWith(void Function(ClientDelta) updates) =>
      super.copyWith((message) => updates(message as ClientDelta))
          as ClientDelta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientDelta create() => ClientDelta._();
  @$core.override
  ClientDelta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientDelta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientDelta>(create);
  static ClientDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ProgramDelta get delta => $_getN(0);
  @$pb.TagNumber(1)
  set delta($0.ProgramDelta value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDelta() => $_has(0);
  @$pb.TagNumber(1)
  void clearDelta() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ProgramDelta ensureDelta() => $_ensure(0);

  @$pb.TagNumber(2)
  Client get client => $_getN(1);
  @$pb.TagNumber(2)
  set client(Client value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasClient() => $_has(1);
  @$pb.TagNumber(2)
  void clearClient() => $_clearField(2);
  @$pb.TagNumber(2)
  Client ensureClient() => $_ensure(1);
}

class Snapshot extends $pb.GeneratedMessage {
  factory Snapshot({
    $0.Program? program,
    $core.Iterable<ClientPresence>? clients,
  }) {
    final result = create();
    if (program != null) result.program = program;
    if (clients != null) result.clients.addAll(clients);
    return result;
  }

  Snapshot._();

  factory Snapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Snapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Snapshot',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<$0.Program>(1, _omitFieldNames ? '' : 'program',
        subBuilder: $0.Program.create)
    ..pPM<ClientPresence>(2, _omitFieldNames ? '' : 'clients',
        subBuilder: ClientPresence.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Snapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Snapshot copyWith(void Function(Snapshot) updates) =>
      super.copyWith((message) => updates(message as Snapshot)) as Snapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Snapshot create() => Snapshot._();
  @$core.override
  Snapshot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Snapshot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Snapshot>(create);
  static Snapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Program get program => $_getN(0);
  @$pb.TagNumber(1)
  set program($0.Program value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProgram() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgram() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Program ensureProgram() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ClientPresence> get clients => $_getList(1);
}

enum ClientEvent_Event { presence, delta, notSet }

class ClientEvent extends $pb.GeneratedMessage {
  factory ClientEvent({
    ClientPresence? presence,
    ClientDelta? delta,
  }) {
    final result = create();
    if (presence != null) result.presence = presence;
    if (delta != null) result.delta = delta;
    return result;
  }

  ClientEvent._();

  factory ClientEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClientEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientEvent_Event> _ClientEvent_EventByTag =
      {
    1: ClientEvent_Event.presence,
    2: ClientEvent_Event.delta,
    0: ClientEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<ClientPresence>(1, _omitFieldNames ? '' : 'presence',
        subBuilder: ClientPresence.create)
    ..aOM<ClientDelta>(2, _omitFieldNames ? '' : 'delta',
        subBuilder: ClientDelta.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientEvent copyWith(void Function(ClientEvent) updates) =>
      super.copyWith((message) => updates(message as ClientEvent))
          as ClientEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClientEvent create() => ClientEvent._();
  @$core.override
  ClientEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClientEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClientEvent>(create);
  static ClientEvent? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  ClientEvent_Event whichEvent() => _ClientEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ClientPresence get presence => $_getN(0);
  @$pb.TagNumber(1)
  set presence(ClientPresence value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPresence() => $_has(0);
  @$pb.TagNumber(1)
  void clearPresence() => $_clearField(1);
  @$pb.TagNumber(1)
  ClientPresence ensurePresence() => $_ensure(0);

  @$pb.TagNumber(2)
  ClientDelta get delta => $_getN(1);
  @$pb.TagNumber(2)
  set delta(ClientDelta value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDelta() => $_has(1);
  @$pb.TagNumber(2)
  void clearDelta() => $_clearField(2);
  @$pb.TagNumber(2)
  ClientDelta ensureDelta() => $_ensure(1);
}

enum ServerEvent_Event { snapshot, presence, delta, left, notSet }

class ServerEvent extends $pb.GeneratedMessage {
  factory ServerEvent({
    Snapshot? snapshot,
    ClientPresence? presence,
    ClientDelta? delta,
    Client? left,
  }) {
    final result = create();
    if (snapshot != null) result.snapshot = snapshot;
    if (presence != null) result.presence = presence;
    if (delta != null) result.delta = delta;
    if (left != null) result.left = left;
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
    2: ServerEvent_Event.presence,
    3: ServerEvent_Event.delta,
    4: ServerEvent_Event.left,
    0: ServerEvent_Event.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<Snapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: Snapshot.create)
    ..aOM<ClientPresence>(2, _omitFieldNames ? '' : 'presence',
        subBuilder: ClientPresence.create)
    ..aOM<ClientDelta>(3, _omitFieldNames ? '' : 'delta',
        subBuilder: ClientDelta.create)
    ..aOM<Client>(4, _omitFieldNames ? '' : 'left', subBuilder: Client.create)
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
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ServerEvent_Event whichEvent() => _ServerEvent_EventByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearEvent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Snapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(Snapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  Snapshot ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  ClientPresence get presence => $_getN(1);
  @$pb.TagNumber(2)
  set presence(ClientPresence value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPresence() => $_has(1);
  @$pb.TagNumber(2)
  void clearPresence() => $_clearField(2);
  @$pb.TagNumber(2)
  ClientPresence ensurePresence() => $_ensure(1);

  @$pb.TagNumber(3)
  ClientDelta get delta => $_getN(2);
  @$pb.TagNumber(3)
  set delta(ClientDelta value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDelta() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelta() => $_clearField(3);
  @$pb.TagNumber(3)
  ClientDelta ensureDelta() => $_ensure(2);

  @$pb.TagNumber(4)
  Client get left => $_getN(3);
  @$pb.TagNumber(4)
  set left(Client value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearLeft() => $_clearField(4);
  @$pb.TagNumber(4)
  Client ensureLeft() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
