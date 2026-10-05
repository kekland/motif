// This is a generated file - do not edit.
//
// Generated from packages/skia/skia.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Path extends $pb.GeneratedMessage {
  factory Path({
    $core.Iterable<$core.double>? points,
    $core.Iterable<$core.int>? verbs,
  }) {
    final result = create();
    if (points != null) result.points.addAll(points);
    if (verbs != null) result.verbs.addAll(verbs);
    return result;
  }

  Path._();

  factory Path.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Path.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Path',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'skia'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'points', $pb.PbFieldType.KF)
    ..p<$core.int>(2, _omitFieldNames ? '' : 'verbs', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Path clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Path copyWith(void Function(Path) updates) =>
      super.copyWith((message) => updates(message as Path)) as Path;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Path create() => Path._();
  @$core.override
  Path createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Path getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Path>(create);
  static Path? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get points => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.int> get verbs => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
