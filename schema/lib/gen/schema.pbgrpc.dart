// This is a generated file - do not edit.
//
// Generated from schema.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'schema.pb.dart' as $0;

export 'schema.pb.dart';

@$pb.GrpcServiceName('SceneSync')
class SceneSyncClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SceneSyncClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseStream<$0.ServerEvent> sync(
    $async.Stream<$0.DeltaBatch> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$sync, request, options: options);
  }

  // method descriptors

  static final _$sync = $grpc.ClientMethod<$0.DeltaBatch, $0.ServerEvent>(
      '/SceneSync/Sync',
      ($0.DeltaBatch value) => value.writeToBuffer(),
      $0.ServerEvent.fromBuffer);
}

@$pb.GrpcServiceName('SceneSync')
abstract class SceneSyncServiceBase extends $grpc.Service {
  $core.String get $name => 'SceneSync';

  SceneSyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.DeltaBatch, $0.ServerEvent>(
        'Sync',
        sync,
        true,
        true,
        ($core.List<$core.int> value) => $0.DeltaBatch.fromBuffer(value),
        ($0.ServerEvent value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ServerEvent> sync(
      $grpc.ServiceCall call, $async.Stream<$0.DeltaBatch> request);
}
