// This is a generated file - do not edit.
//
// Generated from packages/blueprint/blueprint.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class NodeId extends $pb.GeneratedMessage {
  factory NodeId({
    $core.int? value,
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
    ..aI(1, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OU3)
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
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class SocketRef extends $pb.GeneratedMessage {
  factory SocketRef({
    NodeId? node,
    $core.int? index,
  }) {
    final result = create();
    if (node != null) result.node = node;
    if (index != null) result.index = index;
    return result;
  }

  SocketRef._();

  factory SocketRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SocketRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SocketRef',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<NodeId>(1, _omitFieldNames ? '' : 'node', subBuilder: NodeId.create)
    ..aI(2, _omitFieldNames ? '' : 'index', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SocketRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SocketRef copyWith(void Function(SocketRef) updates) =>
      super.copyWith((message) => updates(message as SocketRef)) as SocketRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SocketRef create() => SocketRef._();
  @$core.override
  SocketRef createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SocketRef getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SocketRef>(create);
  static SocketRef? _defaultInstance;

  @$pb.TagNumber(1)
  NodeId get node => $_getN(0);
  @$pb.TagNumber(1)
  set node(NodeId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNode() => $_has(0);
  @$pb.TagNumber(1)
  void clearNode() => $_clearField(1);
  @$pb.TagNumber(1)
  NodeId ensureNode() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => $_clearField(2);
}

class Connection extends $pb.GeneratedMessage {
  factory Connection({
    SocketRef? output,
    SocketRef? input,
  }) {
    final result = create();
    if (output != null) result.output = output;
    if (input != null) result.input = input;
    return result;
  }

  Connection._();

  factory Connection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Connection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Connection',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'motif'),
      createEmptyInstance: create)
    ..aOM<SocketRef>(1, _omitFieldNames ? '' : 'output',
        subBuilder: SocketRef.create)
    ..aOM<SocketRef>(2, _omitFieldNames ? '' : 'input',
        subBuilder: SocketRef.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Connection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Connection copyWith(void Function(Connection) updates) =>
      super.copyWith((message) => updates(message as Connection)) as Connection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Connection create() => Connection._();
  @$core.override
  Connection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Connection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Connection>(create);
  static Connection? _defaultInstance;

  @$pb.TagNumber(1)
  SocketRef get output => $_getN(0);
  @$pb.TagNumber(1)
  set output(SocketRef value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutput() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutput() => $_clearField(1);
  @$pb.TagNumber(1)
  SocketRef ensureOutput() => $_ensure(0);

  @$pb.TagNumber(2)
  SocketRef get input => $_getN(1);
  @$pb.TagNumber(2)
  set input(SocketRef value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInput() => $_has(1);
  @$pb.TagNumber(2)
  void clearInput() => $_clearField(2);
  @$pb.TagNumber(2)
  SocketRef ensureInput() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
